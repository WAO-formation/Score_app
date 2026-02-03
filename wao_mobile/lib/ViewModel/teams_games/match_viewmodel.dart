// match_viewmodel.dart
import 'package:flutter/material.dart';
import '../../Model/teams_games/match_service.dart';
import '../../Model/teams_games/wao_match.dart';


class MatchViewModel extends ChangeNotifier {
  final MatchService _matchService = MatchService();

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

  Future<String> createMatch({
    required String teamAId,
    required String teamBId,
    required String teamAName,
    required String teamBName,
    required MatchType type,
    required DateTime startTime,
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
}