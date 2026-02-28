import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'config/supabase_config.dart';
import 'providers/hadith_provider.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/hadith_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: SupabaseConfig.projectUrl,
      anonKey: SupabaseConfig.anonKey,
    );
  } catch (e) {
    debugPrint('[main] Supabase init error: $e');
  }

  try {
    await NotificationService.init();
  } catch (e) {
    debugPrint('[main] NotificationService init error: $e');
  }

  // Configure audio session for iOS
  if (Platform.isIOS) {
    final audioContext = AudioContext(
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playback,
        options: {AVAudioSessionOptions.defaultToSpeaker},
      ),
    );
    AudioPlayer.global.setAudioContext(audioContext);
  }

  final hadithProvider = HadithProvider();
  await hadithProvider.init();

  // Lancer les notifications en arrière-plan (non-bloquant)
  hadithProvider.initNotifications().catchError((e) {
    debugPrint('[main] initNotifications error: $e');
  });

  // Configurer le callback quand on clique sur une notification
  NotificationService.onNotificationTap = (hadithId) {
    final hadith = hadithProvider.getHadithById(hadithId);
    if (hadith != null) {
      // Attendre que le navigator soit prêt
      Future.delayed(const Duration(milliseconds: 500), () {
        NotificationService.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: hadithProvider,
              child: HadithDetailScreen(hadith: hadith),
            ),
          ),
        );
      });
    }
  };

  runApp(HadisaajiApp(hadithProvider: hadithProvider));
}

class HadisaajiApp extends StatelessWidget {
  final HadithProvider hadithProvider;

  const HadisaajiApp({super.key, required this.hadithProvider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: hadithProvider,
      child: Consumer<HadithProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Hadisaaji Pulaar',
            navigatorKey: NotificationService.navigatorKey,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(),
            darkTheme: AppTheme.darkTheme(),
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
