// team_viewmodel.dart
import 'package:flutter/material.dart';
import '../../Model/teams_games/team_service.dart';
import '../../Model/teams_games/wao_team.dart';


class TeamViewModel extends ChangeNotifier {
  final TeamService _teamService = TeamService();

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