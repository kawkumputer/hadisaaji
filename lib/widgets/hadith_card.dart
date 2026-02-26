import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/hadith.dart';
import '../providers/hadith_provider.dart';
import '../theme/app_theme.dart';
import '../screens/hadith_detail_screen.dart';

class HadithCard extends StatelessWidget {
  final Hadith hadith;
  final bool showChapter;

  const HadithCard({
    super.key,
    required this.hadith,
    this.showChapter = true,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HadithProvider>();
    final isFav = provider.isFavorite(hadith.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HadithDetailScreen(hadith: hadith),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.goldAccent.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${hadith.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showChapter)
                            Text(
                              hadith.chapterTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: AppColors.primaryGreen,
                                    fontSize: 16,
                                  ),
                            ),
                          Text(
                            hadith.category,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.goldAccent,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav
                            ? AppColors.redAccent
                            : AppColors.textLight,
                      ),
                      onPressed: () => provider.toggleFavorite(hadith.id),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Arabic text preview
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.goldAccent.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    hadith.arabicText.split('\n').first,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.8,
                      fontFamily: 'Traditional Arabic',
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Pulaar preview
                Text(
                  hadith.pulaarTranslation,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                      ),
                ),
                const SizedBox(height: 8),

                // Source
                Row(
                  children: [
                    const Icon(Icons.menu_book,
                        size: 14, color: AppColors.textLight),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hadith.source,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              fontStyle: FontStyle.italic,
                              fontSize: 11,
                            ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios,
                        size: 14, color: AppColors.textLight),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
