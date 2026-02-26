import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/hadith_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/islamic_decoration.dart';
import '../data/hadiths_data.dart';
import 'hadith_detail_screen.dart';
import 'category_hadiths_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HadithProvider>();
    final hadithOfDay = provider.hadithOfTheDay;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'Hadisaaji',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryGreen,
                      AppColors.primaryGreenDark,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'هديسعاجي',
                        style: TextStyle(
                          fontSize: 36,
                          color: AppColors.goldAccent.withValues(alpha: 0.9),
                          fontFamily: 'Traditional Arabic',
                        ),
                      ),
                      Text(
                        'Hadiisaaji Annabi ﷺ e Pulaar',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === HADITH DU JOUR ===
                  Text(
                    'Hadiis Ñalngu Hannde',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.primaryGreen,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Hadith du jour",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),

                  // Hadith of the day card
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HadithDetailScreen(hadith: hadithOfDay),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primaryGreen,
                            AppColors.primaryGreenDark,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                AppColors.primaryGreen.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Chapter title
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.goldAccent
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    hadithOfDay.category,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.goldLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '#${hadithOfDay.id}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color:
                                        Colors.white.withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Arabic preview
                            Text(
                              hadithOfDay.arabicText.split('\n').first,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                height: 1.8,
                                color:
                                    AppColors.goldAccent.withValues(alpha: 0.9),
                                fontFamily: 'Traditional Arabic',
                              ),
                            ),

                            // Decorative divider
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 1,
                                    color: AppColors.goldAccent
                                        .withValues(alpha: 0.4),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.star,
                                        size: 10, color: AppColors.goldAccent),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 1,
                                    color: AppColors.goldAccent
                                        .withValues(alpha: 0.4),
                                  ),
                                ],
                              ),
                            ),

                            // Pulaar preview
                            Text(
                              hadithOfDay.chapterTitle,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              hadithOfDay.pulaarTranslation,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color:
                                    Colors.white.withValues(alpha: 0.85),
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Tar ngam janngude →',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.goldLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // === CATEGORIES ===
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pecce',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.primaryGreen,
                                ),
                      ),
                      Text(
                        'Catégories',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Categories grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CategoryHadithsScreen(category: cat),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  AppColors.goldAccent.withValues(alpha: 0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cat.icon,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryGreen,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                cat.nameArabic,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.goldAccent,
                                ),
                              ),
                              Text(
                                '${cat.count} hadiis',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const IslamicDivider(),

                  // === STATISTICS ===
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.goldAccent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.goldAccent.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(
                            context,
                            '${provider.hadiths.length}',
                            'Hadiisaaji',
                            Icons.menu_book),
                        _buildStat(
                            context,
                            '${categories.where((c) => c.count > 0).length}',
                            'Pecce',
                            Icons.category),
                        _buildStat(
                            context,
                            '${provider.favoriteIds.length}',
                            'Cuɓaaɗi',
                            Icons.favorite),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
      BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }
}
