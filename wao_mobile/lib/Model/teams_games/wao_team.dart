import 'package:cloud_firestore/cloud_firestore.dart';

enum TeamCategory { general, campus }

class TeamRoster {
  final List<String> kingIds;
  final List<String> workerIds;
  final List<String> protagueIds;
  final List<String> antagueIds;
  final List<String> warriorIds;
  final List<String> sacrificerIds;

  TeamRoster({
    this.kingIds = const [],
    this.workerIds = const [],
    this.protagueIds = const [],
    this.antagueIds = const [],
    this.warriorIds = const [],
    this.sacrificerIds = const [],
  });

  int get totalPlayers =>
      kingIds.length +
          workerIds.length +
          protagueIds.length +
          antagueIds.length +
          warriorIds.length +
          sacrificerIds.length;

  factory TeamRoster.fromFirestore(Map<String, dynamic> data) {
    return TeamRoster(
      kingIds: List<String>.from(data['kingIds'] ?? []),
      workerIds: List<String>.from(data['workerIds'] ?? []),
      protagueIds: List<String>.from(data['protagueIds'] ?? []),
      antagueIds: List<String>.from(data['antagueIds'] ?? []),
      warriorIds: List<String>.from(data['warriorIds'] ?? []),
      sacrificerIds: List<String>.from(data['sacrificerIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'kingIds': kingIds,
      'workerIds': workerIds,
      'protagueIds': protagueIds,
      'antagueIds': antagueIds,
      'warriorIds': warriorIds,
      'sacrificerIds': sacrificerIds,
    };
  }

  // Get all player IDs
  List<String> getAllPlayerIds() {
    return [
      ...kingIds,
      ...workerIds,
      ...protagueIds,
      ...antagueIds,
      ...warriorIds,
      ...sacrificerIds,
    ];
  }
}

class WaoTeam {
  final String id;
  final String name;
  final TeamCategory category;
  final String? campusId;
  final String coach;
  final String secretary;
  final String director;
  final String logoUrl;
  final bool isTopTeam;
  final int ranking;
  final TeamRoster roster;
  final DateTime createdAt;
  final DateTime? updatedAt;

  WaoTeam({
    required this.id,
    required this.name,
    required this.category,
    this.campusId,
    required this.coach,
    required this.secretary,
    required this.director,
    required this.logoUrl,
    this.isTopTeam = false,
    this.ranking = 0,
    TeamRoster? roster,
    required this.createdAt,
    this.updatedAt,
  }) : roster = roster ?? TeamRoster();

  // Maximum 15 players per team
  static const int maxSquadSize = 15;

  // Check if team can add more players
  bool get canAddPlayers => roster.totalPlayers < maxSquadSize;
  int get availableSlots => maxSquadSize - roster.totalPlayers;

  factory WaoTeam.fromFirestore(Map<String, dynamic> data, String id) {
    return WaoTeam(
      id: id,
      name: data['name'] ?? '',
      category: TeamCategory.values.byName(data['category'] ?? 'general'),
      campusId: data['campusId'],
      coach: data['coach'] ?? 'Unknown Coach',
      secretary: data['secretary'] ?? '',
      director: data['director'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      isTopTeam: data['isTopTeam'] ?? false,
      ranking: data['ranking'] ?? 0,
      roster: data['roster'] != null
          ? TeamRoster.fromFirestore(data['roster'] as Map<String, dynamic>)
          : TeamRoster(),
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
      'category': category.name,
      'campusId': campusId,
      'coach': coach,
      'secretary': secretary,
      'director': director,
      'logoUrl': logoUrl,
      'isTopTeam': isTopTeam,
      'ranking': ranking,
      'roster': roster.toFirestore(),
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  WaoTeam copyWith({
    String? id,
    String? name,
    TeamCategory? category,
    String? campusId,
    String? coach,
    String? secretary,
    String? director,
    String? logoUrl,
    bool? isTopTeam,
    int? ranking,
    TeamRoster? roster,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WaoTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      campusId: campusId ?? this.campusId,
      coach: coach ?? this.coach,
      secretary: secretary ?? this.secretary,
      director: director ?? this.director,
      logoUrl: logoUrl ?? this.logoUrl,
      isTopTeam: isTopTeam ?? this.isTopTeam,
      ranking: ranking ?? this.ranking,
      roster: roster ?? this.roster,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}