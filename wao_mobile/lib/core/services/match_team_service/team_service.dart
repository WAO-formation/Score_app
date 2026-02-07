import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Model/teams_games/team/team_stat.dart';
import '../../../Model/teams_games/team/wao_player.dart';
import '../../../Model/teams_games/wao_team.dart';
import '../../../ViewModel/teams_games/player_viewmodel.dart';


class TeamService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PlayerService _playerService = PlayerService();

  // ==================== DATA INTEGRITY CHECKS ====================

  /// Check if team name already exists (case-insensitive)
  Future<bool> isTeamNameTaken(String teamName, {String? excludeTeamId}) async {
    try {
      final query = await _firestore
          .collection('teams')
          .where('name', isEqualTo: teamName.trim())
          .get();

      if (excludeTeamId != null) {
        // When updating, exclude the current team
        return query.docs.any((doc) => doc.id != excludeTeamId);
      }

      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error checking team name: $e');
      return false;
    }
  }

  /// Validate team creation/update
  Future<void> validateTeam(WaoTeam team, {bool isUpdate = false}) async {
    // Check team name uniqueness
    final nameTaken = await isTeamNameTaken(
      team.name,
      excludeTeamId: isUpdate ? team.id : null,
    );

    if (nameTaken) {
      throw Exception('Team name "${team.name}" is already taken');
    }

    // Validate squad size
    if (team.roster.totalPlayers > WaoTeam.maxSquadSize) {
      throw Exception(
          'Team exceeds maximum squad size of ${WaoTeam.maxSquadSize} players');
    }

    // Validate that all players in roster exist and are available
    await _validateRosterPlayers(team.roster, team.id);
  }

  /// Validate all players in roster
  Future<void> _validateRosterPlayers(TeamRoster roster, String teamId) async {
    final allPlayerIds = roster.getAllPlayerIds();

    for (final playerId in allPlayerIds) {
      final player = await _playerService.getPlayerById(playerId);

      if (player == null) {
        throw Exception('Player with ID $playerId does not exist');
      }

      // Check if player is already in another team
      if (player.currentTeamId != null && player.currentTeamId != teamId) {
        throw Exception(
            'Player ${player.name} is already in team ${player.currentTeamName}');
      }
    }
  }

  // ==================== TEAM CRUD OPERATIONS ====================

  Stream<List<WaoTeam>> getTeamsByCategory(TeamCategory category) {
    return _firestore
        .collection('teams')
        .where('category', isEqualTo: category.name)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Stream<List<WaoTeam>> getTeamsByCampus(String campusId) {
    return _firestore
        .collection('teams')
        .where('campusId', isEqualTo: campusId)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Stream<List<WaoTeam>> getAllTeams() {
    return _firestore.collection('teams').snapshots().map((snap) =>
        snap.docs.map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id)).toList());
  }

  Stream<List<WaoTeam>> getTopTeams({int limit = 5}) {
    return _firestore
        .collection('teams')
        .where('ranking', isGreaterThan: 0)
        .orderBy('ranking', descending: false)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Future<WaoTeam?> getTeamById(String teamId) async {
    try {
      final doc = await _firestore.collection('teams').doc(teamId).get();
      if (doc.exists && doc.data() != null) {
        return WaoTeam.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching team: $e');
      rethrow;
    }
  }

  Future<String> createTeam(WaoTeam team) async {
    try {
      // Validate team data
      await validateTeam(team);

      final docRef = _firestore.collection('teams').doc();
      final teamId = docRef.id;

      final updatedTeam = team.copyWith(
        id: teamId,
        createdAt: DateTime.now(),
      );

      // Use batch to create team and initialize statistics
      final batch = _firestore.batch();

      batch.set(docRef, updatedTeam.toFirestore());

      // Initialize team statistics
      final statsDoc = _firestore.collection('teamStatistics').doc(teamId);
      final stats = TeamStatistics(
        teamId: teamId,
        updatedAt: DateTime.now(),
      );
      batch.set(statsDoc, stats.toFirestore());

      await batch.commit();

      // Update player assignments
      await _assignPlayersToTeam(teamId, team.name, team.roster);

      return teamId;
    } catch (e) {
      print('Error creating team: $e');
      rethrow;
    }
  }

  Future<void> updateTeam(String teamId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('teams').doc(teamId).update(updates);
    } catch (e) {
      print('Error updating team: $e');
      rethrow;
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      final batch = _firestore.batch();

      // Get all players in this team
      final playersSnapshot = await _firestore
          .collection('players')
          .where('currentTeamId', isEqualTo: teamId)
          .get();

      // Remove team assignment from all players
      for (final playerDoc in playersSnapshot.docs) {
        batch.update(playerDoc.reference, {
          'currentTeamId': null,
          'currentTeamName': null,
          'joinedTeamAt': null,
        });
      }

      // Delete team
      batch.delete(_firestore.collection('teams').doc(teamId));

      // Delete team statistics
      batch.delete(_firestore.collection('teamStatistics').doc(teamId));

      await batch.commit();
    } catch (e) {
      print('Error deleting team: $e');
      rethrow;
    }
  }

  // ==================== PLAYER MANAGEMENT ====================

  /// Add player to team roster
  Future<void> addPlayerToTeam({
    required String teamId,
    required String playerId,
    required PlayerRole role,
  }) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) throw Exception('Team not found');

      if (!team.canAddPlayers) {
        throw Exception('Team has reached maximum squad size of ${WaoTeam.maxSquadSize}');
      }

      // Check if player is available
      final player = await _playerService.getPlayerById(playerId);
      if (player == null) throw Exception('Player not found');
      if (!player.isAvailable) {
        throw Exception('Player is not available or already in a team');
      }

      // Add player to appropriate role list
      final newRoster = _addPlayerToRoster(team.roster, playerId, role);

      // Update team roster
      await _firestore.collection('teams').doc(teamId).update({
        'roster': newRoster.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Assign player to team
      await _playerService.assignPlayerToTeam(
        playerId: playerId,
        teamId: teamId,
        teamName: team.name,
      );

      // Update statistics
      await _updatePlayerCounts(teamId);
    } catch (e) {
      print('Error adding player to team: $e');
      rethrow;
    }
  }

  /// Remove player from team roster
  Future<void> removePlayerFromTeam({
    required String teamId,
    required String playerId,
  }) async {
    try {
      final team = await getTeamById(teamId);
      if (team == null) throw Exception('Team not found');

      // Remove player from roster
      final newRoster = _removePlayerFromRoster(team.roster, playerId);

      // Update team roster
      await _firestore.collection('teams').doc(teamId).update({
        'roster': newRoster.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Remove team assignment from player
      await _playerService.removePlayerFromTeam(playerId);

      // Update statistics
      await _updatePlayerCounts(teamId);
    } catch (e) {
      print('Error removing player from team: $e');
      rethrow;
    }
  }

  /// Helper: Add player to roster based on role
  TeamRoster _addPlayerToRoster(TeamRoster roster, String playerId, PlayerRole role) {
    switch (role) {
      case PlayerRole.king:
        return TeamRoster(
          kingIds: [...roster.kingIds, playerId],
          workerIds: roster.workerIds,
          protagueIds: roster.protagueIds,
          antagueIds: roster.antagueIds,
          warriorIds: roster.warriorIds,
          sacrificerIds: roster.sacrificerIds,
        );
      case PlayerRole.worker:
        return TeamRoster(
          kingIds: roster.kingIds,
          workerIds: [...roster.workerIds, playerId],
          protagueIds: roster.protagueIds,
          antagueIds: roster.antagueIds,
          warriorIds: roster.warriorIds,
          sacrificerIds: roster.sacrificerIds,
        );
      case PlayerRole.protague:
        return TeamRoster(
          kingIds: roster.kingIds,
          workerIds: roster.workerIds,
          protagueIds: [...roster.protagueIds, playerId],
          antagueIds: roster.antagueIds,
          warriorIds: roster.warriorIds,
          sacrificerIds: roster.sacrificerIds,
        );
      case PlayerRole.antague:
        return TeamRoster(
          kingIds: roster.kingIds,
          workerIds: roster.workerIds,
          protagueIds: roster.protagueIds,
          antagueIds: [...roster.antagueIds, playerId],
          warriorIds: roster.warriorIds,
          sacrificerIds: roster.sacrificerIds,
        );
      case PlayerRole.warrior:
        return TeamRoster(
          kingIds: roster.kingIds,
          workerIds: roster.workerIds,
          protagueIds: roster.protagueIds,
          antagueIds: roster.antagueIds,
          warriorIds: [...roster.warriorIds, playerId],
          sacrificerIds: roster.sacrificerIds,
        );
      case PlayerRole.sacrificer:
        return TeamRoster(
          kingIds: roster.kingIds,
          workerIds: roster.workerIds,
          protagueIds: roster.protagueIds,
          antagueIds: roster.antagueIds,
          warriorIds: roster.warriorIds,
          sacrificerIds: [...roster.sacrificerIds, playerId],
        );
    }
  }

  /// Helper: Remove player from roster
  TeamRoster _removePlayerFromRoster(TeamRoster roster, String playerId) {
    return TeamRoster(
      kingIds: roster.kingIds.where((id) => id != playerId).toList(),
      workerIds: roster.workerIds.where((id) => id != playerId).toList(),
      protagueIds: roster.protagueIds.where((id) => id != playerId).toList(),
      antagueIds: roster.antagueIds.where((id) => id != playerId).toList(),
      warriorIds: roster.warriorIds.where((id) => id != playerId).toList(),
      sacrificerIds: roster.sacrificerIds.where((id) => id != playerId).toList(),
    );
  }

  /// Helper: Assign all players in roster to team
  Future<void> _assignPlayersToTeam(
      String teamId,
      String teamName,
      TeamRoster roster,
      ) async {
    final allPlayerIds = roster.getAllPlayerIds();

    for (final playerId in allPlayerIds) {
      await _playerService.assignPlayerToTeam(
        playerId: playerId,
        teamId: teamId,
        teamName: teamName,
      );
    }
  }

  // ==================== TEAM STATISTICS ====================

  /// Get team statistics
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

      // Update game counts
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

      // Update recent games (keep last 10)
      List<GameResult> updatedRecentGames = [
        gameResult,
        ...currentStats.recentGames,
      ];
      if (updatedRecentGames.length > 10) {
        updatedRecentGames = updatedRecentGames.sublist(0, 10);
      }

      // Create updated statistics
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

  /// Update player counts (active/inactive)
  Future<void> _updatePlayerCounts(String teamId) async {
    try {
      final activeCount = await _playerService.getActivePlayersCount(teamId);
      final inactiveCount = await _playerService.getInactivePlayersCount(teamId);

      await _firestore.collection('teamStatistics').doc(teamId).update({
        'activePlayers': activeCount,
        'inactivePlayers': inactiveCount,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating player counts: $e');
    }
  }

  /// Update follower count
  Future<void> updateFollowerCount(String teamId) async {
    try {
      final count = await getTeamFollowerCount(teamId);

      await _firestore.collection('teamStatistics').doc(teamId).update({
        'totalFollowers': count,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating follower count: $e');
    }
  }

  // ==================== FOLLOW FUNCTIONALITY ====================

  Future<void> followTeam(String userId, String teamId) async {
    try {
      final followDoc = _firestore
          .collection('users')
          .doc(userId)
          .collection('followedTeams')
          .doc(teamId);

      await followDoc.set({
        'teamId': teamId,
        'followedAt': FieldValue.serverTimestamp(),
      });

      // Update follower count
      await updateFollowerCount(teamId);

      print('Successfully followed team: $teamId');
    } catch (e) {
      print('Error following team: $e');
      rethrow;
    }
  }

  Future<void> unfollowTeam(String userId, String teamId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('followedTeams')
          .doc(teamId)
          .delete();

      // Update follower count
      await updateFollowerCount(teamId);

      print('Successfully unfollowed team: $teamId');
    } catch (e) {
      print('Error unfollowing team: $e');
      rethrow;
    }
  }

  Future<bool> isFollowingTeam(String userId, String teamId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('followedTeams')
          .doc(teamId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error checking follow status: $e');
      return false;
    }
  }

  Stream<List<String>> getFollowedTeamIds(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('followedTeams')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<int> getTeamFollowerCount(String teamId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('followedTeams')
          .where('teamId', isEqualTo: teamId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting follower count: $e');
      return 0;
    }
  }

  Future<bool> toggleFollowTeam(String userId, String teamId) async {
    try {
      final isFollowing = await isFollowingTeam(userId, teamId);

      if (isFollowing) {
        await unfollowTeam(userId, teamId);
        return false;
      } else {
        await followTeam(userId, teamId);
        return true;
      }
    } catch (e) {
      print('Error toggling follow status: $e');
      rethrow;
    }
  }

  // ==================== UTILITY FUNCTIONS ====================

  Future<bool> isTeamsEmpty() async {
    try {
      final snapshot = await _firestore.collection('teams').limit(1).get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking teams: $e');
      return true;
    }
  }

  Future<void> clearAllTeams() async {
    try {
      final snapshot = await _firestore.collection('teams').get();
      final batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('All teams cleared successfully');
    } catch (e) {
      print('Error clearing teams: $e');
      rethrow;
    }
  }
}