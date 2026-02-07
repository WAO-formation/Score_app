import 'package:flutter/material.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final bool showNotification;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationPressed;
  final bool hasNotificationDot;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showNotification = true,
    this.onBackPressed,
    this.onNotificationPressed,
    this.hasNotificationDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor: AppColors.waoNavy,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 18,
          ),
        ),
      )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        if (showNotification)
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: onNotificationPressed ?? () {
                // Default notification action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notifications')),
                );
              },
              icon: _buildNotificationBell(isDarkMode),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationBell(bool isDarkMode) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 22,
          ),
        ),
        if (hasNotificationDot)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              height: 8,
              width: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFFE0000),
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}