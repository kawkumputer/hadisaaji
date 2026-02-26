import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/hadith_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/islamic_decoration.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HadithProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teelto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === APPEARANCE ===
            _buildSectionTitle(context, 'Njaltudi', 'Apparence'),
            const SizedBox(height: 12),

            // Dark mode
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.2),
                ),
              ),
              child: ListTile(
                leading: Icon(
                  provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppColors.primaryGreen,
                ),
                title: Text(
                  'Niɓɓere / Lewru',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  provider.isDarkMode ? 'Mode sombre' : 'Mode clair',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                trailing: Switch(
                  value: provider.isDarkMode,
                  onChanged: (_) => provider.toggleDarkMode(),
                  activeTrackColor: AppColors.primaryGreen,
                ),
              ),
            ),

            const IslamicDivider(),

            // === NOTIFICATIONS ===
            _buildSectionTitle(context, 'Tintinol', 'Notifications'),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.notifications_active_rounded,
                      color: AppColors.primaryGreen,
                    ),
                    title: Text(
                      'Hadiis Ñalngu',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Notification quotidienne',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    trailing: Switch(
                      value: provider.notificationsEnabled,
                      onChanged: (v) => provider.toggleNotifications(v),
                      activeTrackColor: AppColors.primaryGreen,
                    ),
                  ),
                  if (provider.notificationsEnabled)
                    ListTile(
                      leading: const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.goldAccent,
                      ),
                      title: Text(
                        'Waktu tintinol',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        'Heure : ${provider.notifTime.format(context)}',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppColors.primaryGreen,
                      ),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: provider.notifTime,
                        );
                        if (picked != null) {
                          await provider.setNotifTime(picked);
                        }
                      },
                    ),
                ],
              ),
            ),

            const IslamicDivider(),

            // === FONT SIZE ===
            _buildSectionTitle(context, 'Mawnugol Binndi', 'Taille de police'),
            const SizedBox(height: 12),

            // Arabic font size
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.text_fields,
                          color: AppColors.goldAccent, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Binndi Arab',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${provider.arabicFontSize.round()}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: provider.arabicFontSize,
                    min: 16,
                    max: 36,
                    divisions: 10,
                    activeColor: AppColors.primaryGreen,
                    onChanged: (v) => provider.setArabicFontSize(v),
                  ),
                  // Preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.goldAccent.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: provider.arabicFontSize,
                        fontFamily: 'Traditional Arabic',
                        height: 1.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Pulaar font size
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.text_fields,
                          color: AppColors.primaryGreen, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Binndi Pulaar',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${provider.pulaarFontSize.round()}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: provider.pulaarFontSize,
                    min: 12,
                    max: 26,
                    divisions: 7,
                    activeColor: AppColors.primaryGreen,
                    onChanged: (v) => provider.setPulaarFontSize(v),
                  ),
                  // Preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Bismillaahi Rahmaani Rahiimi',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: provider.pulaarFontSize,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const IslamicDivider(),

            // === ABOUT ===
            _buildSectionTitle(context, 'Baɗte App', 'À propos'),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen.withValues(alpha: 0.08),
                    AppColors.goldAccent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'هديسعاجي',
                    style: TextStyle(
                      fontSize: 32,
                      color: AppColors.goldAccent,
                      fontFamily: 'Traditional Arabic',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'HADISAAJI',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hadiisaaji Annabi Muhammad ﷺ\nfiraaɗi ummoraade Arab to Pulaar',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMedium,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'Imaaraat / Tellindo:',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dr Ahmad Abdullaahi Al-Haniyi',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                  Text(
                    'Ceerno Usmaan Jam Maalik Bah',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                  Text(
                    'Firo: Abuu Sih',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      BuildContext context, String pulaar, String french) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
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
        const SizedBox(width: 8),
        Text(
          french,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}
