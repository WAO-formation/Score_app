import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../../Admin-chats/chats_list.dart';

// Updated AdminDrawer with additional menu items
class AdminDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback? onDashboardSelected;

  const AdminDrawer({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.onDashboardSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFC10230);

    return Drawer(
      child: Column(
        children: [
           DrawerHeader(
            decoration: BoxDecoration(
              color: lightColorScheme.secondary,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: 60,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  'WAO Admin Panel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Dashboard option
                _buildDrawerItem(
                  context,
                  Icons.dashboard,
                  'Dashboard',
                  -1,
                  onTap: () {
                    if (onDashboardSelected != null) {
                      onDashboardSelected!();
                    }
                    Navigator.pop(context);
                  },
                  primaryColor: primaryColor,
                ),
                const Divider(height: 1),

                // Main Admin Pages
                _buildDrawerItem(
                  context,
                  Icons.notifications,
                  'Notifications',
                  0,
                  primaryColor: primaryColor,
                ),
                _buildDrawerItem(
                  context,
                  Icons.people,
                  'Users Management',
                  1,
                  primaryColor: primaryColor,
                ),
                _buildDrawerItem(
                  context,
                  Icons.sports,
                  'Teams Management',
                  2,
                  primaryColor: primaryColor,
                ),

                ListTile(
                  leading: const Icon(Icons.chat_bubble),
                  title: const Text('Chats'),
                  onTap: () {
                    Navigator.pop(context);
                    MaterialPageRoute( builder: (context) => const AdminChatListScreen());
                  },
                ),

                const Divider(),

                // Settings Section
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Theme Toggle'),
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Theme toggle coming soon!'),
                        ),
                      );
                    },
                    activeColor: primaryColor,
                  ),
                ),


                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  onTap: () {
                    Navigator.pop(context);
                    _showChangePasswordDialog(context);
                  },
                ),
              ],
            ),
          ),
          const Divider(),

          // Logout button
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context,
      IconData icon,
      String title,
      int index, {
        VoidCallback? onTap,
        required Color primaryColor,
      }) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? primaryColor : null,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: onTap ?? () => onItemSelected(index),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Change Password Dialog (Popup)
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({Key? key}) : super(key: key);

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildCurrentPasswordField(),
              const SizedBox(height: 16),
              _buildNewPasswordField(),
              const SizedBox(height: 16),
              _buildConfirmPasswordField(),
              const SizedBox(height: 16),
              _buildPasswordRequirements(),
              const SizedBox(height: 24),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.lock_outline,
          size: 28,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Change Password',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildCurrentPasswordField() {
    return TextFormField(
      controller: _currentPasswordController,
      obscureText: !_isCurrentPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Current Password',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _isCurrentPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
            });
          },
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your current password';
        }
        return null;
      },
    );
  }

  Widget _buildNewPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: !_isNewPasswordVisible,
      decoration: InputDecoration(
        labelText: 'New Password',
        prefixIcon: const Icon(Icons.lock_open),
        suffixIcon: IconButton(
          icon: Icon(
            _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isNewPasswordVisible = !_isNewPasswordVisible;
            });
          },
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a new password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
          return 'Password must contain uppercase, lowercase, and numbers';
        }
        return null;
      },
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Confirm New Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your new password';
        }
        if (value != _newPasswordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _newPasswordController.text;
    final hasMinLength = password.length >= 8;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumbers = RegExp(r'\d').hasMatch(password);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password Requirements:',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          ),
          const SizedBox(height: 8),
          _buildRequirementItem('At least 8 characters', hasMinLength),
          _buildRequirementItem('Contains uppercase letter', hasUppercase),
          _buildRequirementItem('Contains lowercase letter', hasLowercase),
          _buildRequirementItem('Contains numbers', hasNumbers),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isMet) {
    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: isMet ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isMet ? Colors.green : Colors.grey[600],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleChangePassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: _isLoading
              ? const SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            'Change Password',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to change password. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

// Placeholder pages for the new menu items
class TeamsManagementPage extends StatelessWidget {
  const TeamsManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Teams Management',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.sports, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Teams Management Page',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This page will allow you to manage teams, add new teams, edit team details, and assign players to teams.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
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


// Updated AdminConstants to include new page indices
class AdminConstants {
  static const List<String> targets = [
    'All Users',
    'Coaches Only',
    'Players Only',
    'Specific Team'
  ];

  static const List<String> teams = [
    'Thunder Warriors',
    'Lightning Bolts',
    'Storm Eagles',
    'Fire Dragons'
  ];

  static const List<String> userRoles = ['All', 'Coach', 'Player'];

  // Page indices for navigation
  static const int notificationsIndex = 0;
  static const int usersIndex = 1;
  static const int teamsIndex = 2;
  static const int eventsIndex = 3;
  static const int analyticsIndex = 4;
  static const int systemSettingsIndex = 5;
  static const int feedbackIndex = 6;
}