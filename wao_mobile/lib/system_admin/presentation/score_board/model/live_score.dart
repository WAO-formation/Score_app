
import 'package:wao_mobile/system_admin/presentation/Teams/model/team_model.dart';

enum MatchStatus { upcoming, live, paused, ended, extraTime, finished, halftime, scheduled }
enum Quarter { first, second, third, fourth, extraTime }

class LiveMatch {
  final String id;
  final String title;
  final Teams teamA;
  final Teams teamB;
  final MatchStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final Quarter currentQuarter;
  final Duration currentTime;
  final Duration? extraTime;
  final LiveScore teamAScore;
  final LiveScore teamBScore;
  final List<MatchEvent> events;
  final List<PlayerFoul> fouls;

  LiveMatch({
    required this.id,
    required this.title,
    required this.teamA,
    required this.teamB,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.currentQuarter,
    required this.currentTime,
    this.extraTime,
    required this.teamAScore,
    required this.teamBScore,
    required this.events,
    required this.fouls,
  });

  String get displayTitle => '${teamA.name} vs ${teamB.name}';

  bool get isLive => status == MatchStatus.live;
  bool get isPaused => status == MatchStatus.paused;
  bool get isEnded => status == MatchStatus.ended;
  bool get isInExtraTime => status == MatchStatus.extraTime;

  Duration get quarterDuration {
    switch (currentQuarter) {
      case Quarter.first:
      case Quarter.second:
        return const Duration(minutes: 17);
      case Quarter.third:
      case Quarter.fourth:
        return const Duration(minutes: 13);
      case Quarter.extraTime:
        return const Duration(minutes: 10);
    }
  }

