import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/hadith.dart';
import '../providers/hadith_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/hadith_card.dart';

class CategoryHadithsScreen extends StatelessWidget {
  final HadithCategory category;

  const CategoryHadithsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HadithProvider>();
    final hadiths = provider.getHadithsByCategory(category.name);

    return Scaffold(
      appBar: AppBar(
        title: Text('${category.name} - ${category.nameArabic}'),
      ),
      body: hadiths.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.icon,
                    style: const TextStyle(fontSize: 64),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Hadiisaaji ngalaa taw',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hadiisaaji maa ɓeydoyo',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.primaryGreen,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: hadiths.length,
              itemBuilder: (context, index) {
                return HadithCard(
                  hadith: hadiths[index],
                  showChapter: true,
                );
              },
            ),
    );
  }
}
