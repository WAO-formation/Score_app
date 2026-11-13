import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Handles FCM token registration, permission requests, and foreground
/// message routing. Call [init] once from main() after Firebase.initializeApp.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // In-memory stream of foreground messages for the UI to listen to.
  static final List<_AppNotification> _inbox = [];
  static final List<VoidCallback> _listeners = [];

  List<_AppNotification> get inbox => List.unmodifiable(_inbox);

  void addListener(VoidCallback cb) => _listeners.add(cb);
  void removeListener(VoidCallback cb) => _listeners.remove(cb);
  void _notify() { for (final cb in _listeners) cb(); }

  Future<void> init() async {
    // Web doesn't support background handlers — skip silently.
    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    }

    // Request permission (iOS / web prompt; Android 13+ prompt).
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await _saveToken();
    }

    // Token refresh — re-save whenever FCM rotates the token.
    _fcm.onTokenRefresh.listen((_) => _saveToken());

    // Foreground messages — add to inbox and notify listeners.
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      final n = msg.notification;
      if (n == null) return;
      _inbox.insert(0, _AppNotification(
        id: msg.messageId ?? DateTime.now().toIso8601String(),
        title: n.title ?? 'WAO',
        body: n.body ?? '',
        receivedAt: DateTime.now(),
        type: _typeFromData(msg.data),
      ));
      _notify();
    });
  }

  Future<void> _saveToken() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final token = await _fcm.getToken();
      if (token == null) return;
      await _db.collection('users').doc(uid).update({
        'fcmToken': token,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  /// Unsubscribes the device from FCM (called when user disables push).
  Future<void> disablePush() async {
    try {
      await _fcm.deleteToken();
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await _db.collection('users').doc(uid).update({
          'fcmToken': FieldValue.delete(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {}
  }

  /// Re-registers after user re-enables push.
  Future<void> enablePush() async => _saveToken();

  void clearAll() {
    _inbox.clear();
    _notify();
  }

  void markRead(String id) {
    final idx = _inbox.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _inbox[idx] = _inbox[idx].copyWith(read: true);
      _notify();
    }
  }

  int get unreadCount => _inbox.where((n) => !n.read).length;

  static _NotificationType _typeFromData(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'live':     return _NotificationType.live;
      case 'upcoming': return _NotificationType.upcoming;
      case 'result':   return _NotificationType.result;
      default:         return _NotificationType.general;
    }
  }
}

// Top-level required by FCM for background handling.
@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {}

// ── Data models ───────────────────────────────────────────────────────────────

enum _NotificationType { live, upcoming, result, general }

class _AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool read;
  final _NotificationType type;

  const _AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.read = false,
    required this.type,
  });

  _AppNotification copyWith({bool? read}) => _AppNotification(
        id: id,
        title: title,
        body: body,
        receivedAt: receivedAt,
        read: read ?? this.read,
        type: type,
      );
}
