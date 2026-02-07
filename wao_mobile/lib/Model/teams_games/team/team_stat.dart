import 'package:cloud_firestore/cloud_firestore.dart';

class GameResult {
  final String gameId;
  final String opponentTeamId;
  final String opponentTeamName;
  final int teamScore;
  final int opponentScore;
  final DateTime playedAt;
  final bool isHomeGame;

  GameResult({
    required this.gameId,
    required this.opponentTeamId,
    required this.opponentTeamName,
    required this.teamScore,
    required this.opponentScore,
    required this.playedAt,
    this.isHomeGame = true,
  });

  bool get isWin => teamScore > opponentScore;
  bool get isDraw => teamScore == opponentScore;
  bool get isLoss => teamScore < opponentScore;

  factory GameResult.fromFirestore(Map<String, dynamic> data) {
    return GameResult(
      gameId: data['gameId'] ?? '',
      opponentTeamId: data['opponentTeamId'] ?? '',
      opponentTeamName: data['opponentTeamName'] ?? '',
      teamScore: data['teamScore'] ?? 0,
      opponentScore: data['opponentScore'] ?? 0,
      playedAt: data['playedAt'] != null
          ? (data['playedAt'] as Timestamp).toDate()
          : DateTime.now(),
      isHomeGame: data['isHomeGame'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'gameId': gameId,
      'opponentTeamId': opponentTeamId,
      'opponentTeamName': opponentTeamName,
      'teamScore': teamScore,
      'opponentScore': opponentScore,
      'playedAt': playedAt,
      'isHomeGame': isHomeGame,
    };
  }
}

class TeamStatistics {
  final String teamId;
  final int totalGamesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final int goalsScored;
  final int goalsConceded;
  final int activePlayers;
  final int inactivePlayers;
  final int totalFollowers;
  final List<GameResult> recentGames; // Last 10 games
  final DateTime? lastGameDate;
  final DateTime updatedAt;

  TeamStatistics({
    required this.teamId,
    this.totalGamesPlayed = 0,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.goalsScored = 0,
    this.goalsConceded = 0,
    this.activePlayers = 0,
    this.inactivePlayers = 0,
    this.totalFollowers = 0,
    this.recentGames = const [],
    this.lastGameDate,
    required this.updatedAt,
  });

  // Calculated properties
  int get totalPlayers => activePlayers + inactivePlayers;
  int get goalDifference => goalsScored - goalsConceded;
  double get winPercentage =>
      totalGamesPlayed > 0 ? (wins / totalGamesPlayed) * 100 : 0.0;
  int get points => (wins * 3) + draws; // Standard football points system

  factory TeamStatistics.fromFirestore(Map<String, dynamic> data, String teamId) {
    List<GameResult> games = [];
    if (data['recentGames'] != null) {
      games = (data['recentGames'] as List)
          .map((g) => GameResult.fromFirestore(g as Map<String, dynamic>))
          .toList();
    }

    return TeamStatistics(
      teamId: teamId,
      totalGamesPlayed: data['totalGamesPlayed'] ?? 0,
      wins: data['wins'] ?? 0,
      draws: data['draws'] ?? 0,
      losses: data['losses'] ?? 0,
      goalsScored: data['goalsScored'] ?? 0,
      goalsConceded: data['goalsConceded'] ?? 0,
      activePlayers: data['activePlayers'] ?? 0,
      inactivePlayers: data['inactivePlayers'] ?? 0,
      totalFollowers: data['totalFollowers'] ?? 0,
      recentGames: games,
      lastGameDate: data['lastGameDate'] != null
          ? (data['lastGameDate'] as Timestamp).toDate()
          : null,
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teamId': teamId,
      'totalGamesPlayed': totalGamesPlayed,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'goalsScored': goalsScored,
      'goalsConceded': goalsConceded,
      'activePlayers': activePlayers,
      'inactivePlayers': inactivePlayers,
      'totalFollowers': totalFollowers,
      'recentGames': recentGames.map((g) => g.toFirestore()).toList(),
      'lastGameDate': lastGameDate,
      'updatedAt': updatedAt,
    };
  }

  TeamStatistics copyWith({
    String? teamId,
    int? totalGamesPlayed,
    int? wins,
    int? draws,
    int? losses,
    int? goalsScored,
    int? goalsConceded,
    int? activePlayers,
    int? inactivePlayers,
    int? totalFollowers,
    List<GameResult>? recentGames,
    DateTime? lastGameDate,
    DateTime? updatedAt,
  }) {
    return TeamStatistics(
      teamId: teamId ?? this.teamId,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      wins: wins ?? this.wins,
      draws: draws ?? this.draws,
      losses: losses ?? this.losses,
      goalsScored: goalsScored ?? this.goalsScored,
      goalsConceded: goalsConceded ?? this.goalsConceded,
      activePlayers: activePlayers ?? this.activePlayers,
      inactivePlayers: inactivePlayers ?? this.inactivePlayers,
      totalFollowers: totalFollowers ?? this.totalFollowers,
      recentGames: recentGames ?? this.recentGames,
      lastGameDate: lastGameDate ?? this.lastGameDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}