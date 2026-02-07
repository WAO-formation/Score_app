import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String username;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String> favoriteTeamIds;
  final List<String> favoriteMatchIds;
  final int totalMatches;
  final int totalTeams;
  final ThemePreference themePreference;
  final bool notificationsEnabled;
  final bool emailNotifications;
  final String language;

  UserProfile({
    required this.uid,
    required this.username,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    this.updatedAt,
    this.favoriteTeamIds = const [],
    this.favoriteMatchIds = const [],
    this.totalMatches = 0,
    this.totalTeams = 0,
    this.themePreference = ThemePreference.system,
    this.notificationsEnabled = true,
    this.emailNotifications = false,
    this.language = 'English',
  });

  String get initials {
    final name = displayName ?? username;
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserProfile(
      uid: uid,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      favoriteTeamIds: List<String>.from(data['favoriteTeamIds'] ?? []),
      favoriteMatchIds: List<String>.from(data['favoriteMatchIds'] ?? []),
      totalMatches: data['totalMatches'] ?? 0,
      totalTeams: data['totalTeams'] ?? 0,
      themePreference: ThemePreference.values.firstWhere(
            (e) => e.name == data['themePreference'],
        orElse: () => ThemePreference.system,
      ),
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      emailNotifications: data['emailNotifications'] ?? false,
      language: data['language'] ?? 'English',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
      'favoriteTeamIds': favoriteTeamIds,
      'favoriteMatchIds': favoriteMatchIds,
      'totalMatches': totalMatches,
      'totalTeams': totalTeams,
      'themePreference': themePreference.name,
      'notificationsEnabled': notificationsEnabled,
      'emailNotifications': emailNotifications,
      'language': language,
    };
  }

  UserProfile copyWith({
    String? username,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? updatedAt,
    List<String>? favoriteTeamIds,
    List<String>? favoriteMatchIds,
    int? totalMatches,
    int? totalTeams,
    ThemePreference? themePreference,
    bool? notificationsEnabled,
    bool? emailNotifications,
    String? language,
  }) {
    return UserProfile(
      uid: uid,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      favoriteTeamIds: favoriteTeamIds ?? this.favoriteTeamIds,
      favoriteMatchIds: favoriteMatchIds ?? this.favoriteMatchIds,
      totalMatches: totalMatches ?? this.totalMatches,
      totalTeams: totalTeams ?? this.totalTeams,
      themePreference: themePreference ?? this.themePreference,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      language: language ?? this.language,
    );
  }
}

enum ThemePreference { light, dark, system }