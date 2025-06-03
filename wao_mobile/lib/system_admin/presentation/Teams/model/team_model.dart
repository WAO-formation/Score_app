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
        lastMatchDate: DateTime.now().subtract(Duration(days: 3)),
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
        lastMatchDate: DateTime.now().subtract(Duration(days: 5)),
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
        lastMatchDate: DateTime.now().subtract(Duration(days: 7)),
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
        lastMatchDate: DateTime.now().subtract(Duration(days: 14)),
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

  // Static method for creating sample match records
  static List<MatchRecord> getSampleMatches() {
    return [
      MatchRecord(
        matchId: 'match_001',
        opponent: 'Fire Eagles',
        date: DateTime.now().subtract(Duration(days: 3)),
        result: 'won',
        kingdom: 88.2,
        workout: 91.5,
        goalpost: 85.1,
        judges: 89.7,
      ),
      MatchRecord(
        matchId: 'match_002',
        opponent: 'Ice Wolves',
        date: DateTime.now().subtract(Duration(days: 10)),
        result: 'lost',
        kingdom: 82.4,
        workout: 87.9,
        goalpost: 79.3,
        judges: 85.2,
      ),
      MatchRecord(
        matchId: 'match_003',
        opponent: 'Storm Hawks',
        date: DateTime.now().subtract(Duration(days: 17)),
        result: 'draw',
        kingdom: 85.7,
        workout: 89.1,
        goalpost: 82.6,
        judges: 87.4,
      ),
      MatchRecord(
        matchId: 'match_004',
        opponent: 'Lightning Bolts',
        date: DateTime.now().subtract(Duration(days: 24)),
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

// Example usage and testing
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

  // Create a new match record
  MatchRecord newMatch = MatchRecord.create(
    matchId: 'match_new_001',
    opponent: 'Golden Dragons',
    date: DateTime.now(),
    result: 'pending',
  );

  // Update the match with scores
  MatchRecord completedMatch = newMatch.copyWith(
    result: 'won',
    kingdom: 87.5,
    workout: 90.2,
    goalpost: 84.8,
    judges: 89.1,
  );

  print('New Match Record:');
  print('Match ID: ${completedMatch.matchId}');
  print('Opponent: ${completedMatch.opponent}');
  print('Result: ${completedMatch.result}');
  print('Total Score: ${completedMatch.totalScore.toStringAsFixed(1)}');
  print('Date: ${completedMatch.date.toString().split(' ')[0]}');
}