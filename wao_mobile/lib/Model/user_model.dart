import 'package:cloud_firestore/cloud_firestore.dart';

// Permission role, distinct from WaoPlayer's PlayerRole (in-game position).
// Stored on the user doc as 'role' (matching the field SeedingService.
// seedAdminProfile already writes). Controls what a signed-in user is
// allowed to write in Firestore — see firestore.rules. Only an existing
// admin can grant/change this; a user can never elevate their own role
// (enforced server-side in the rules, not just here).
//
// 'official' runs live scoring from the mobile app; 'moderator' runs the
// wao-web back office (teams/players/games management). Both sit at the
// same Firestore write tier (see isOfficial below and isOfficial() in
// firestore.rules), but only 'admin'/'moderator' are let into wao-web at
// all — that gate lives in wao-web's AuthContext, since an 'official'
// having Firestore write access is not the same as being welcome in the
// back-office UI.
enum AccountRole { fan, player, coach, official, moderator, admin }

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
  final AccountRole accountRole;

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
    this.accountRole = AccountRole.fan,
  });

  bool get isOfficial =>
      accountRole == AccountRole.official ||
      accountRole == AccountRole.moderator ||
      accountRole == AccountRole.admin;
  bool get isAdmin => accountRole == AccountRole.admin;

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
      accountRole: AccountRole.values.firstWhere(
            (e) => e.name == data['role'],
        orElse: () => AccountRole.fan,
      ),
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
      'role': accountRole.name,
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
    AccountRole? accountRole,
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
      accountRole: accountRole ?? this.accountRole,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      language: language ?? this.language,
    );
  }
}

enum ThemePreference { light, dark, system }