  String get timeDisplayString {
    int minutes = currentTime.inMinutes;
    int seconds = currentTime.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get quarterDisplayString {
    switch (currentQuarter) {
      case Quarter.first:
        return '1st Q';
      case Quarter.second:
        return '2nd Q';
      case Quarter.third:
        return '3rd Q';
      case Quarter.fourth:
        return '4th Q';
      case Quarter.extraTime:
        return 'ET';
    }
  }

  // Factory for creating a new match
  factory LiveMatch.create({
    required String id,
    required Teams teamA,
    required Teams teamB,
    DateTime? startTime,
  }) {
    return LiveMatch(
      id: id,
      title: '${teamA.name} vs ${teamB.name}',
      teamA: teamA,
      teamB: teamB,
      status: MatchStatus.upcoming,
      startTime: startTime ?? DateTime.now(),
      currentQuarter: Quarter.first,
      currentTime: Duration.zero,
      teamAScore: LiveScore.empty(teamA.id),
      teamBScore: LiveScore.empty(teamB.id),
      events: [],
      fouls: [],
    );
  }

  LiveMatch copyWith({
    String? id,
    String? title,
    Teams? teamA,
    Teams? teamB,
    MatchStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    Quarter? currentQuarter,
    Duration? currentTime,
    Duration? extraTime,
    LiveScore? teamAScore,
    LiveScore? teamBScore,
    List<MatchEvent>? events,
    List<PlayerFoul>? fouls,
  }) {
    return LiveMatch(
      id: id ?? this.id,
      title: title ?? this.title,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      currentQuarter: currentQuarter ?? this.currentQuarter,
      currentTime: currentTime ?? this.currentTime,
      extraTime: extraTime ?? this.extraTime,
      teamAScore: teamAScore ?? this.teamAScore,
      teamBScore: teamBScore ?? this.teamBScore,
      events: events ?? List.from(this.events),
      fouls: fouls ?? List.from(this.fouls),
    );
  }

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'teamA': teamA.toJson(),
      'teamB': teamB.toJson(),
      'status': status.name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'currentQuarter': currentQuarter.name,
      'currentTime': currentTime.inMilliseconds,
      'extraTime': extraTime?.inMilliseconds,
      'teamAScore': teamAScore.toJson(),
      'teamBScore': teamBScore.toJson(),
      'events': events.map((e) => e.toJson()).toList(),
      'fouls': fouls.map((f) => f.toJson()).toList(),
    };
  }

  factory LiveMatch.fromJson(Map<String, dynamic> json) {
    return LiveMatch(
      id: json['id'],
      title: json['title'],
      teamA: Teams.fromJson(json['teamA']),
      teamB: Teams.fromJson(json['teamB']),
      status: MatchStatus.values.firstWhere((e) => e.name == json['status']),
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      currentQuarter: Quarter.values.firstWhere((e) => e.name == json['currentQuarter']),
      currentTime: Duration(milliseconds: json['currentTime']),
      extraTime: json['extraTime'] != null ? Duration(milliseconds: json['extraTime']) : null,
      teamAScore: LiveScore.fromJson(json['teamAScore']),
      teamBScore: LiveScore.fromJson(json['teamBScore']),
      events: (json['events'] as List).map((e) => MatchEvent.fromJson(e)).toList(),
      fouls: (json['fouls'] as List).map((f) => PlayerFoul.fromJson(f)).toList(),
    );
  }

  // Static method for sample live matches
  static List<LiveMatch> getSampleLiveMatches() {
    List<Teams> teams = Teams.getSampleTeams();

    return [
      LiveMatch.create(
        id: 'live_001',
        teamA: teams[0], // Thunder Bolts
        teamB: teams[1], // Fire Eagles
        startTime: DateTime.now().subtract(const Duration(minutes: 1)),
      ).copyWith(
        status: MatchStatus.live,
        currentQuarter: Quarter.second,
        currentTime: const Duration(minutes: 1, seconds: 45),
        teamAScore: LiveScore(
          teamId: teams[0].id,
          kingdom: 0,
          workout: 0,
          goalpost: 0,
          judges: 0,
          bounces: 0,
          workoutSeconds: 0,
          goals: 0,
          sacrifices3pt: 0,
          sacrifices33pt: 0,
          goalSettings: 0,
        ),
        teamBScore: LiveScore(
          teamId: teams[1].id,
          kingdom: 0,
          workout: 0,
          goalpost: 0,
          judges: 0,
          bounces: 0,
          workoutSeconds: 0,
          goals: 0,
          sacrifices3pt: 0,
          sacrifices33pt: 0,
          goalSettings: 0,
        ),
      ),

      LiveMatch.create(
        id: 'live_002',
        teamA: teams[2], // Ice Wolves
        teamB: teams[3], // Storm Hawks
        startTime: DateTime.now().subtract(const Duration(minutes: 1)),
      ).copyWith(
        status: MatchStatus.paused,
        currentQuarter: Quarter.third,
        currentTime: const Duration(minutes: 1, seconds: 12),
        teamAScore: LiveScore(
          teamId: teams[2].id,
          kingdom: 0,
          workout: 0,
          goalpost: 0,
          judges: 0,
          bounces: 0,
          workoutSeconds: 0,
          goals: 0,
          sacrifices3pt: 0,
          sacrifices33pt: 0,
          goalSettings: 0,
        ),
        teamBScore: LiveScore(
          teamId: teams[3].id,
          kingdom: 0,
          workout: 0,
          goalpost: 0,
          judges: 0,
          bounces: 0,
          workoutSeconds: 0,
          goals: 0,
          sacrifices3pt: 0,
          sacrifices33pt: 0,
          goalSettings: 0,
        ),
      ),
    ];
  }
}

class LiveScore {
  final String teamId;
  final double kingdom;
  final double workout;
  final double goalpost;
  final double judges;

  // Raw data for calculations
  final int bounces;
  final int workoutSeconds;
  final int goals;
  final int sacrifices3pt;
  final int sacrifices33pt;
  final int goalSettings;

