// match_viewmodel.dart
import 'package:flutter/material.dart';
import '../../core/services/match_team_service/match_service.dart';
import '../../Model/teams_games/wao_match.dart';

class MatchViewModel extends ChangeNotifier {
  final MatchService _matchService = MatchService();

  // Initialize method for consistency with other ViewModels
  void initialize() {
    // Any initialization logic can go here
  }

  Stream<List<WaoMatch>> getAllMatches() {
    return _matchService.getAllMatches();
  }

  Stream<List<WaoMatch>> getMatchesByStatus(MatchStatus status) {
    return _matchService.getMatchesByStatus(status);
  }

  Stream<List<WaoMatch>> getLiveMatches() {
    return _matchService.getLiveMatches();
  }

  Stream<List<WaoMatch>> getUpcomingMatches() {
    return _matchService.getUpcomingMatches();
  }

  Stream<List<WaoMatch>> getFinishedMatches() {
    return _matchService.getFinishedMatches();
  }

  Stream<List<WaoMatch>> getMatchesByType(MatchType type) {
    return _matchService.getMatchesByType(type);
  }

  Stream<List<WaoMatch>> getTeamMatches(String teamId) {
    return _matchService.getTeamMatches(teamId);
  }

  Stream<List<WaoMatch>> getChampionshipMatches(String championshipId) {
    return _matchService.getChampionshipMatches(championshipId);
  }

  // NEW: Get matches for a specific date
  Stream<List<WaoMatch>> getMatchesByDate(DateTime date) {
    return _matchService.getMatchesByDate(date);
  }

  // NEW: Get matches in a date range
  Stream<List<WaoMatch>> getMatchesInDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return _matchService.getMatchesInDateRange(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // NEW: Get matches for multiple teams (for followed teams)
  Stream<List<WaoMatch>> getMatchesForTeams(List<String> teamIds) {
    return _matchService.getMatchesForTeams(teamIds);
  }

  Future<String> createMatch({
    required String teamAId,
    required String teamBId,
    required String teamAName,
    required String teamBName,
    required MatchType type,
    required DateTime startTime,
    DateTime? scheduledDate,
    required String venue,
    String? championshipId,
  }) async {
    final id = await _matchService.createMatch(
      teamAId: teamAId,
      teamBId: teamBId,
      teamAName: teamAName,
      teamBName: teamBName,
      type: type,
      startTime: startTime,
      scheduledDate: scheduledDate,
      venue: venue,
      championshipId: championshipId,
    );
    notifyListeners();
    return id;
  }

  Future<void> updateScore(String matchId, int scoreA, int scoreB) async {
    await _matchService.updateScore(matchId, scoreA, scoreB);
    notifyListeners();
  }

  Future<void> updateCategoryScores({
    required String matchId,
    int? teamAKingdom,
    int? teamBKingdom,
    int? teamAWorkout,
    int? teamBWorkout,
    int? teamAGoalSetting,
    int? teamBGoalSetting,
    int? teamAJudges,
    int? teamBJudges,
  }) async {
    await _matchService.updateCategoryScores(
      matchId: matchId,
      teamAKingdom: teamAKingdom,
      teamBKingdom: teamBKingdom,
      teamAWorkout: teamAWorkout,
      teamBWorkout: teamBWorkout,
      teamAGoalSetting: teamAGoalSetting,
      teamBGoalSetting: teamBGoalSetting,
      teamAJudges: teamAJudges,
      teamBJudges: teamBJudges,
    );
    notifyListeners();
  }

  Future<void> updateMatchStatus(String matchId, MatchStatus status) async {
    await _matchService.updateMatchStatus(matchId, status);
    notifyListeners();
  }

  Future<void> startMatch(String matchId) async {
    await _matchService.startMatch(matchId);
    notifyListeners();
  }

  Future<void> endMatch(String matchId) async {
    await _matchService.endMatch(matchId);
    notifyListeners();
  }

  Future<void> deleteMatch(String matchId) async {
    await _matchService.deleteMatch(matchId);
    notifyListeners();
  }

  Future<void> seedMatches() async {
    await _matchService.seedMatches();
    notifyListeners();
  }

  Future<Map<String, dynamic>> getTeamStats(String teamId) async {
    return await _matchService.getTeamStats(teamId);
  }

  Future<bool> isMatchesEmpty() async {
    return await _matchService.isMatchesEmpty();
  }

  /// Toggle favorite status for a match
  Future<void> toggleMatchFavorite(String matchId, bool currentStatus) async {
    try {
      await _matchService.toggleMatchFavorite(matchId, !currentStatus);
      notifyListeners();
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  /// Get all favorite matches
  Stream<List<WaoMatch>> getFavoriteMatches() {
    return _matchService.getFavoriteMatches();
  }

  /// Get favorite matches for a specific date
  Stream<List<WaoMatch>> getFavoriteMatchesByDate(DateTime date) {
    return _matchService.getFavoriteMatchesByDate(date);
  }

}