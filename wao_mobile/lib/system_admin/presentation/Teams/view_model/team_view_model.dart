// teams_view_model.dart
import 'dart:async';

import '../../score_board/model/live_score.dart';
import '../model/team_model.dart';

enum TeamStatus { loading, loaded, error, empty }

class TeamsViewModel {
  // Private state
  List<Teams> _teams = [];
  Teams? _selectedTeam;
  TeamStatus _status = TeamStatus.empty;
  String _errorMessage = '';

  // Stream controllers for reactive updates
  final StreamController<List<Teams>> _teamsController = StreamController<
      List<Teams>>.broadcast();
  final StreamController<Teams?> _selectedTeamController = StreamController<
      Teams?>.broadcast();
  final StreamController<TeamStatus> _statusController = StreamController<
      TeamStatus>.broadcast();
  final StreamController<String> _errorController = StreamController<
      String>.broadcast();

  // Public getters
  List<Teams> get teams => List.unmodifiable(_teams);

  Teams? get selectedTeam => _selectedTeam;

  TeamStatus get status => _status;

  String get errorMessage => _errorMessage;

  // Streams for UI to listen to
  Stream<List<Teams>> get teamsStream => _teamsController.stream;

  Stream<Teams?> get selectedTeamStream => _selectedTeamController.stream;

  Stream<TeamStatus> get statusStream => _statusController.stream;

  Stream<String> get errorStream => _errorController.stream;

  // Team management methods
  void addTeam(Teams team) {
    if (!_teams.any((t) => t.id == team.id)) {
      _teams.add(team);
      _updateTeamsStream();
      _setStatus(TeamStatus.loaded);
    }
  }

  void removeTeam(String teamId) {
    _teams.removeWhere((team) => team.id == teamId);
    if (_selectedTeam?.id == teamId) {
      _selectedTeam = null;
      _selectedTeamController.add(null);
    }
    _updateTeamsStream();
    _setStatus(_teams.isEmpty ? TeamStatus.empty : TeamStatus.loaded);
  }

  void updateTeam(Teams updatedTeam) {
    final index = _teams.indexWhere((team) => team.id == updatedTeam.id);
    if (index != -1) {
      _teams[index] = updatedTeam;
      if (_selectedTeam?.id == updatedTeam.id) {
        _selectedTeam = updatedTeam;
        _selectedTeamController.add(_selectedTeam);
      }
      _updateTeamsStream();
    }
  }

  void selectTeam(String teamId) {
    _selectedTeam = _teams.firstWhere(
          (team) => team.id == teamId,
      orElse: () => throw Exception('Team not found'),
    );
    _selectedTeamController.add(_selectedTeam);
  }

  void clearSelection() {
    _selectedTeam = null;
    _selectedTeamController.add(null);
  }

  // Player management for selected team
  void addPlayerToSelectedTeam(Player player) {
    if (_selectedTeam == null) return;

    final updatedPlayers = List<Player>.from(_selectedTeam!.players);
    if (!updatedPlayers.any((p) => p.id == player.id)) {
      updatedPlayers.add(player);
      final updatedTeam = _selectedTeam!.copyWith(players: updatedPlayers);
      updateTeam(updatedTeam);
    }
  }

  void removePlayerFromSelectedTeam(String playerId) {
    if (_selectedTeam == null) return;

    final updatedPlayers = _selectedTeam!.players
        .where((player) => player.id != playerId)
        .toList();
    final updatedTeam = _selectedTeam!.copyWith(players: updatedPlayers);
    updateTeam(updatedTeam);
  }

  void updatePlayerInSelectedTeam(Player updatedPlayer) {
    if (_selectedTeam == null) return;

    final updatedPlayers = _selectedTeam!.players
        .map((player) => player.id == updatedPlayer.id ? updatedPlayer : player)
        .toList();
    final updatedTeam = _selectedTeam!.copyWith(players: updatedPlayers);
    updateTeam(updatedTeam);
  }

  // Match management for selected team
  void addMatchToSelectedTeam(MatchRecord match) {
    if (_selectedTeam == null) return;

    final updatedMatches = List<MatchRecord>.from(_selectedTeam!.matches);
    if (!updatedMatches.any((m) => m.matchId == match.matchId)) {
      updatedMatches.add(match);
      final updatedTeam = _selectedTeam!.copyWith(
        matches: updatedMatches,
        totalGames: updatedMatches.length,
        lastMatchDate: match.date,
      );
      updateTeam(updatedTeam);
    }
  }

  void removeMatchFromSelectedTeam(String matchId) {
    if (_selectedTeam == null) return;

    final updatedMatches = _selectedTeam!.matches
        .where((match) => match.matchId != matchId)
        .toList();

    final lastMatch = updatedMatches.isNotEmpty
        ? updatedMatches.reduce((a, b) => a.date.isAfter(b.date) ? a : b)
        : null;

    final updatedTeam = _selectedTeam!.copyWith(
      matches: updatedMatches,
      totalGames: updatedMatches.length,
      lastMatchDate: lastMatch?.date ?? DateTime.now(),
    );
    updateTeam(updatedTeam);
  }

