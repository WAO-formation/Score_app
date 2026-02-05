import 'package:flutter/material.dart';
import 'package:wao_mobile/View/user/teams/models/teams_models.dart';
import '../../core/services/match_team_service/team_service.dart';
import '../../Model/teams_games/wao_team.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TeamViewModel extends ChangeNotifier {
  final TeamService _teamService = TeamService();
  final TeamService _followService = TeamService();

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

    _followService.getFollowedTeamIds(_currentUserId!).listen((teamIds) {
      _followedTeamIds = teamIds.toSet();
      notifyListeners();
    });
  }

  // Check if user is following a specific team
  bool isFollowingTeam(String teamId) {
    return _followedTeamIds.contains(teamId);
  }

  // Toggle follow status for a team
  Future<void> toggleFollowTeam(String teamId) async {
    if (_currentUserId == null) {
      print('Error: User ID not set');
      return;
    }

    try {
      final nowFollowing = await _followService.toggleFollowTeam(_currentUserId!, teamId);

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

  // Get follower count for a team
  Future<int> getTeamFollowerCount(String teamId) async {
    return await _followService.getTeamFollowerCount(teamId);
  }

  // Fetch all teams under a specific category (General or Campus)
  Stream<List<WaoTeam>> getTeamsByCategory(TeamCategory category) {
    return _teamService.getTeamsByCategory(category);
  }

  // Fetch teams belonging to a specific campus
  Stream<List<WaoTeam>> getTeamsByCampus(String campusId) {
    return _teamService.getTeamsByCampus(campusId);
  }

  // Fetch all teams
  Stream<List<WaoTeam>> getAllTeams() {
    return _teamService.getAllTeams();
  }

  // Get a single team
  Future<WaoTeam?> getTeamById(String teamId) async {
    return await _teamService.getTeamById(teamId);
  }

  // Create a new team
  Future<String> createTeam(WaoTeam team) async {
    final id = await _teamService.createTeam(team);
    notifyListeners();
    return id;
  }

  // Update a team
  Future<void> updateTeam(String teamId, Map<String, dynamic> updates) async {
    await _teamService.updateTeam(teamId, updates);
    notifyListeners();
  }

  // Delete a team
  Future<void> deleteTeam(String teamId) async {
    await _teamService.deleteTeam(teamId);
    notifyListeners();
  }

  Stream<List<WaoTeam>> getTopTeams({int limit = 5}) {
    return _teamService.getTopTeams(limit: limit);
  }

  // Seed teams
  Future<void> seedWaoTeams() async {
    await _teamService.seedWaoTeams();
    notifyListeners();
  }

  // Check if teams exist
  Future<bool> isTeamsEmpty() async {
    return await _teamService.isTeamsEmpty();
  }
}