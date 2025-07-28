class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
  });
}

// models/notification.dart
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String targetType;
  final String? teamName;
  final DateTime sentAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.targetType,
    this.teamName,
    required this.sentAt,
  });
}