  // Filtering and sorting
  List<Teams> getTeamsByRegion(String region) {
    return _teams.where((team) => team.region == region).toList();
  }

  List<Teams> getTeamsByStatus(String status) {
    return _teams.where((team) => team.status == status).toList();
  }

  List<Teams> getTeamsSortedByScore({bool ascending = false}) {
    final sortedTeams = List<Teams>.from(_teams);
    sortedTeams.sort((a, b) =>
    ascending
        ? a.totalScore.compareTo(b.totalScore)
        : b.totalScore.compareTo(a.totalScore));
    return sortedTeams;
  }

  List<Teams> getTeamsSortedByPosition({bool ascending = true}) {
    final sortedTeams = List<Teams>.from(_teams);
    sortedTeams.sort((a, b) =>
    ascending
        ? a.tablePosition.compareTo(b.tablePosition)
        : b.tablePosition.compareTo(a.tablePosition));
    return sortedTeams;
  }

  // Search functionality
  List<Teams> searchTeams(String query) {
    final lowerQuery = query.toLowerCase();
    return _teams.where((team) =>
    team.name.toLowerCase().contains(lowerQuery) ||
        team.region.toLowerCase().contains(lowerQuery) ||
        team.status.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Statistics
  Map<String, dynamic> getTeamStatistics() {
    if (_teams.isEmpty) return {};

    final totalTeams = _teams.length;
    final activeTeams = _teams
        .where((t) => t.status == 'active')
        .length;
    final averageScore = _teams.map((t) => t.totalScore).reduce((a, b) =>
    a + b) / totalTeams;
    final topTeam = _teams.reduce((a, b) =>
    a.totalScore > b.totalScore
        ? a
        : b);

    return {
      'totalTeams': totalTeams,
      'activeTeams': activeTeams,
      'inactiveTeams': totalTeams - activeTeams,
      'averageScore': averageScore,
      'topTeam': topTeam,
      'regions': _teams.map((t) => t.region).toSet().toList(),
    };
  }

  // Bulk operations
  void addMultipleTeams(List<Teams> teams) {
    _setStatus(TeamStatus.loading);
    for (final team in teams) {
      if (!_teams.any((t) => t.id == team.id)) {
        _teams.add(team);
      }
    }
    _updateTeamsStream();
    _setStatus(TeamStatus.loaded);
  }

  void clearAllTeams() {
    _teams.clear();
    _selectedTeam = null;
    _selectedTeamController.add(null);
    _updateTeamsStream();
    _setStatus(TeamStatus.empty);
  }

  // Sample data for testing
  void loadSampleData() {
    _setStatus(TeamStatus.loading);

    final sampleTeams = [
      Teams.basic(id: '1', name: 'Fire Dragons', region: 'North').copyWith(
        logoUrl: 'https://example.com/fire-dragon.png',
        tablePosition: 1,
        kingdom: 85.5,
        workout: 92.0,
        goalpost: 78.3,
        judges: 88.7,
        players: [
          Player.basic(id: 'p1', name: 'John Doe', role: 'Forward').copyWith(
            gamesPlayed: 12,
            fouls: 3,
            performanceScore: 87.5,
          ),
          Player.basic(id: 'p2', name: 'Jane Smith', role: 'Defender').copyWith(
            gamesPlayed: 11,
            fouls: 1,
            performanceScore: 92.0,
          ),
        ],
      ),
      Teams.basic(id: '2', name: 'Ice Wolves', region: 'South').copyWith(
        logoUrl: 'https://example.com/ice-wolf.png',
        tablePosition: 2,
        kingdom: 82.0,
        workout: 88.5,
        goalpost: 85.0,
        judges: 90.2,
        players: [
          Player.basic(id: 'p3', name: 'Mike Johnson', role: 'Midfielder')
              .copyWith(
            gamesPlayed: 13,
            fouls: 2,
            performanceScore: 89.3,
          ),
        ],
      ),
      Teams.basic(id: '3', name: 'Thunder Hawks', region: 'East').copyWith(
        logoUrl: 'https://example.com/thunder-hawk.png',
        tablePosition: 3,
        kingdom: 79.8,
        workout: 85.2,
        goalpost: 91.5,
        judges: 87.1,
      ),
    ];

    _teams.addAll(sampleTeams);
    _updateTeamsStream();
    _setStatus(TeamStatus.loaded);
  }

  // Private helper methods
  void _updateTeamsStream() {
    _teamsController.add(List.unmodifiable(_teams));
  }

  void _setStatus(TeamStatus newStatus) {
    _status = newStatus;
    _statusController.add(_status);
  }

  void _setError(String error) {
    _errorMessage = error;
    _errorController.add(_errorMessage);
    _setStatus(TeamStatus.error);
  }

  // Cleanup
  void dispose() {
    _teamsController.close();
    _selectedTeamController.close();
    _statusController.close();
    _errorController.close();
  }
}