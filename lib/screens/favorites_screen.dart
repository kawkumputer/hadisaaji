import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/hadith_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/hadith_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HadithProvider>();
    final favorites = provider.favoriteHadiths;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuɓaaɗi'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: AppColors.goldAccent.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Alaa hadiis cuɓaaɗo taw',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Tar ❤️ dow hadiis ngam ɓeydude ɗum ɗoo',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textLight,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Appuyez sur ❤️ sur un hadith pour l\'ajouter ici',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textLight.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return HadithCard(hadith: favorites[index]);
              },
            ),
    );
  }
}