  LiveScore({
    required this.teamId,
    required this.kingdom,
    required this.workout,
    required this.goalpost,
    required this.judges,
    required this.bounces,
    required this.workoutSeconds,
    required this.goals,
    required this.sacrifices3pt,
    required this.sacrifices33pt,
    required this.goalSettings,
  });

  double get totalScore => kingdom + workout + goalpost + judges;

  // Factory for empty score
  factory LiveScore.empty(String teamId) {
    return LiveScore(
      teamId: teamId,
      kingdom: 0.0,
      workout: 0.0,
      goalpost: 0.0,
      judges: 0.0,
      bounces: 0,
      workoutSeconds: 0,
      goals: 0,
      sacrifices3pt: 0,
      sacrifices33pt: 0,
      goalSettings: 0,
    );
  }

  LiveScore copyWith({
    String? teamId,
    double? kingdom,
    double? workout,
    double? goalpost,
    double? judges,
    int? bounces,
    int? workoutSeconds,
    int? goals,
    int? sacrifices3pt,
    int? sacrifices33pt,
    int? goalSettings,
  }) {
    return LiveScore(
      teamId: teamId ?? this.teamId,
      kingdom: kingdom ?? this.kingdom,
      workout: workout ?? this.workout,
      goalpost: goalpost ?? this.goalpost,
      judges: judges ?? this.judges,
      bounces: bounces ?? this.bounces,
      workoutSeconds: workoutSeconds ?? this.workoutSeconds,
      goals: goals ?? this.goals,
      sacrifices3pt: sacrifices3pt ?? this.sacrifices3pt,
      sacrifices33pt: sacrifices33pt ?? this.sacrifices33pt,
      goalSettings: goalSettings ?? this.goalSettings,
    );
  }

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'teamId': teamId,
      'kingdom': kingdom,
      'workout': workout,
      'goalpost': goalpost,
      'judges': judges,
      'bounces': bounces,
      'workoutSeconds': workoutSeconds,
      'goals': goals,
      'sacrifices3pt': sacrifices3pt,
      'sacrifices33pt': sacrifices33pt,
      'goalSettings': goalSettings,
    };
  }

  factory LiveScore.fromJson(Map<String, dynamic> json) {
    return LiveScore(
      teamId: json['teamId'],
      kingdom: json['kingdom'].toDouble(),
      workout: json['workout'].toDouble(),
      goalpost: json['goalpost'].toDouble(),
      judges: json['judges'].toDouble(),
      bounces: json['bounces'],
      workoutSeconds: json['workoutSeconds'],
      goals: json['goals'],
      sacrifices3pt: json['sacrifices3pt'],
      sacrifices33pt: json['sacrifices33pt'],
      goalSettings: json['goalSettings'],
    );
  }
}

enum EventType { bounce, skillShow, goal, sacrifice, goalSetting, foul, timeout, substitution, injury }

class MatchEvent {
  final String id;
  final EventType type;
  final String teamId;
  final String? playerId;
  final DateTime timestamp;
  final Quarter quarter;
  final Duration matchTime;
  final String description;
  final Map<String, dynamic>? data;

  MatchEvent({
    required this.id,
    required this.type,
    required this.teamId,
    this.playerId,
    required this.timestamp,
    required this.quarter,
    required this.matchTime,
    required this.description,
    this.data,
  });

