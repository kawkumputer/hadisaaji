import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/hadith_provider.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hadithProvider = HadithProvider();
  await hadithProvider.init();
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
            title: 'Hadisaaji',
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
