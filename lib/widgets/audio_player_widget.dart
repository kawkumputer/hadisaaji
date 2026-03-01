import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../theme/app_theme.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  bool _isPlaying = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _setupListeners();
  }

  void _setupListeners() {
    _player.durationStream.listen((duration) {
      if (mounted && duration != null) setState(() => _duration = duration);
    });
    _player.positionStream.listen((position) {
      if (mounted) setState(() => _position = position);
    });
    _player.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          if (state.processingState == ProcessingState.completed) {
            _isPlaying = false;
            _position = Duration.zero;
            _player.seek(Duration.zero);
            _player.pause();
          }
        });
      }
    });
  }

  /// Downloads audio file to local cache (iOS workaround for wrong MIME type)
  Future<File> _downloadAudio(String url) async {
    final dir = await getTemporaryDirectory();
    final fileName = Uri.parse(url).pathSegments.last;
    final file = File('${dir.path}/$fileName');
    // Use cached file if already downloaded
    if (await file.exists()) {
      debugPrint('[AudioPlayer] Using cached file: ${file.path}');
      return file;
    }
    debugPrint('[AudioPlayer] Downloading to: ${file.path}');
    final response = await http.get(Uri.parse(url));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    try {
      setState(() => _errorMessage = null);
      if (_isPlaying) {
        await _player.pause();
      } else {
        if (!_initialized) {
          setState(() => _isLoading = true);
          debugPrint('[AudioPlayer] Loading URL: ${widget.audioUrl}');
          if (Platform.isIOS) {
            // iOS: download file first because Supabase returns
            // Content-Type: video/mpeg for .mpeg files, which
            // iOS AVPlayer rejects with error -11828
            final file = await _downloadAudio(widget.audioUrl);
            await _player.setFilePath(file.path);
          } else {
            await _player.setUrl(widget.audioUrl);
          }
          _initialized = true;
          setState(() => _isLoading = false);
        }
        await _player.play();
      }
    } catch (e, stack) {
      debugPrint('[AudioPlayer] Error: $e');
      debugPrint('[AudioPlayer] Stack: $stack');
      debugPrint('[AudioPlayer] URL: ${widget.audioUrl}');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Juumre: ${e.toString().length > 120 ? e.toString().substring(0, 120) : e.toString()}';
      });
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _isPlaying;
    final progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withValues(alpha: 0.08),
            AppColors.goldAccent.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.headphones_rounded,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Heɗto sawtowol',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
              const Spacer(),
              Text(
                'الاستماع',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.goldAccent,
                  fontFamily: 'Traditional Arabic',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 6),

          // Time labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Rewind 10s
              IconButton(
                icon: const Icon(Icons.replay_10_rounded),
                color: AppColors.primaryGreen,
                iconSize: 30,
                onPressed: () async {
                  final newPos = _position - const Duration(seconds: 10);
                  await _player.seek(
                    newPos < Duration.zero ? Duration.zero : newPos,
                  );
                },
              ),

              const SizedBox(width: 8),

              // Play / Pause
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGreen, AppColors.primaryGreenDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        color: Colors.white,
                        iconSize: 32,
                        onPressed: _playPause,
                      ),
              ),

              const SizedBox(width: 8),

              // Forward 10s
              IconButton(
                icon: const Icon(Icons.forward_10_rounded),
                color: AppColors.primaryGreen,
                iconSize: 30,
                onPressed: () async {
                  final newPos = _position + const Duration(seconds: 10);
                  await _player.seek(
                    newPos > _duration ? _duration : newPos,
                  );
                },
              ),
            ],
          ),

          // Error message
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.red.shade400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
