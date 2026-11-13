import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wao_mobile/core/services/notification_service.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _service = NotificationService.instance;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final top = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final inbox = _service.inbox;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Inline header ─────────────────────────────────────────────
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
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Notifications',
                        style: GoogleFonts.oswald(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.waoNavy,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (_service.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.waoRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_service.unreadCount}',
                            style: GoogleFonts.oswald(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (inbox.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _service.clearAll();
                      setState(() {});
                    },
                    child: Text(
                      'Clear all',
                      style: GoogleFonts.oswald(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.waoRed,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: inbox.isEmpty
                ? _EmptyState(isDark: isDark)
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 84),
                    itemCount: inbox.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _NotificationTile(
                      notification: inbox[i],
                      isDark: isDark,
                      onTap: () => _service.markRead(inbox[i].id),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Notification tile ─────────────────────────────────────────────────────────

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.isDark,
    required this.onTap,
  });
  final dynamic notification;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool unread = !notification.read;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: unread
              ? (isDark
                  ? AppColors.waoNavy.withOpacity(0.35)
                  : AppColors.waoNavy.withOpacity(0.04))
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: unread
                ? AppColors.waoRed.withOpacity(0.25)
                : (isDark
                    ? Colors.white.withOpacity(0.08)
                    : AppColors.waoNavy.withOpacity(0.08)),
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
            // Type icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconBg(notification.type, unread),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconFor(notification.type),
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: GoogleFonts.oswald(
                            fontSize: 14,
                            fontWeight: unread ? FontWeight.w600 : FontWeight.w500,
                            color: isDark ? Colors.white : AppColors.waoNavy,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      if (unread)
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: AppColors.waoRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTime(notification.receivedAt),
                    style: GoogleFonts.oswald(
                      fontSize: 11,
                      color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.35),
                      letterSpacing: 0.2,
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

  Color _iconBg(dynamic type, bool unread) {
    switch (type.toString()) {
      case '_NotificationType.live':     return AppColors.waoRed;
      case '_NotificationType.upcoming': return AppColors.waoNavy;
      case '_NotificationType.result':   return const Color(0xFF1A7A4A);
      default:                           return AppColors.waoNavy.withOpacity(0.7);
    }
  }

  IconData _iconFor(dynamic type) {
    switch (type.toString()) {
      case '_NotificationType.live':     return Icons.sensors_rounded;
      case '_NotificationType.upcoming': return Icons.event_rounded;
      case '_NotificationType.result':   return Icons.emoji_events_rounded;
      default:                           return Icons.notifications_rounded;
    }
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1)  return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.waoNavy.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 36,
              color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.25),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: GoogleFonts.oswald(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Live scores and match updates\nwill appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}
