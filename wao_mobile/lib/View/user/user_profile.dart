import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

import '../../Model/user_model.dart';
import '../../Model/user_provider.dart';
import 'documentation/about_wao.dart';
import 'documentation/how_to_play.dart';
import 'documentation/wao_privacy_policy.dart';
import 'favourites/my_favourites_page.dart';
import 'match_history/fan_match_history_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.userProfile;

        if (user == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final top = MediaQuery.of(context).padding.top;
        final bottomInset = MediaQuery.of(context).padding.bottom;

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Inline header ───────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(20, top + 20, 20, 0),
                child: Text(
                  'Profile',
                  style: GoogleFonts.oswald(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.waoNavy,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  // Clears the floating pill nav bar (~84px), not just the
                  // OS home-indicator inset SafeArea covers — the Logout
                  // button would otherwise sit right behind the bar.
                  padding: EdgeInsets.only(bottom: bottomInset + 84),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Profile card ──────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _ProfileCard(user: user, isDark: isDark),
                      ),

                      const SizedBox(height: 28),

                      // ── Account section ───────────────────────────────
                      _SectionHeader(title: 'Account', isDark: isDark),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _MenuCard(
                          isDark: isDark,
                          items: [
                            _RowItem(
                              icon: Icons.sports_handball_outlined,
                              label: 'How to Play WAO',
                              isDark: isDark,
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const HowToPlayWAO())),
                            ),
                            _RowItem(
                              icon: Icons.favorite_border_rounded,
                              label: 'My Favourites',
                              isDark: isDark,
                              badge: user.favoriteTeamIds.length + user.favoriteMatchIds.length > 0
                                  ? '${user.favoriteTeamIds.length + user.favoriteMatchIds.length}'
                                  : null,
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const MyFavouritesPage())),
                            ),
                            _RowItem(
                              icon: Icons.history_rounded,
                              label: 'Past Games',
                              isDark: isDark,
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const FanMatchHistoryPage())),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Notifications section ─────────────────────────
                      _SectionHeader(title: 'Notifications', isDark: isDark),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _MenuCard(
                          isDark: isDark,
                          items: [
                            _ToggleItem(
                              icon: Icons.notifications_outlined,
                              label: 'Push Notifications',
                              subtitle: 'Match updates & live scores',
                              value: userProvider.userProfile?.notificationsEnabled ?? true,
                              isDark: isDark,
                              onChanged: (v) => userProvider.updateNotifications(push: v),
                            ),
                            _ToggleItem(
                              icon: Icons.email_outlined,
                              label: 'Email Notifications',
                              subtitle: 'Updates sent to your inbox',
                              value: userProvider.userProfile?.emailNotifications ?? false,
                              isDark: isDark,
                              onChanged: (v) => userProvider.updateNotifications(email: v),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Information section ───────────────────────────
                      _SectionHeader(title: 'Information', isDark: isDark),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _MenuCard(
                          isDark: isDark,
                          items: [
                            _RowItem(
                              icon: Icons.info_outline_rounded,
                              label: 'About WAO',
                              isDark: isDark,
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const AboutPage())),
                            ),
                            _RowItem(
                              icon: Icons.privacy_tip_outlined,
                              label: 'Privacy Policy',
                              isDark: isDark,
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const PrivacyPolicyPage())),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Logout ────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _LogoutButton(userProvider: userProvider, isDark: isDark),
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: Text(
                          'Version 1.0.0',
                          style: GoogleFonts.oswald(
                            fontSize: 12,
                            color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.25),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Profile card ──────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.user, required this.isDark});
  final UserProfile user;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final hasTeams = user.totalTeams > 0;
    final hasMatches = user.totalMatches > 0;
    final showRole = user.accountRole != AccountRole.fan;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.waoNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.waoRed,
            ),
            child: Center(
              child: Text(
                user.initials,
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.displayName ?? user.username,
                        style: GoogleFonts.oswald(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showRole) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.waoRed,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          user.accountRole.name.toUpperCase(),
                          style: GoogleFonts.oswald(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (hasTeams || hasMatches) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (hasTeams) _StatChip(label: '${user.totalTeams} Teams', icon: Icons.groups_rounded),
                      if (hasTeams && hasMatches) const SizedBox(width: 8),
                      if (hasMatches) _StatChip(label: '${user.totalMatches} Matches', icon: Icons.sports_rounded),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.waoYellow),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.oswald(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
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
      ),
    );
  }
}

// ── Menu card ─────────────────────────────────────────────────────────────────

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.isDark, required this.items});
  final bool isDark;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 56,
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : AppColors.waoNavy.withOpacity(0.06),
              ),
          ],
        ],
      ),
    );
  }
}

// ── Row item ──────────────────────────────────────────────────────────────────

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.icon,
    required this.label,
    required this.isDark,
    this.onTap,
    this.badge,
  });
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback? onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : AppColors.waoNavy.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18,
                  color: isDark ? Colors.white70 : AppColors.waoNavy),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.oswald(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                ),
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.waoRed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge!,
                  style: GoogleFonts.oswald(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.waoRed,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.25),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Toggle item ───────────────────────────────────────────────────────────────

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });
  final IconData icon;
  final String label, subtitle;
  final bool value, isDark;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : AppColors.waoNavy.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18,
                color: isDark ? Colors.white70 : AppColors.waoNavy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.oswald(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : AppColors.waoNavy,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.waoRed,
          ),
        ],
      ),
    );
  }
}

// ── Logout button ─────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.userProvider, required this.isDark});
  final UserProvider userProvider;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirm(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.waoRed.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.waoRed.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, color: AppColors.waoRed, size: 20),
            const SizedBox(width: 10),
            Text(
              'Log Out',
              style: GoogleFonts.oswald(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.waoRed,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Log Out',
            style: GoogleFonts.oswald(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.waoNavy,
            )),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black45,
                )),
          ),
          TextButton(
            onPressed: () {
              // No loading dialog here on purpose: signOut() fires
              // AuthGate's auth-state listener almost immediately, which
              // swaps this whole screen out for SplashScreen — that swap
              // IS the feedback. A dialog pushed here raced that swap and
              // could get orphaned (this button's context torn down before
              // the matching Navigator.pop ran), leaving a permanent,
              // barrier-blocking spinner stuck on screen.
              Navigator.pop(context);
              // Not awaited (see note above) — logout() still rethrows on
              // failure for callers that do await it, so swallow it here
              // rather than leaving an unhandled future error.
              unawaited(userProvider.logout().catchError((_) {}));
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.waoRed.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('Log Out',
                  style: GoogleFonts.oswald(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.waoRed,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