  MatchEvent copyWith({
    String? id,
    EventType? type,
    String? teamId,
    String? playerId,
    DateTime? timestamp,
    Quarter? quarter,
    Duration? matchTime,
    String? description,
    Map<String, dynamic>? data,
  }) {
    return MatchEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      teamId: teamId ?? this.teamId,
      playerId: playerId ?? this.playerId,
      timestamp: timestamp ?? this.timestamp,
      quarter: quarter ?? this.quarter,
      matchTime: matchTime ?? this.matchTime,
      description: description ?? this.description,
      data: data ?? this.data,
    );
  }

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'teamId': teamId,
      'playerId': playerId,
      'timestamp': timestamp.toIso8601String(),
      'quarter': quarter.name,
      'matchTime': matchTime.inMilliseconds,
      'description': description,
      'data': data,
    };
  }

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
      id: json['id'],
      type: EventType.values.firstWhere((e) => e.name == json['type']),
      teamId: json['teamId'],
      playerId: json['playerId'],
      timestamp: DateTime.parse(json['timestamp']),
      quarter: Quarter.values.firstWhere((e) => e.name == json['quarter']),
      matchTime: Duration(milliseconds: json['matchTime']),
      description: json['description'],
      data: json['data'],
    );
  }
}

class PlayerFoul {
  final String id;
  final String playerId;
  final String playerName;
  final String teamId;
  final String foulType;
  final DateTime timestamp;
  final Quarter quarter;
  final Duration matchTime;
  final String description;
  final bool isCardGiven;
  final String? cardType;

  PlayerFoul({
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.foulType,
    required this.timestamp,
    required this.quarter,
    required this.matchTime,
    required this.description,
    required this.isCardGiven,
    this.cardType,
  });

  PlayerFoul copyWith({
    String? id,
    String? playerId,
    String? playerName,
    String? teamId,
    String? foulType,
    DateTime? timestamp,
    Quarter? quarter,
    Duration? matchTime,
    String? description,
    bool? isCardGiven,
    String? cardType,
  }) {
    return PlayerFoul(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      teamId: teamId ?? this.teamId,
      foulType: foulType ?? this.foulType,
      timestamp: timestamp ?? this.timestamp,
      quarter: quarter ?? this.quarter,
      matchTime: matchTime ?? this.matchTime,
      description: description ?? this.description,
      isCardGiven: isCardGiven ?? this.isCardGiven,
      cardType: cardType ?? this.cardType,
    );
  }

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'playerName': playerName,
      'teamId': teamId,
      'foulType': foulType,
      'timestamp': timestamp.toIso8601String(),
      'quarter': quarter.name,
      'matchTime': matchTime.inMilliseconds,
      'description': description,
      'isCardGiven': isCardGiven,
      'cardType': cardType,
    };
  }

  factory PlayerFoul.fromJson(Map<String, dynamic> json) {
    return PlayerFoul(
      id: json['id'],
      playerId: json['playerId'],
      playerName: json['playerName'],
      teamId: json['teamId'],
      foulType: json['foulType'],
      timestamp: DateTime.parse(json['timestamp']),
      quarter: Quarter.values.firstWhere((e) => e.name == json['quarter']),
      matchTime: Duration(milliseconds: json['matchTime']),
      description: json['description'],
      isCardGiven: json['isCardGiven'],
      cardType: json['cardType'],
    );
  }
}

// Helper class for score calculations
class ScoreCalculator {
  // Calculate Kingdom percentage from bounces
  static double calculateKingdomScore(int bounces) {
    // Example calculation - adjust based on your WAO! rules
    return (bounces * 5.5).clamp(0.0, 100.0);
  }

  // Calculate Workout percentage from seconds
  static double calculateWorkoutScore(int seconds) {
    // Example calculation - adjust based on your WAO! rules
    double minutes = seconds / 60.0;
    return (minutes * 8.2).clamp(0.0, 100.0);
  }

  // Calculate Goalpost percentage from goals and special actions
  static double calculateGoalpostScore({
    required int goals,
    required int sacrifices3pt,
    required int sacrifices33pt,
    required int goalSettings,
  }) {
    double baseScore = goals * 10.0;
    double sacrificeScore = (sacrifices3pt * 3.0) + (sacrifices33pt * 33.0);
    double goalSettingScore = goalSettings * 2.0;

    return (baseScore + sacrificeScore + goalSettingScore).clamp(0.0, 100.0);
  }

