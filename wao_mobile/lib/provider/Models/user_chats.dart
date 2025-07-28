// models/user.dart
import 'package:flutter/material.dart';

enum UserRole { coach, player, admin }

class User {
  final String id;
  final String name;
  final UserRole role;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.role,
    this.avatarUrl,
  });

  // Get role display name
  String get roleDisplayName {
    switch (role) {
      case UserRole.coach:
        return 'Coach';
      case UserRole.player:
        return 'Player';
      case UserRole.admin:
        return 'Admin';
    }
  }

  // Get role color for UI
  Color get roleColor {
    switch (role) {
      case UserRole.coach:
        return Colors.green;
      case UserRole.player:
        return Colors.blue;
      case UserRole.admin:
        return Colors.orange;
    }
  }
}

// models/message.dart
class Message {
  final String id;
  final String senderId;
  final String chatThreadId;
  final String text;
  final DateTime timestamp;
  final MessageType type;

  Message({
    required this.id,
    required this.senderId,
    required this.chatThreadId,
    required this.text,
    required this.timestamp,
    this.type = MessageType.text,
  });
}

enum MessageType { text, system }

// models/chat_thread.dart
enum ChatThreadType { oneOnOne, group }

class ChatThread {
  final String id;
  final String name;
  final ChatThreadType type;
  final List<String> participantIds;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final String? lastMessageText;
  final String? lastMessageSenderId;

  ChatThread({
    required this.id,
    required this.name,
    required this.type,
    required this.participantIds,
    required this.createdAt,
    required this.lastMessageAt,
    this.lastMessageText,
    this.lastMessageSenderId,
  });

  // Create a copy with updated fields
  ChatThread copyWith({
    String? name,
    List<String>? participantIds,
    DateTime? lastMessageAt,
    String? lastMessageText,
    String? lastMessageSenderId,
  }) {
    return ChatThread(
      id: id,
      name: name ?? this.name,
      type: type,
      participantIds: participantIds ?? this.participantIds,
      createdAt: createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
    );
  }
}