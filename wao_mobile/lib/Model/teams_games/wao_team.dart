import 'package:cloud_firestore/cloud_firestore.dart';

enum TeamCategory { senior, junior, youth }

class TeamRoster {
  final List<String> kingIds;
  final List<String> workerIds;
  final List<String> protagueIds;
  final List<String> antagueIds;
  final List<String> warriorIds;
  final List<String> sacrificerIds;
  final List<String> servitorIds;
  final List<String> substituteIds;

  TeamRoster({
    this.kingIds = const [],
    this.workerIds = const [],
    this.protagueIds = const [],
    this.antagueIds = const [],
    this.warriorIds = const [],
    this.sacrificerIds = const [],
    this.servitorIds = const [],
    this.substituteIds = const [],
  });

  int get totalPlayers =>
      kingIds.length +
          workerIds.length +
          protagueIds.length +
          antagueIds.length +
          warriorIds.length +
          sacrificerIds.length +
          servitorIds.length +
          substituteIds.length;

  factory TeamRoster.fromFirestore(Map<String, dynamic> data) {
    return TeamRoster(
      kingIds: List<String>.from(data['kingIds'] ?? []),
      workerIds: List<String>.from(data['workerIds'] ?? []),
      protagueIds: List<String>.from(data['protagueIds'] ?? []),
      antagueIds: List<String>.from(data['antagueIds'] ?? []),
      warriorIds: List<String>.from(data['warriorIds'] ?? []),
      sacrificerIds: List<String>.from(data['sacrificerIds'] ?? []),
      servitorIds: List<String>.from(data['servitorIds'] ?? []),
      substituteIds: List<String>.from(data['substituteIds'] ?? []),
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
      'servitorIds': servitorIds,
      'substituteIds': substituteIds,
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
      ...servitorIds,
      ...substituteIds,
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

  // Maximum 12 players per team (7 starters + 5 subs)
  static const int maxSquadSize = 12;

  // Check if team can add more players
  bool get canAddPlayers => roster.totalPlayers < maxSquadSize;
  int get availableSlots => maxSquadSize - roster.totalPlayers;

  factory WaoTeam.fromFirestore(Map<String, dynamic> data, String id) {
    return WaoTeam(
      id: id,
      name: data['name'] ?? '',
      // byName() throws for any value outside {senior, junior, youth} — a
      // legacy or malformed doc could still carry an old/typo'd category.
      // firstWhere+orElse matches the defensive pattern already used for
      // AccountRole/ThemePreference in user_model.dart — an unrecognized
      // category degrades to 'senior' instead of crashing the whole list.
      category: TeamCategory.values.firstWhere(
        (e) => e.name == data['category'],
        orElse: () => TeamCategory.senior,
      ),
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
      // `is Timestamp`, not just a null check — see the matching comment in
      // WaoPlayer.fromFirestore (MOBILE_ARCHITECTURE_REVIEW.md finding #9).
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] is Timestamp
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