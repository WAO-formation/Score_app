import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wao_mobile/Model/teams_games/team/team_stat.dart';

void main() {
  group('GameResult', () {
    test('isWin/isDraw/isLoss classify correctly', () {
      final win = GameResult(gameId: 'g1', opponentTeamId: 'o', opponentTeamName: 'O', teamScore: 3, opponentScore: 1, playedAt: DateTime(2026, 1, 1));
      final draw = GameResult(gameId: 'g2', opponentTeamId: 'o', opponentTeamName: 'O', teamScore: 2, opponentScore: 2, playedAt: DateTime(2026, 1, 1));
      final loss = GameResult(gameId: 'g3', opponentTeamId: 'o', opponentTeamName: 'O', teamScore: 0, opponentScore: 1, playedAt: DateTime(2026, 1, 1));

      expect(win.isWin, isTrue);
      expect(win.isDraw, isFalse);
      expect(draw.isDraw, isTrue);
      expect(loss.isLoss, isTrue);
    });

    test('round-trips through Firestore', () {
      final result = GameResult(
        gameId: 'g4', opponentTeamId: 'opp', opponentTeamName: 'Opponent FC',
        teamScore: 4, opponentScore: 2, playedAt: DateTime(2026, 2, 2), isHomeGame: false,
      );
      final roundTripped = GameResult.fromFirestore(result.toFirestore());
      expect(roundTripped.opponentTeamName, 'Opponent FC');
      expect(roundTripped.teamScore, 4);
      expect(roundTripped.isHomeGame, isFalse);
    });
  });

  group('TeamStatistics calculated properties', () {
    test('goalDifference, winPercentage, and points (3/1/0) compute correctly', () {
      final stats = TeamStatistics(
        teamId: 't1',
        totalGamesPlayed: 10,
        wins: 6,
        draws: 2,
        losses: 2,
        goalsScored: 20,
        goalsConceded: 8,
        updatedAt: DateTime(2026, 1, 1),
      );

      expect(stats.goalDifference, 12);
      expect(stats.winPercentage, 60.0);
      expect(stats.points, 20); // 6*3 + 2*1
      expect(stats.totalPlayers, 0);
    });

    test('winPercentage is 0 (not NaN/divide-by-zero) for a team with no games played', () {
      final stats = TeamStatistics(teamId: 't2', updatedAt: DateTime(2026, 1, 1));
      expect(stats.winPercentage, 0.0);
      expect(stats.points, 0);
    });

    test('recentGames round-trips as a list of GameResult through Firestore', () {
      final stats = TeamStatistics(
        teamId: 't3',
        recentGames: [
          GameResult(gameId: 'g1', opponentTeamId: 'o1', opponentTeamName: 'O1', teamScore: 1, opponentScore: 0, playedAt: DateTime(2026, 1, 1)),
          GameResult(gameId: 'g2', opponentTeamId: 'o2', opponentTeamName: 'O2', teamScore: 2, opponentScore: 2, playedAt: DateTime(2026, 1, 2)),
        ],
        updatedAt: DateTime(2026, 1, 3),
      );

      final roundTripped = TeamStatistics.fromFirestore(stats.toFirestore(), stats.teamId);
      expect(roundTripped.recentGames.length, 2);
      expect(roundTripped.recentGames[0].opponentTeamName, 'O1');
      expect(roundTripped.recentGames[1].isDraw, isTrue);
    });

    test('a document with no recentGames field parses to an empty list, not a crash', () {
      final stats = TeamStatistics.fromFirestore({'updatedAt': Timestamp.fromDate(DateTime(2026, 1, 1))}, 't4');
      expect(stats.recentGames, isEmpty);
    });
  });
}