  // Update live score with new data
  static LiveScore updateScore(LiveScore currentScore, {
    int? additionalBounces,
    int? additionalWorkoutSeconds,
    int? additionalGoals,
    int? additionalSacrifices3pt,
    int? additionalSacrifices33pt,
    int? additionalGoalSettings,
    double? judgesOverride,
  }) {
    int newBounces = currentScore.bounces + (additionalBounces ?? 0);
    int newWorkoutSeconds = currentScore.workoutSeconds + (additionalWorkoutSeconds ?? 0);
    int newGoals = currentScore.goals + (additionalGoals ?? 0);
    int newSacrifices3pt = currentScore.sacrifices3pt + (additionalSacrifices3pt ?? 0);
    int newSacrifices33pt = currentScore.sacrifices33pt + (additionalSacrifices33pt ?? 0);
    int newGoalSettings = currentScore.goalSettings + (additionalGoalSettings ?? 0);

    return currentScore.copyWith(
      bounces: newBounces,
      workoutSeconds: newWorkoutSeconds,
      goals: newGoals,
      sacrifices3pt: newSacrifices3pt,
      sacrifices33pt: newSacrifices33pt,
      goalSettings: newGoalSettings,
      kingdom: calculateKingdomScore(newBounces),
      workout: calculateWorkoutScore(newWorkoutSeconds),
      goalpost: calculateGoalpostScore(
        goals: newGoals,
        sacrifices3pt: newSacrifices3pt,
        sacrifices33pt: newSacrifices33pt,
        goalSettings: newGoalSettings,
      ),
      judges: judgesOverride ?? currentScore.judges,
    );
  }
}

// teams_model.dart
class Teams {
  final String id;
  final String name;
  final String logoUrl;
  final String region;
  final String status;
  final int tablePosition;
  final int totalGames;
  final DateTime lastMatchDate;
  final double kingdom;
  final double workout;
  final double goalpost;
  final double judges;
  final List<Player> players;
  final List<MatchRecord> matches;

  Teams({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.region,
    required this.status,
    required this.tablePosition,
    required this.totalGames,
    required this.lastMatchDate,
    required this.kingdom,
    required this.workout,
    required this.goalpost,
    required this.judges,
    required this.players,
    required this.matches,
  });

