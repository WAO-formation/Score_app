import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final top = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Inline header ───────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 20, 20, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.06)
                          : AppColors.waoNavy.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : AppColors.waoNavy.withOpacity(0.1),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'Privacy Policy',
                  style: GoogleFonts.oswald(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.waoNavy,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 84),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.06)
                          : AppColors.waoNavy.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Last updated: February 7, 2026',
                      style: GoogleFonts.oswald(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : AppColors.waoNavy.withOpacity(0.5),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _Section(
                    isDark: isDark,
                    number: '01',
                    title: 'Information We Collect',
                    content:
                        'We collect information you provide directly to us, including:\n\n'
                        '• Account information (name, email, password)\n'
                        '• Profile information\n'
                        '• Team preferences and favourites\n'
                        '• Match engagement data\n'
                        '• Device information and usage statistics',
                  ),
                  _Section(
                    isDark: isDark,
                    number: '02',
                    title: 'How We Use Your Information',
                    content:
                        'We use the information we collect to:\n\n'
                        '• Provide and improve our services\n'
                        '• Personalise your experience\n'
                        '• Send you notifications about matches and updates\n'
                        '• Analyse usage patterns\n'
                        '• Ensure security and prevent fraud',
                  ),
                  _Section(
                    isDark: isDark,
                    number: '03',
                    title: 'Information Sharing',
                    content:
                        'We do not sell your personal information. We may share your information with:\n\n'
                        '• Service providers who assist us\n'
                        '• With your consent\n'
                        '• To comply with legal obligations',
                  ),
                  _Section(
                    isDark: isDark,
                    number: '04',
                    title: 'Data Security',
                    content:
                        'We implement appropriate technical and organisational measures to protect your personal information against unauthorised access, alteration, disclosure, or destruction.',
                  ),
                  _Section(
                    isDark: isDark,
                    number: '05',
                    title: 'Your Rights',
                    content:
                        'You have the right to:\n\n'
                        '• Access your personal data\n'
                        '• Correct inaccurate data\n'
                        '• Request deletion of your data\n'
                        '• Opt-out of marketing communications\n'
                        '• Export your data',
                  ),
                  _Section(
                    isDark: isDark,
                    number: '06',
                    title: 'Cookies & Tracking',
                    content:
                        'We use cookies and similar tracking technologies to collect usage information and improve our services. You can control cookies through your browser settings.',
                  ),
                  _Section(
                    isDark: isDark,
                    number: '07',
                    title: "Children's Privacy",
                    content:
                        'Our service is not directed to children under 13. We do not knowingly collect personal information from children under 13.',
                  ),
                  _Section(
                    isDark: isDark,
                    number: '08',
                    title: 'Contact Us',
                    content:
                        'If you have any questions about this Privacy Policy, please contact us at:\n\nprivacy@wao.com',
                  ),

                  const SizedBox(height: 32),

                  // Footer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.waoNavy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '© 2026 WAO Sports. All rights reserved.',
                      style: GoogleFonts.oswald(
                        fontSize: 12,
                        color: Colors.white54,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.isDark,
    required this.number,
    required this.title,
    required this.content,
  });
  final bool isDark;
  final String number, title, content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : AppColors.waoNavy.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number accent
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.waoNavy,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  number,
                  style: GoogleFonts.oswald(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.waoRed,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.oswald(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.65,
                      color: isDark ? Colors.white70 : AppColors.textSecondary(isDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
