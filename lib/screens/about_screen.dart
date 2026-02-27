import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/islamic_decoration.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baɗte App'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Logo / branding
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryGreen.withValues(alpha: 0.08),
                    AppColors.goldAccent.withValues(alpha: 0.08),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  // Islamic star decoration
                  const Icon(
                    Icons.auto_awesome,
                    color: AppColors.goldAccent,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'أحاديث',
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.goldAccent,
                      fontFamily: 'Traditional Arabic',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'HADISAAJI',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryGreen,
                      letterSpacing: 6,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Version 1.0.0',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Njangtuuji (Hadiisaaji) nulaaɗo Alla (jkm) ﷺ\npiraaɗi ummoraade Arab fayde e Pulaar',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMedium,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.goldAccent,
                      fontFamily: 'Traditional Arabic',
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ngam yettude Alla toowɗo oo, min ndokki on o application ngam wallude on janngude hadiisaaji nulaaɗo Alla ﷺ e ɗemngal Pulaar.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMedium,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Hadith source section
            _buildInfoCard(
              context,
              icon: Icons.menu_book_rounded,
              title: 'Iwdi Hadiisaaji / Source:',
              children: [
                _buildPersonRow(context, Icons.person, 'Dr Ahmad Abdullaahi Al-Haniyi'),
                const SizedBox(height: 8),
                _buildPersonRow(context, Icons.person, 'Ceerno Usmaan Jam Maalik Bah'),
              ],
            ),

            const SizedBox(height: 12),

            // Translation section
            _buildInfoCard(
              context,
              icon: Icons.translate,
              title: 'Firo e Pulaar / Traduction:',
              children: [
                _buildPersonRow(context, Icons.person, 'Ceerno Abuu Sih'),
              ],
            ),

            const SizedBox(height: 12),

            // Voice section
            _buildInfoCard(
              context,
              icon: Icons.mic,
              title: 'Daande / Voix:',
              children: [
                _buildPersonRow(context, Icons.person, 'Jaambaaro Leñol'),
              ],
            ),

            const SizedBox(height: 12),

            // Developer section
            _buildInfoCard(
              context,
              icon: Icons.code_rounded,
              title: 'Peewnuɗo application / Développeur:',
              children: [
                _buildPersonRow(context, Icons.person, 'Hamath Kan'),
              ],
            ),

            const SizedBox(height: 20),

            // Contact section
            _buildInfoCard(
              context,
              icon: Icons.mail_outline_rounded,
              title: 'Jokkondiral / Contact:',
              children: [
                Text(
                  'So oɗon njogii miijooji, wasiyaaji walla naamne, oɗon mbaawi winndude min:',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textMedium,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPersonRow(context, Icons.email, 'Abuu Sih: atumansy6@gmail.com'),
                const SizedBox(height: 8),
                _buildPersonRow(context, Icons.email, 'Hamath Kan: kawkumputer@gmail.com'),
              ],
            ),

            const SizedBox(height: 12),

            // Privacy policy
            InkWell(
              onTap: () => launchUrl(
                Uri.parse('https://kawkumputer.github.io/hadisaaji/privacy-policy.html'),
                mode: LaunchMode.externalApplication,
              ),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.goldAccent.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined, color: AppColors.primaryGreen, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Politique de confidentialité',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Icon(Icons.open_in_new, color: AppColors.textLight, size: 18),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              Icon(icon, color: AppColors.primaryGreen, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildPersonRow(BuildContext context, IconData icon, String name) {
    return Row(
      children: [
        Icon(icon, color: AppColors.goldAccent, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textMedium,
            ),
          ),
        ),
      ],
    );
  }
}
