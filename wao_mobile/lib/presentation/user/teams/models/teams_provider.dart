import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wao_mobile/presentation/user/teams/models/teams_models.dart';
import 'dart:convert';

class TeamProvider with ChangeNotifier {
  List<Team> _teams = [];
  List<String> _followedTeamIds = [];

  List<Team> get teams => _teams;
  List<Team> get followedTeams => _teams.where((team) => _followedTeamIds.contains(team.id)).toList();

  Team? get primaryTeam {
    if (_followedTeamIds.isEmpty) return null;
    final String primaryTeamId = _followedTeamIds.first;
    return _teams.firstWhere((team) => team.id == primaryTeamId, orElse: () => _teams.first);
  }

  bool isFollowingTeam(String teamId) {
    return _followedTeamIds.contains(teamId);
  }

  Future<void> fetchTeams() async {


    await Future.delayed(const Duration(seconds: 1));

    _teams = [
      Team(
        id: '1',
        name: 'Team A',
        logoUrl: 'assets/images/WAO_LOGO.jpg',
        description: 'Official WAO Team A with top players',
      ),
      Team(
        id: '2',
        name: 'Team B',
        logoUrl: 'assets/images/WAO_LOGO.jpg',
        description: 'Rising stars of WAO',
      ),
      Team(
        id: '3',
        name: 'Team C',
        logoUrl: 'assets/images/WAO_LOGO.jpg',
        description: 'Champions of the Eastern Division',
      ),
      Team(
        id: '4',
        name: 'Team D',
        logoUrl: 'assets/images/WAO_LOGO.jpg',
        description: 'The strongest defense in the league',
      ),
      Team(
        id: '5',
        name: 'Team E',
        logoUrl: 'assets/images/WAO_LOGO.jpg',
        description: 'Known for fast-paced gameplay',
      ),
    ];

    await _loadFollowedTeams();
    notifyListeners();
  }

  Future<void> followTeam(String teamId) async {
    if (!_followedTeamIds.contains(teamId)) {
      _followedTeamIds.add(teamId);
      await _saveFollowedTeams();
      notifyListeners();
    }
  }

  Future<void> unfollowTeam(String teamId) async {
    if (_followedTeamIds.contains(teamId)) {
      _followedTeamIds.remove(teamId);
      await _saveFollowedTeams();
      notifyListeners();
    }
  }

  Future<void> _loadFollowedTeams() async {
    final prefs = await SharedPreferences.getInstance();
    final followedTeamsJson = prefs.getString('followed_teams');

    if (followedTeamsJson != null) {
      _followedTeamIds = List<String>.from(json.decode(followedTeamsJson));
    }
  }

  Future<void> _saveFollowedTeams() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('followed_teams', json.encode(_followedTeamIds));
  }
}