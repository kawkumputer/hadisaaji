import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/hadith.dart';
import '../providers/hadith_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/islamic_decoration.dart';
import '../widgets/audio_player_widget.dart';

class HadithDetailScreen extends StatelessWidget {
  final Hadith hadith;

  const HadithDetailScreen({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HadithProvider>();
    final isFav = provider.isFavorite(hadith.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hadiis #${hadith.id}'),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red.shade300 : Colors.white,
            ),
            onPressed: () => provider.toggleFavorite(hadith.id),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareHadith(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chapter Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.redAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                hadith.chapterTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.redAccent,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Category badge
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  hadith.category,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),

            // === AUDIO PLAYER ===
            if (hadith.audioUrl != null) ...[
              const SizedBox(height: 16),
              AudioPlayerWidget(audioUrl: hadith.audioUrl!),
            ],

            const SizedBox(height: 20),

            // === ARABIC TEXT ===
            _buildSectionHeader(context, 'Binndol Arab', 'النص العربي'),
            const SizedBox(height: 10),
            ArabicTextBox(
              text: hadith.arabicText,
              fontSize: provider.arabicFontSize,
            ),

            const IslamicDivider(),

            // === PULAAR TRANSLATION ===
            _buildSectionHeader(context, 'Firo e Pulaar', 'الترجمة بالفولانية'),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Text(
                hadith.pulaarTranslation,
                style: GoogleFonts.poppins(
                  fontSize: provider.pulaarFontSize,
                  height: 1.8,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),

            // === SOURCE ===
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book,
                      size: 18, color: AppColors.goldAccent),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      hadith.source,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // === EXPLANATION ===
            if (hadith.explanation != null) ...[
              const IslamicDivider(),
              _buildSectionHeader(context, 'Facciro', 'الشرح'),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryGreen.withValues(alpha: 0.15),
                  ),
                ),
                child: Text(
                  hadith.explanation!,
                  style: GoogleFonts.poppins(
                    fontSize: provider.pulaarFontSize - 1,
                    height: 1.7,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],

            // === NOTE (TESKODEN) ===
            if (hadith.note != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.redAccent.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.redAccent.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teskoɗen:',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      hadith.note!,
                      style: GoogleFonts.poppins(
                        fontSize: provider.pulaarFontSize - 1,
                        height: 1.6,
                        color: AppColors.redAccent.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // === AUTHOR ===
            const SizedBox(height: 20),
            Center(
              child: Text(
                hadith.author,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textLight,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String pulaar, String arabic) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          pulaar,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryGreen,
          ),
        ),
        const Spacer(),
        Text(
          arabic,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.goldAccent,
            fontFamily: 'Traditional Arabic',
          ),
        ),
      ],
    );
  }

  void _shareHadith(BuildContext context) {
    final text = '📖 ${hadith.chapterTitle}\n\n'
        '${hadith.arabicText.split('\n').first}\n\n'
        '${hadith.pulaarTranslation}\n\n'
        '📚 ${hadith.source}\n\n'
        '— Hadisaaji App';
    Share.share(text);
  }
}