  double get totalScore => kingdom + workout + goalpost + judges;

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'region': region,
      'status': status,
      'tablePosition': tablePosition,
      'totalGames': totalGames,
      'lastMatchDate': lastMatchDate.toIso8601String(),
      'kingdom': kingdom,
      'workout': workout,
      'goalpost': goalpost,
      'judges': judges,
      'players': players.map((player) => player.toJson()).toList(),
      'matches': matches.map((match) => match.toJson()).toList(),
    };
  }

  factory Teams.fromJson(Map<String, dynamic> json) {
    return Teams(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      region: json['region'] ?? '',
      status: json['status'] ?? 'active',
      tablePosition: json['tablePosition'] ?? 0,
      totalGames: json['totalGames'] ?? 0,
      lastMatchDate: json['lastMatchDate'] != null
          ? DateTime.parse(json['lastMatchDate'])
          : DateTime.now(),
      kingdom: (json['kingdom'] ?? 0.0).toDouble(),
      workout: (json['workout'] ?? 0.0).toDouble(),
      goalpost: (json['goalpost'] ?? 0.0).toDouble(),
      judges: (json['judges'] ?? 0.0).toDouble(),
      players: json['players'] != null
          ? (json['players'] as List).map((playerJson) => Player.fromJson(playerJson)).toList()
          : [],
      matches: json['matches'] != null
          ? (json['matches'] as List).map((matchJson) => MatchRecord.fromJson(matchJson)).toList()
          : [],
    );
  }

  // Static method for creating sample teams
  static List<Teams> getSampleTeams() {
    return [
      Teams(
        id: 'team_001',
        name: 'Thunder Bolts',
        logoUrl: 'https://example.com/thunderbolts.png',
        region: 'North',
        status: 'active',
        tablePosition: 1,
        totalGames: 15,
        lastMatchDate: DateTime.now().subtract(const Duration(days: 3)),
        kingdom: 85.5,
        workout: 92.0,
        goalpost: 78.3,
        judges: 88.7,
        players: Player.getSamplePlayers(),
        matches: MatchRecord.getSampleMatches(),
      ),
      Teams(
        id: 'team_002',
        name: 'Fire Eagles',
        logoUrl: 'https://example.com/fireeagles.png',
        region: 'South',
        status: 'active',
        tablePosition: 2,
        totalGames: 14,
        lastMatchDate: DateTime.now().subtract(const Duration(days: 5)),
        kingdom: 82.1,
        workout: 89.4,
        goalpost: 85.9,
        judges: 91.2,
        players: Player.getSamplePlayers(),
        matches: MatchRecord.getSampleMatches(),
      ),
      Teams(
        id: 'team_003',
        name: 'Ice Wolves',
        logoUrl: 'https://example.com/icewolves.png',
        region: 'East',
        status: 'active',
        tablePosition: 3,
        totalGames: 13,
        lastMatchDate: DateTime.now().subtract(const Duration(days: 7)),
        kingdom: 79.8,
        workout: 86.2,
        goalpost: 88.1,
        judges: 83.5,
        players: Player.getSamplePlayers(),
        matches: MatchRecord.getSampleMatches(),
      ),
      Teams(
        id: 'team_004',
        name: 'Storm Hawks',
        logoUrl: 'https://example.com/stormhawks.png',
        region: 'West',
        status: 'inactive',
        tablePosition: 4,
        totalGames: 12,
        lastMatchDate: DateTime.now().subtract(const Duration(days: 14)),
        kingdom: 76.3,
        workout: 81.7,
        goalpost: 79.4,
        judges: 85.8,
        players: [],
        matches: [],
      ),
    ];
  }

  // Factory for creating team with basic info
  factory Teams.basic({
    required String id,
    required String name,
    required String region,
    String status = 'active',
  }) {
    return Teams(
      id: id,
      name: name,
      logoUrl: '',
      region: region,
      status: status,
      tablePosition: 0,
      totalGames: 0,
      lastMatchDate: DateTime.now(),
      kingdom: 0.0,
      workout: 0.0,
      goalpost: 0.0,
      judges: 0.0,
      players: [],
      matches: [],
    );
  }

  // Copy constructor
  Teams copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? region,
    String? status,
    int? tablePosition,
    int? totalGames,
    DateTime? lastMatchDate,
    double? kingdom,
    double? workout,
    double? goalpost,
    double? judges,
    List<Player>? players,
    List<MatchRecord>? matches,
  }) {
    return Teams(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      region: region ?? this.region,
      status: status ?? this.status,
      tablePosition: tablePosition ?? this.tablePosition,
      totalGames: totalGames ?? this.totalGames,
      lastMatchDate: lastMatchDate ?? this.lastMatchDate,
      kingdom: kingdom ?? this.kingdom,
      workout: workout ?? this.workout,
      goalpost: goalpost ?? this.goalpost,
      judges: judges ?? this.judges,
      players: players ?? List.from(this.players),
      matches: matches ?? List.from(this.matches),
    );
  }

  @override
  String toString() {
    return 'Teams(id: $id, name: $name, region: $region, totalScore: $totalScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Teams && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Player {
  final String id;
  final String name;
  final String role;
  final int gamesPlayed;
  final int fouls;
  final double performanceScore;
  final String status;

  Player({
    required this.id,
    required this.name,
    required this.role,
    required this.gamesPlayed,
    required this.fouls,
    required this.performanceScore,
    required this.status,
  });

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'gamesPlayed': gamesPlayed,
      'fouls': fouls,
      'performanceScore': performanceScore,
      'status': status,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      gamesPlayed: json['gamesPlayed'] ?? 0,
      fouls: json['fouls'] ?? 0,
      performanceScore: (json['performanceScore'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'active',
    );
  }

  // Static method for creating sample players
  static List<Player> getSamplePlayers() {
    return [
      Player(
        id: 'player_001',
        name: 'Alex Thunder',
        role: 'Captain',
        gamesPlayed: 12,
        fouls: 3,
        performanceScore: 89.5,
        status: 'active',
      ),
      Player(
        id: 'player_002',
        name: 'Jordan Swift',
        role: 'Striker',
        gamesPlayed: 11,
        fouls: 2,
        performanceScore: 92.1,
        status: 'active',
      ),
      Player(
        id: 'player_003',
        name: 'Casey Storm',
        role: 'Defender',
        gamesPlayed: 10,
        fouls: 5,
        performanceScore: 85.7,
        status: 'active',
      ),
      Player(
        id: 'player_004',
        name: 'Riley Frost',
        role: 'Goalkeeper',
        gamesPlayed: 13,
        fouls: 1,
        performanceScore: 91.3,
        status: 'active',
      ),
    ];
  }

  // Factory for creating basic player
  factory Player.basic({
    required String id,
    required String name,
    required String role,
    String status = 'active',
  }) {
    return Player(
      id: id,
      name: name,
      role: role,
      gamesPlayed: 0,
      fouls: 0,
      performanceScore: 0.0,
      status: status,
    );
  }

  Player copyWith({
    String? id,
    String? name,
    String? role,
    int? gamesPlayed,
    int? fouls,
    double? performanceScore,
    String? status,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      fouls: fouls ?? this.fouls,
      performanceScore: performanceScore ?? this.performanceScore,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Player(id: $id, name: $name, role: $role, score: $performanceScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Player && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class MatchRecord {
  final String matchId;
  final String opponent;
  final DateTime date;
  final String result;
  final double kingdom;
  final double workout;
  final double goalpost;
  final double judges;

  MatchRecord({
    required this.matchId,
    required this.opponent,
    required this.date,
    required this.result,
    required this.kingdom,
    required this.workout,
    required this.goalpost,
    required this.judges,
  });

  double get totalScore => kingdom + workout + goalpost + judges;

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'opponent': opponent,
      'date': date.toIso8601String(),
      'result': result,
      'kingdom': kingdom,
      'workout': workout,
      'goalpost': goalpost,
      'judges': judges,
    };
  }

  factory MatchRecord.fromJson(Map<String, dynamic> json) {
    return MatchRecord(
      matchId: json['matchId'] ?? '',
      opponent: json['opponent'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      result: json['result'] ?? 'pending',
      kingdom: (json['kingdom'] ?? 0.0).toDouble(),
      workout: (json['workout'] ?? 0.0).toDouble(),
      goalpost: (json['goalpost'] ?? 0.0).toDouble(),
      judges: (json['judges'] ?? 0.0).toDouble(),
    );
  }

  // Static method for creating sample match records
  static List<MatchRecord> getSampleMatches() {
    return [
      MatchRecord(
        matchId: 'match_001',
        opponent: 'Fire Eagles',
        date: DateTime.now().subtract(const Duration(days: 3)),
        result: 'won',
        kingdom: 88.2,
        workout: 91.5,
        goalpost: 85.1,
        judges: 89.7,
      ),
      MatchRecord(
        matchId: 'match_002',
        opponent: 'Ice Wolves',
        date: DateTime.now().subtract(const Duration(days: 10)),
        result: 'lost',
        kingdom: 82.4,
        workout: 87.9,
        goalpost: 79.3,
        judges: 85.2,
      ),
      MatchRecord(
        matchId: 'match_003',
        opponent: 'Storm Hawks',
        date: DateTime.now().subtract(const Duration(days: 17)),
        result: 'draw',
        kingdom: 85.7,
        workout: 89.1,
        goalpost: 82.6,
        judges: 87.4,
      ),
      MatchRecord(
        matchId: 'match_004',
        opponent: 'Lightning Bolts',
        date: DateTime.now().subtract(const Duration(days: 24)),
        result: 'won',
        kingdom: 90.1,
        workout: 94.3,
        goalpost: 88.7,
        judges: 92.5,
      ),
    ];
  }

  // Factory for creating basic match
  factory MatchRecord.create({
    required String matchId,
    required String opponent,
    DateTime? date,
    String result = 'pending',
  }) {
    return MatchRecord(
      matchId: matchId,
      opponent: opponent,
      date: date ?? DateTime.now(),
      result: result,
      kingdom: 0.0,
      workout: 0.0,
      goalpost: 0.0,
      judges: 0.0,
    );
  }

  MatchRecord copyWith({
    String? matchId,
    String? opponent,
    DateTime? date,
    String? result,
    double? kingdom,
    double? workout,
    double? goalpost,
    double? judges,
  }) {
    return MatchRecord(
      matchId: matchId ?? this.matchId,
      opponent: opponent ?? this.opponent,
      date: date ?? this.date,
      result: result ?? this.result,
      kingdom: kingdom ?? this.kingdom,
      workout: workout ?? this.workout,
      goalpost: goalpost ?? this.goalpost,
      judges: judges ?? this.judges,
    );
  }

  @override
  String toString() {
    return 'MatchRecord(id: $matchId, opponent: $opponent, result: $result, score: $totalScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MatchRecord && other.matchId == matchId;
  }

  @override
  int get hashCode => matchId.hashCode;
}

// Example usage and testing with JSON serialization
void main() {
  // Get sample teams
  List<Teams> sampleTeams = Teams.getSampleTeams();

  print('Sample Teams:');
  for (Teams team in sampleTeams) {
    print('${team.name} - Position: ${team.tablePosition}, Total Score: ${team.totalScore.toStringAsFixed(1)}');
    print('  Players: ${team.players.length}');
    print('  Matches: ${team.matches.length}');
    print('');
  }

  // Test JSON serialization
  Teams firstTeam = sampleTeams.first;

  // Convert to JSON
  Map<String, dynamic> teamJson = firstTeam.toJson();
  print('Team JSON:');
  print(teamJson);
  print('');

  // Convert back from JSON
  Teams reconstructedTeam = Teams.fromJson(teamJson);
  print('Reconstructed Team:');
  print('Name: ${reconstructedTeam.name}');
  print('Total Score: ${reconstructedTeam.totalScore}');
  print('Players Count: ${reconstructedTeam.players.length}');
  print('Matches Count: ${reconstructedTeam.matches.length}');
  print('');

  // Test individual player JSON
  Player samplePlayer = Player.getSamplePlayers().first;
  Map<String, dynamic> playerJson = samplePlayer.toJson();
  Player reconstructedPlayer = Player.fromJson(playerJson);
  print('Player JSON Test:');
  print('Original: ${samplePlayer.name} - ${samplePlayer.performanceScore}');
  print('Reconstructed: ${reconstructedPlayer.name} - ${reconstructedPlayer.performanceScore}');
  print('');

  // Test match record JSON
  MatchRecord sampleMatch = MatchRecord.getSampleMatches().first;
  Map<String, dynamic> matchJson = sampleMatch.toJson();
  MatchRecord reconstructedMatch = MatchRecord.fromJson(matchJson);
  print('Match JSON Test:');
  print('Original: ${sampleMatch.opponent} - ${sampleMatch.result} - ${sampleMatch.totalScore}');
  print('Reconstructed: ${reconstructedMatch.opponent} - ${reconstructedMatch.result} - ${reconstructedMatch.totalScore}');
}