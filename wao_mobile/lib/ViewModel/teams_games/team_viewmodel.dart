import 'package:flutter/material.dart';

import '../../Model/teams_games/team/team_stat.dart';
import '../../Model/teams_games/team/wao_player.dart';
import '../../Model/teams_games/wao_team.dart';
import '../../core/services/match_team_service/player_service.dart';
import '../../core/services/match_team_service/team_service.dart';


class TeamViewModel extends ChangeNotifier {
  final TeamService _teamService = TeamService();
  final PlayerService _playerService = PlayerService();

  // Cache for followed team IDs
  Set<String> _followedTeamIds = {};
  String? _currentUserId;

  Set<String> get followedTeamIds => _followedTeamIds;

  // Initialize with user ID and load followed teams
  void initialize(String userId) {
    _currentUserId = userId;
    _loadFollowedTeams();
  }

  // Load followed teams for the current user
  void _loadFollowedTeams() {
    if (_currentUserId == null) return;

    _teamService.getFollowedTeamIds(_currentUserId!).listen((teamIds) {
      _followedTeamIds = teamIds.toSet();
      notifyListeners();
    });
  }

  // Check if user is following a specific team
  bool isFollowingTeam(String teamId) {
    return _followedTeamIds.contains(teamId);
  }

  // ==================== TEAM OPERATIONS ====================

  /// Fetch all teams under a specific category (General or Campus)
  Stream<List<WaoTeam>> getTeamsByCategory(TeamCategory category) {
    return _teamService.getTeamsByCategory(category);
  }

  /// Fetch teams belonging to a specific campus
  Stream<List<WaoTeam>> getTeamsByCampus(String campusId) {
    return _teamService.getTeamsByCampus(campusId);
  }

  /// Fetch all teams
  Stream<List<WaoTeam>> getAllTeams() {
    return _teamService.getAllTeams();
  }

  /// Get top teams
  Stream<List<WaoTeam>> getTopTeams({int limit = 5}) {
    return _teamService.getTopTeams(limit: limit);
  }

  /// Get a single team
  Future<WaoTeam?> getTeamById(String teamId) async {
    return await _teamService.getTeamById(teamId);
  }

  /// Create a new team with validation
  Future<String> createTeam(WaoTeam team) async {
    try {
      final id = await _teamService.createTeam(team);
      notifyListeners();
      return id;
    } catch (e) {
      print('Error in ViewModel creating team: $e');
      rethrow;
    }
  }

  /// Update a team
  Future<void> updateTeam(String teamId, Map<String, dynamic> updates) async {
    try {
      await _teamService.updateTeam(teamId, updates);
      notifyListeners();
    } catch (e) {
      print('Error in ViewModel updating team: $e');
      rethrow;
    }
  }

  /// Delete a team
  Future<void> deleteTeam(String teamId) async {
    try {
      await _teamService.deleteTeam(teamId);
      notifyListeners();
    } catch (e) {
      print('Error in ViewModel deleting team: $e');
      rethrow;
    }
  }

  /// Check if team name is available
  Future<bool> isTeamNameAvailable(String teamName, {String? excludeTeamId}) async {
    try {
      final isTaken = await _teamService.isTeamNameTaken(
        teamName,
        excludeTeamId: excludeTeamId,
      );
      return !isTaken;
    } catch (e) {
      print('Error checking team name: $e');
      return false;
    }
  }

  // ==================== PLAYER MANAGEMENT ====================

  /// Add player to team
  Future<void> addPlayerToTeam({
    required String teamId,
    required String playerId,
    required PlayerRole role,
  }) async {
    try {
      await _teamService.addPlayerToTeam(
        teamId: teamId,
        playerId: playerId,
        role: role,
      );
      notifyListeners();
    } catch (e) {
      print('Error adding player to team: $e');
      rethrow;
    }
  }

  /// Remove player from team
  Future<void> removePlayerFromTeam({
    required String teamId,
    required String playerId,
  }) async {
    try {
      await _teamService.removePlayerFromTeam(
        teamId: teamId,
        playerId: playerId,
      );
      notifyListeners();
    } catch (e) {
      print('Error removing player from team: $e');
      rethrow;
    }
  }

  /// Get players for a specific team
  Stream<List<WaoPlayer>> getTeamPlayers(String teamId) {
    return _playerService.getPlayersByTeam(teamId);
  }

  /// Get available players (not in any team)
  Stream<List<WaoPlayer>> getAvailablePlayers() {
    return _playerService.getAvailablePlayers();
  }

  /// Create a new player
  Future<String> createPlayer(WaoPlayer player) async {
    try {
      final id = await _playerService.createPlayer(player);
      notifyListeners();
      return id;
    } catch (e) {
      print('Error creating player: $e');
      rethrow;
    }
  }

  /// Update player status
  Future<void> updatePlayerStatus(String playerId, PlayerStatus status) async {
    try {
      await _playerService.updatePlayerStatus(playerId, status);
      notifyListeners();
    } catch (e) {
      print('Error updating player status: $e');
      rethrow;
    }
  }

  // ==================== TEAM STATISTICS ====================

  /// Get team statistics
  Stream<TeamStatistics?> getTeamStatistics(String teamId) {
    return _teamService.getTeamStatistics(teamId);
  }

  /// Update team statistics after a game
  Future<void> recordGameResult({
    required String teamId,
    required GameResult gameResult,
  }) async {
    try {
      await _teamService.updateTeamStatisticsAfterGame(
        teamId: teamId,
        gameResult: gameResult,
      );
      notifyListeners();
    } catch (e) {
      print('Error recording game result: $e');
      rethrow;
    }
  }

  /// Get follower count for a team
  Future<int> getTeamFollowerCount(String teamId) async {
    return await _teamService.getTeamFollowerCount(teamId);
  }

  // ==================== FOLLOW FUNCTIONALITY ====================

  /// Toggle follow status for a team
  Future<void> toggleFollowTeam(String teamId) async {
    if (_currentUserId == null) {
      print('Error: User ID not set');
      return;
    }

    try {
      final nowFollowing = await _teamService.toggleFollowTeam(_currentUserId!, teamId);

      // Update local cache immediately for better UX
      if (nowFollowing) {
        _followedTeamIds.add(teamId);
      } else {
        _followedTeamIds.remove(teamId);
      }

      notifyListeners();
    } catch (e) {
      print('Error toggling follow: $e');
      rethrow;
    }
  }



  // ==================== UTILITY FUNCTIONS ====================

  /// Check if teams exist
  Future<bool> isTeamsEmpty() async {
    return await _teamService.isTeamsEmpty();
  }

  /// Clear all teams (for testing/admin purposes)
  Future<void> clearAllTeams() async {
    try {
      await _teamService.clearAllTeams();
      notifyListeners();
    } catch (e) {
      print('Error clearing teams: $e');
      rethrow;
    }
  }
}