import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/hadith_provider.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';
import 'hadith_detail_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const MainScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );

        // Si l'app a été lancée via une notification, ouvrir le hadith
        final payload = NotificationService.pendingPayload;
        if (payload != null) {
          final hadithId = int.tryParse(payload);
          if (hadithId != null) {
            final provider = context.read<HadithProvider>();
            final hadith = provider.getHadithById(hadithId);
            if (hadith != null) {
              Future.delayed(const Duration(milliseconds: 500), () {
                NotificationService.navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: provider,
                      child: HadithDetailScreen(hadith: hadith),
                    ),
                  ),
                );
              });
            }
          }
          NotificationService.clearPendingPayload();
        }
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGreen,
              AppColors.primaryGreenDark,
              Color(0xFF063D32),
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Islamic ornament top
                    Icon(
                      Icons.auto_awesome,
                      color: AppColors.goldAccent.withValues(alpha: 0.7),
                      size: 30,
                    ),
                    const SizedBox(height: 20),

                    // Arabic title
                    Text(
                      'أحاديث',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldAccent,
                        fontFamily: 'Traditional Arabic',
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // App name
                    Text(
                      'HADISAAJI',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 6,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Decorative line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 1.5,
                          color: AppColors.goldAccent.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.star,
                            size: 14,
                            color:
                                AppColors.goldAccent.withValues(alpha: 0.8)),
                        const SizedBox(width: 10),
                        Container(
                          width: 60,
                          height: 1.5,
                          color: AppColors.goldAccent.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      'Njangtuuji (Hadiisaaji) nulaaɗo Alla (jkm) ﷺ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Firo e ɗemngal Pulaar',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.goldLight.withValues(alpha: 0.8),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 50),

                    // Loading indicator
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.goldAccent.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
