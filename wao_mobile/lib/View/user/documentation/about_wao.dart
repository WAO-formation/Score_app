import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

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
                  'About WAO',
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
                  // Brand hero card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    decoration: BoxDecoration(
                      color: AppColors.waoNavy,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'WAO',
                          style: GoogleFonts.oswald(
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 8,
                            color: AppColors.waoRed,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'WORLD AS ONE',
                          style: GoogleFonts.oswald(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 4,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 36,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.waoRed,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Championing World Oneness Through Sport',
                            style: GoogleFonts.oswald(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Overview
                  _SectionHeader(title: 'Who We Are', isDark: isDark),
                  const SizedBox(height: 12),
                  _Card(
                    isDark: isDark,
                    child: Text(
                      'Founded in June 2012 by Solomon Kyei, Waoherds Limited pioneers an innovative sport that blends physical gameplay with digital storytelling. We revolutionise sports by integrating technology, community engagement, and entertainment to foster global unity and individual empowerment.',
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.7,
                        color: isDark ? Colors.white70 : AppColors.textSecondary(isDark),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _SectionHeader(title: 'Our Purpose', isDark: isDark),
                  const SizedBox(height: 12),
                  _ValueTile(
                    isDark: isDark,
                    icon: Icons.visibility_outlined,
                    title: 'Vision',
                    text: 'To champion world oneness through innovative sports experiences that blend technology with traditional gameplay.',
                  ),
                  const SizedBox(height: 10),
                  _ValueTile(
                    isDark: isDark,
                    icon: Icons.flag_outlined,
                    title: 'Mission',
                    text: 'Empowering individuals through world-class edutainment and sports development, leveraging success as a catalyst for broader life achievements.',
                  ),
                  const SizedBox(height: 10),
                  _ValueTile(
                    isDark: isDark,
                    icon: Icons.sports_basketball_outlined,
                    title: 'The Sport',
                    text: 'WAO! — a two-ball hand-controlled sport played on the WaoSphere, blending dynamic gameplay with storytelling.',
                  ),

                  const SizedBox(height: 24),

                  _SectionHeader(title: 'Contact Us', isDark: isDark),
                  const SizedBox(height: 12),
                  _Card(
                    isDark: isDark,
                    child: Column(
                      children: [
                        _ContactRow(isDark: isDark, icon: Icons.public_rounded,   text: 'www.waosport.com'),
                        const SizedBox(height: 12),
                        _ContactRow(isDark: isDark, icon: Icons.email_outlined,   text: 'waosport@gmail.com'),
                        const SizedBox(height: 12),
                        _ContactRow(isDark: isDark, icon: Icons.phone_outlined,   text: '+233 242 786 261'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.04)
                          : AppColors.waoNavy.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '© 2026 Waoherds Limited. All rights reserved.',
                      style: GoogleFonts.oswald(
                        fontSize: 12,
                        color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.3),
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

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.isDark});
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.waoRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.oswald(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.waoNavy,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ── Card wrapper ──────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.isDark, required this.child});
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}

// ── Value tile ────────────────────────────────────────────────────────────────

class _ValueTile extends StatelessWidget {
  const _ValueTile({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.text,
  });
  final bool isDark;
  final IconData icon;
  final String title, text;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.waoNavy,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
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
                const SizedBox(height: 5),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: isDark ? Colors.white70 : AppColors.textSecondary(isDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Contact row ───────────────────────────────────────────────────────────────

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.isDark, required this.icon, required this.text});
  final bool isDark;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : AppColors.waoNavy.withOpacity(0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16,
              color: isDark ? Colors.white60 : AppColors.waoNavy),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.5,
            color: isDark ? Colors.white70 : AppColors.textSecondary(isDark),
          ),
        ),
      ],
    );
  }
}
