import 'package:cloud_firestore/cloud_firestore.dart';

enum PlayerRole {
  king,
  worker,
  protague,
  antague,
  warrior,
  sacrificer,
}

enum PlayerStatus {
  active,
  inactive,
  suspended,
}

class WaoPlayer {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final PlayerRole role;
  final PlayerStatus status;
  final String? currentTeamId; // Only one team at a time
  final String? currentTeamName;
  final DateTime? joinedTeamAt;
  final int gamesPlayed;
  final int goalsScored;
  final int assists;
  final DateTime createdAt;
  final DateTime? updatedAt;

  WaoPlayer({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.role,
    this.status = PlayerStatus.active,
    this.currentTeamId,
    this.currentTeamName,
    this.joinedTeamAt,
    this.gamesPlayed = 0,
    this.goalsScored = 0,
    this.assists = 0,
    required this.createdAt,
    this.updatedAt,
  });

  factory WaoPlayer.fromFirestore(Map<String, dynamic> data, String id) {
    return WaoPlayer(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      role: PlayerRole.values.byName(data['role'] ?? 'worker'),
      status: PlayerStatus.values.byName(data['status'] ?? 'active'),
      currentTeamId: data['currentTeamId'],
      currentTeamName: data['currentTeamName'],
      joinedTeamAt: data['joinedTeamAt'] != null
          ? (data['joinedTeamAt'] as Timestamp).toDate()
          : null,
      gamesPlayed: data['gamesPlayed'] ?? 0,
      goalsScored: data['goalsScored'] ?? 0,
      assists: data['assists'] ?? 0,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'role': role.name,
      'status': status.name,
      'currentTeamId': currentTeamId,
      'currentTeamName': currentTeamName,
      'joinedTeamAt': joinedTeamAt,
      'gamesPlayed': gamesPlayed,
      'goalsScored': goalsScored,
      'assists': assists,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  WaoPlayer copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    PlayerRole? role,
    PlayerStatus? status,
    String? currentTeamId,
    String? currentTeamName,
    DateTime? joinedTeamAt,
    int? gamesPlayed,
    int? goalsScored,
    int? assists,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WaoPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      currentTeamId: currentTeamId ?? this.currentTeamId,
      currentTeamName: currentTeamName ?? this.currentTeamName,
      joinedTeamAt: joinedTeamAt ?? this.joinedTeamAt,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      goalsScored: goalsScored ?? this.goalsScored,
      assists: assists ?? this.assists,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Check if player is available to join a team
  bool get isAvailable => currentTeamId == null && status == PlayerStatus.active;
}