import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'package:wao_mobile/core/theme/app_typography.dart';

import '../../Model/user_model.dart';
import '../../Model/user_provider.dart';
import '../../core/theme/theme_provider.dart';
import 'documentation/about_wao.dart';
import 'documentation/how_to_play.dart';
import 'documentation/wao_privacy_policy.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  bool _emailNotifications = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer(
      builder: (BuildContext context, value, Widget? child) {
        return  Scaffold(
          extendBody: true,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  // Profile Card
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: _buildProfileCard(isDarkMode, Provider.of<UserProvider>(context).userProfile!),
                  ),

                  const SizedBox(height: 24),

                  // Menu Sections
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Account Section
                        _buildSectionTitle('Account', isDarkMode),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          isDarkMode: isDarkMode,
                          items: [
                            _MenuItem(
                              icon: Icons.person_outline,
                              title: 'Profile',
                              subtitle: 'Manage your profile information',
                              onTap: () {
                                // Navigate to profile edit
                              },
                            ),
                            _MenuItem(
                              icon: Icons.favorite_outline,
                              title: 'My Favorites',
                              subtitle: 'View your favorite teams & matches',
                              onTap: () {
                                // Navigate to favorites
                              },
                            ),
                            _MenuItem(
                              icon: Icons.bar_chart_rounded,
                              title: 'My Statistics',
                              subtitle: 'Track your engagement & activity',
                              onTap: () {
                                // Navigate to statistics
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // App Information Section
                        _buildSectionTitle('Information', isDarkMode),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          isDarkMode: isDarkMode,
                          items: [
                            _MenuItem(
                              icon: Icons.sports_handball_outlined,
                              title: 'How to Play WAO',
                              subtitle: 'Learn the rules and gameplay',
                              onTap: () {
                                _navigateToHowToPlay(context);
                              },
                            ),
                            _MenuItem(
                              icon: Icons.info_outline,
                              title: 'About Us',
                              subtitle: 'Learn more about WAO',
                              onTap: () {
                                _navigateToAboutUs(context);
                              },
                            ),
                            _MenuItem(
                              icon: Icons.privacy_tip_outlined,
                              title: 'Privacy Policy',
                              subtitle: 'Read our privacy policy',
                              onTap: () {
                                _navigateToPrivacyPolicy(context);
                              },
                            ),
                            _MenuItem(
                              icon: Icons.description_outlined,
                              title: 'Terms & Conditions',
                              subtitle: 'Read our terms of service',
                              onTap: () {
                                // Navigate to terms
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Preferences Section
                        _buildSectionTitle('Preferences', isDarkMode),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          isDarkMode: isDarkMode,
                          items: [
                            _MenuItem(
                              icon: Icons.notifications_outlined,
                              title: 'Push Notifications',
                              subtitle: 'Receive match updates',
                              trailing: Switch(
                                value: _notificationsEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    _notificationsEnabled = value;
                                  });
                                },
                                activeColor: AppColors.waoYellow,
                              ),
                            ),
                            _MenuItem(
                              icon: Icons.email_outlined,
                              title: 'Email Notifications',
                              subtitle: 'Receive updates via email',
                              trailing: Switch(
                                value: _emailNotifications,
                                onChanged: (value) {
                                  setState(() {
                                    _emailNotifications = value;
                                  });
                                },
                                activeColor: AppColors.waoYellow,
                              ),
                            ),
                            _MenuItem(
                              icon: isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              title: 'Theme',
                              subtitle: isDarkMode ? 'Dark mode' : 'Light mode',
                              onTap: () {
                                _showThemeDialog(context, isDarkMode);
                              },
                            ),
                            _MenuItem(
                              icon: Icons.language_outlined,
                              title: 'Language',
                              subtitle: 'English',
                              onTap: () {
                                // Navigate to language settings
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Support Section
                        _buildSectionTitle('Support', isDarkMode),
                        const SizedBox(height: 12),
                        _buildMenuCard(
                          isDarkMode: isDarkMode,
                          items: [
                            _MenuItem(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              subtitle: 'Get help with the app',
                              onTap: () {
                                // Navigate to support
                              },
                            ),
                            _MenuItem(
                              icon: Icons.feedback_outlined,
                              title: 'Send Feedback',
                              subtitle: 'Share your thoughts',
                              onTap: () {
                                // Navigate to feedback
                              },
                            ),
                            _MenuItem(
                              icon: Icons.star_outline,
                              title: 'Rate Us',
                              subtitle: 'Rate WAO on the app store',
                              onTap: () {
                                // Open app store
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Logout Button
                        _buildLogoutButton(isDarkMode, Provider.of<UserProvider>(context)),

                        const SizedBox(height: 16),

                        // App Version
                        Center(
                          child: Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.white38 : Colors.black38,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });

  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF011B3B),
            Color(0xFFD30336),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isDarkMode, UserProfile user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05),
            ]
                : [
              Colors.grey.withOpacity(0.1),
              Colors.grey.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar - with photo or initials
            user.photoUrl != null && user.photoUrl!.isNotEmpty
                ? Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.waoYellow,
                  width: 3,
                ),
                image: DecorationImage(
                  image: NetworkImage(user.photoUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            )
                : Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF011B3B),
                    Color(0xFFD30336),
                  ],
                ),
                border: Border.all(
                  color: AppColors.waoYellow,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  user.initials,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.displayName ?? user.username,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white60 : Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildStatChip('${user.totalTeams} Teams', Icons.groups, isDarkMode),
                      const SizedBox(width: 8),
                      _buildStatChip('${user.totalMatches} Matches', Icons.sports, isDarkMode),
                    ],
                  ),
                ],
              ),
            ),

            // Edit Icon
            IconButton(
              onPressed: () {

              },
              icon: Icon(
                Icons.edit_outlined,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildStatChip(String label, IconData icon, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.waoYellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.waoYellow.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.waoYellow,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white70 : Colors.black87,
      ),
    );
  }

  Widget _buildMenuCard({
    required bool isDarkMode,
    required List<_MenuItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildMenuItem(
            isDarkMode: isDarkMode,
            icon: item.icon,
            title: item.title,
            subtitle: item.subtitle,
            onTap: item.onTap,
            trailing: item.trailing,
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required bool isDarkMode,
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF011B3B).withOpacity(0.1),
                    const Color(0xFFD30336).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isDarkMode ? Colors.white70 : const Color(0xFF011B3B),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: isDarkMode ? Colors.white30 : Colors.black26,
                ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => Consumer2<ThemeProvider, UserProvider>(
        builder: (context, themeProvider, userProvider, child) {
          return AlertDialog(
            backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Choose Theme',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption(
                  context,
                  Icons.light_mode,
                  'Light Mode',
                  ThemePreference.light,
                  themeProvider,
                  userProvider,
                  isDarkMode,
                ),
                _buildThemeOption(
                  context,
                  Icons.dark_mode,
                  'Dark Mode',
                  ThemePreference.dark,
                  themeProvider,
                  userProvider,
                  isDarkMode,
                ),
                _buildThemeOption(
                  context,
                  Icons.phone_android,
                  'System Default',
                  ThemePreference.system,
                  themeProvider,
                  userProvider,
                  isDarkMode,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
      BuildContext context,
      IconData icon,
      String title,
      ThemePreference preference,
      ThemeProvider themeProvider,
      UserProvider userProvider,
      bool isDarkMode,
      ) {
    final isSelected = themeProvider.themePreference == preference;

    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? Colors.white70 : Colors.black87,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.waoYellow)
          : null,
      onTap: () async {
        await themeProvider.setThemePreference(preference);
        await userProvider.updateThemePreference(preference);
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildLogoutButton(bool isDarkMode, UserProvider userProvider) {
    return InkWell(
      onTap: () {
        _showLogoutDialog(context, userProvider);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Colors.red,
              size: 22,
            ),
            SizedBox(width: 12),
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Logout',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Show loading
                Navigator.pop(context); // Close dialog

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                // Perform logout
                await userProvider.logout();

                // Close loading
                if (context.mounted) {
                  Navigator.pop(context);

                  // Navigate to splash/login
                  // The AuthGate will automatically redirect
                }
              } catch (e) {
                Navigator.pop(context); // Close loading
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHowToPlay(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HowToPlayWAO(),
      ),
    );
  }

  void _navigateToAboutUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutPage(),
      ),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyPage(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });
}