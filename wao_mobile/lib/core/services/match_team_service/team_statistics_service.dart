import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Model/teams_games/team/team_stat.dart';

/// Team season-stats concerns, split out of the former do-everything
/// TeamService (see MOBILE_ARCHITECTURE_REVIEW.md finding #6) — win/loss
/// records, goals, and the active/inactive player counts shown on a team's
/// stats card. Following a team is a separate concern; see TeamFollowService.
class TeamStatisticsService {
  TeamStatisticsService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<TeamStatistics?> getTeamStatistics(String teamId) {
    return _firestore
        .collection('teamStatistics')
        .doc(teamId)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return TeamStatistics.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    });
  }

  /// Update team statistics after a game
  Future<void> updateTeamStatisticsAfterGame({
    required String teamId,
    required GameResult gameResult,
  }) async {
    try {
      final statsDoc = _firestore.collection('teamStatistics').doc(teamId);
      final statsSnapshot = await statsDoc.get();

      TeamStatistics currentStats;
      if (statsSnapshot.exists && statsSnapshot.data() != null) {
        currentStats = TeamStatistics.fromFirestore(statsSnapshot.data()!, teamId);
      } else {
        currentStats = TeamStatistics(teamId: teamId, updatedAt: DateTime.now());
      }

      int newWins = currentStats.wins;
      int newDraws = currentStats.draws;
      int newLosses = currentStats.losses;

      if (gameResult.isWin) {
        newWins++;
      } else if (gameResult.isDraw) {
        newDraws++;
      } else {
        newLosses++;
      }

      List<GameResult> updatedRecentGames = [
        gameResult,
        ...currentStats.recentGames,
      ];
      if (updatedRecentGames.length > 10) {
        updatedRecentGames = updatedRecentGames.sublist(0, 10);
      }

      final updatedStats = currentStats.copyWith(
        totalGamesPlayed: currentStats.totalGamesPlayed + 1,
        wins: newWins,
        draws: newDraws,
        losses: newLosses,
        goalsScored: currentStats.goalsScored + gameResult.teamScore,
        goalsConceded: currentStats.goalsConceded + gameResult.opponentScore,
        recentGames: updatedRecentGames,
        lastGameDate: gameResult.playedAt,
        updatedAt: DateTime.now(),
      );

      await statsDoc.set(updatedStats.toFirestore());
    } catch (e) {
      print('Error updating team statistics: $e');
      rethrow;
    }
  }

  /// Update active/inactive player counts. Takes the two counts rather than
  /// a PlayerService so this stays a pure "write these stats" method — the
  /// caller (TeamService) already knows how to compute them.
  Future<void> updatePlayerCounts(String teamId, {required int activeCount, required int inactiveCount}) async {
    try {
      await _firestore.collection('teamStatistics').doc(teamId).update({
        'activePlayers': activeCount,
        'inactivePlayers': inactiveCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating player counts: $e');
    }
  }
}
