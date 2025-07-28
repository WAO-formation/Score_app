import 'package:flutter/material.dart';
import '../../provider/Models/coach.dart';
import '../../shared/theme_data.dart';
import '../../widgets/top_snackbar_styles.dart';



class CoachProfilePage extends StatefulWidget {
  const CoachProfilePage({super.key});

  @override
  State<CoachProfilePage> createState() => _CoachProfilePageState();
}

class _CoachProfilePageState extends State<CoachProfilePage> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  late CoachModel _coach;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    // Get current theme mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isDarkMode = Theme.of(context).brightness == Brightness.dark;
      });
    });
  }

  void _initializeMockData() {
    _coach = CoachModel(
      id: 'coach_001',
      name: 'Sarah Johnson',
      teamName: 'Thunder Warriors',
      role: 'Head Coach',
      email: 'sarah.johnson@wao.com',
      phoneNumber: '+1234567890',
      profileImageUrl: null,
      activePlayers: 7,
      substitutePlayers: 4,
      totalGamesCoached: 45,
      wins: 32,
      losses: 13,
      teamRank: 3,
      notificationsEnabled: true,
      isDarkTheme: false,
    );
    notificationsEnabled = _coach.notificationsEnabled;
  }

  void _showEditCoachDialog() {
    final TextEditingController nameController = TextEditingController(text: _coach.name);
    final TextEditingController emailController = TextEditingController(text: _coach.email);
    final TextEditingController phoneController = TextEditingController(text: _coach.phoneNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Edit Coach Profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Coach Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _coach.name = nameController.text.trim();
                _coach.email = emailController.text.trim();
                _coach.phoneNumber = phoneController.text.trim();
              });
              Navigator.pop(context);
              TopSnackBarStyles.success(
                context,
                title: 'Success',
                message: 'Coach profile updated successfully!',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: lightColorScheme.secondary,
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController currentController = TextEditingController();
    final TextEditingController newController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Change Password',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              TopSnackBarStyles.success(
                context,
                title: 'Success',
                message: 'Password changed successfully!',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: lightColorScheme.secondary,
            ),
            child: const Text(
              'Change',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              TopSnackBarStyles.warning(
                context,
                title: 'Logged Out',
                message: 'You have been logged out successfully',
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: lightColorScheme.error,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? lightColorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Coach Avatar
          GestureDetector(
            onTap: () {
              TopSnackBarStyles.warning(
                context,
                title: 'Photo Update',
                message: 'Profile photo change feature coming soon',
              );
            },
            child: CircleAvatar(
              radius: 40,
              backgroundColor: lightColorScheme.secondary.withOpacity(0.1),
              backgroundImage: _coach.profileImageUrl != null
                  ? NetworkImage(_coach.profileImageUrl!)
                  : null,
              child: _coach.profileImageUrl == null
                  ? Icon(
                Icons.person,
                size: 40,
                color: lightColorScheme.secondary,
              )
                  : null,
            ),
          ),
          const SizedBox(height: 15),

          // Coach Name
          Text(
            _coach.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 5),

          // Team Name & Role
          Text(
            '${_coach.teamName} • ${_coach.role}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 5),

          // Email
          Text(
            _coach.email,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 15),

          // Edit Profile Button
          OutlinedButton.icon(
            onPressed: _showEditCoachDialog,
            icon: const Icon(Icons.edit, size: 16),
            label: const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: lightColorScheme.secondary,
              side: BorderSide(color: lightColorScheme.secondary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachingStatsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? lightColorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.sports_soccer,
            title: 'Games Coached',
            subtitle: '${_coach.totalGamesCoached} total games coached',
            onTap: null,
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.emoji_events,
            title: 'Win Rate',
            subtitle: '${_coach.winPercentage.toStringAsFixed(1)}% success rate',
            onTap: null,
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.trending_up,
            title: 'Performance Record',
            subtitle: '${_coach.wins} wins, ${_coach.losses} losses',
            onTap: null,
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.leaderboard,
            title: 'League Position',
            subtitle: 'Currently ranked #${_coach.teamRank}',
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? lightColorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.lock,
            title: 'Change Password',
            subtitle: 'Update your password',
            onTap: _showChangePasswordDialog,
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notification Settings',
            subtitle: notificationsEnabled ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                  _coach.notificationsEnabled = value;
                });
                TopSnackBarStyles.success(
                  context,
                  title: 'Settings Updated',
                  message: 'Notifications ${value ? 'enabled' : 'disabled'}',
                );
              },
              activeColor: lightColorScheme.primary,
            ),
            onTap: null,
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: isDarkMode ? Icons.light_mode : Icons.dark_mode,
            title: 'Appearance',
            subtitle: isDarkMode ? 'Dark Mode' : 'Light Mode',
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                  _coach.isDarkTheme = value;
                });
                TopSnackBarStyles.success(
                  context,
                  title: 'Theme Changed',
                  message: '${value ? 'Dark' : 'Light'} mode activated',
                );
              },
              activeColor: lightColorScheme.primary,
            ),
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildOtherOptionsSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? lightColorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.support_agent,
            title: 'Contact Support',
            subtitle: 'Get help and support',
            onTap: () {
              TopSnackBarStyles.success(
                context,
                title: 'Support',
                message: 'Opening support channel...',
              );
            },
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.help,
            title: 'Help / FAQs',
            subtitle: 'Find answers to coaching questions',
            onTap: () {
              TopSnackBarStyles.success(
                context,
                title: 'Help',
                message: 'Opening coaching help center...',
              );
            },
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.share,
            title: 'Share Team Stats',
            subtitle: 'Share your team performance',
            onTap: () {
              TopSnackBarStyles.success(
                context,
                title: 'Share',
                message: 'Opening share options...',
              );
            },
          ),
          _buildDivider(),
          _buildSettingsTile(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            onTap: _showLogoutDialog,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Widget? trailing,
    bool isDestructive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDestructive ? lightColorScheme.error : lightColorScheme.secondary;
    final titleColor = isDestructive ? lightColorScheme.error : (isDark ? Colors.white : Colors.black87);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: Colors.grey[600],
        ),
      ),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: Colors.grey) : null),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 68,
      endIndent: 20,
      color: Colors.grey[300],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.secondary,
        elevation: 0,
        title: const Text(
          'Coach Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coach Header
            _buildCoachHeader(),
            const SizedBox(height: 25),

            // Coaching Performance Section
            Text(
              'Coaching Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildCoachingStatsSection(),
            const SizedBox(height: 25),

            // Settings Section
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsSection(),
            const SizedBox(height: 25),

            // Other Options Section
            Text(
              'Other Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildOtherOptionsSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}