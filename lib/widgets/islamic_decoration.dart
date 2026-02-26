import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class IslamicDivider extends StatelessWidget {
  const IslamicDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, AppColors.goldAccent],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.star,
              color: AppColors.goldAccent,
              size: 16,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.goldAccent, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArabicTextBox extends StatelessWidget {
  final String text;
  final double fontSize;

  const ArabicTextBox({
    super.key,
    required this.text,
    this.fontSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface
            : AppColors.creamWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.goldAccent.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldAccent.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top ornament
          Icon(
            Icons.auto_awesome,
            color: AppColors.goldAccent.withValues(alpha: 0.6),
            size: 20,
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: fontSize,
              height: 2.0,
              fontFamily: 'Traditional Arabic',
              color: isDark ? AppColors.darkText : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          // Bottom ornament
          Icon(
            Icons.auto_awesome,
            color: AppColors.goldAccent.withValues(alpha: 0.6),
            size: 20,
          ),
        ],
      ),
    );
  }
}

class GoldBorderCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GoldBorderCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.goldAccent.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}
