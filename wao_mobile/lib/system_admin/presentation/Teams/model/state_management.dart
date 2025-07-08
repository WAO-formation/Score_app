// live_score_provider.dart
import 'package:flutter/material.dart';
import 'package:wao_mobile/system_admin/presentation/Teams/model/team_model.dart';
import 'dart:async';
import '../../score_board/model/live_score.dart';


class LiveScoreProvider extends ChangeNotifier {
  List<LiveMatch> _liveMatches = [];
  LiveMatch? _selectedMatch;
  Timer? _matchTimer;
  bool _isAdmin = false;

  // Getters
  List<LiveMatch> get liveMatches => _liveMatches;
  List<LiveMatch> get ongoingMatches => _liveMatches.where((match) =>
  match.status == MatchStatus.live || match.status == MatchStatus.paused).toList();
  List<LiveMatch> get endedMatches => _liveMatches.where((match) =>
  match.status == MatchStatus.ended).toList();
  LiveMatch? get selectedMatch => _selectedMatch;
  bool get isAdmin => _isAdmin;
  bool get hasLiveMatches => ongoingMatches.isNotEmpty;

  LiveScoreProvider() {
    _initializeSampleData();
    _startMatchTimer();
  }

  void _initializeSampleData() {
    _liveMatches = LiveMatch.getSampleLiveMatches();
    notifyListeners();
  }

  // Admin authentication
  void setAdminMode(bool isAdmin) {
    _isAdmin = isAdmin;
    notifyListeners();
  }

  // Match selection
  void selectMatch(String matchId) {
    _selectedMatch = _liveMatches.firstWhere(
          (match) => match.id == matchId,
      orElse: () => _liveMatches.first,
    );
    notifyListeners();
  }

  void clearSelectedMatch() {
    _selectedMatch = null;
    notifyListeners();
  }

  // Create new match
  Future<void> createMatch({
    required Teams teamA,
    required Teams teamB,
    DateTime? startTime,
  }) async {
    final newMatch = LiveMatch.create(
      id: 'live_${DateTime.now().millisecondsSinceEpoch}',
      teamA: teamA,
      teamB: teamB,
      startTime: startTime,
    );

    _liveMatches.add(newMatch);
    notifyListeners();
  }

  // Match control methods
  Future<void> startMatch(String matchId) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex != -1) {
      _liveMatches[matchIndex] = _liveMatches[matchIndex].copyWith(
        status: MatchStatus.live,
        startTime: DateTime.now(),
      );
      notifyListeners();
    }
  }

  Future<void> pauseMatch(String matchId) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex != -1 && _liveMatches[matchIndex].isLive) {
      _liveMatches[matchIndex] = _liveMatches[matchIndex].copyWith(
        status: MatchStatus.paused,
      );
      notifyListeners();
    }
  }

  Future<void> resumeMatch(String matchId) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex != -1 && _liveMatches[matchIndex].isPaused) {
      _liveMatches[matchIndex] = _liveMatches[matchIndex].copyWith(
        status: MatchStatus.live,
      );
      notifyListeners();
    }
  }

  Future<void> endMatch(String matchId) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex != -1) {
      _liveMatches[matchIndex] = _liveMatches[matchIndex].copyWith(
        status: MatchStatus.ended,
        endTime: DateTime.now(),
      );
      notifyListeners();
    }
  }

  // Quarter management
  Future<void> nextQuarter(String matchId) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex != -1) {
      final currentMatch = _liveMatches[matchIndex];
      Quarter nextQuarter;

      switch (currentMatch.currentQuarter) {
        case Quarter.first:
          nextQuarter = Quarter.second;
          break;
        case Quarter.second:
          nextQuarter = Quarter.third;
          break;
        case Quarter.third:
          nextQuarter = Quarter.fourth;
          break;
        case Quarter.fourth:
        // Check if scores are tied for extra time
          if (currentMatch.teamAScore.totalScore == currentMatch.teamBScore.totalScore) {
            nextQuarter = Quarter.extraTime;
          } else {
            await endMatch(matchId);
            return;
          }
          break;
        default:
          await endMatch(matchId);
          return;
      }

      _liveMatches[matchIndex] = currentMatch.copyWith(
        currentQuarter: nextQuarter,
        currentTime: Duration.zero,
      );
      notifyListeners();
    }
  }

  // Time management
  Future<void> addExtraTime(String matchId, Duration extraTime) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex != -1) {
      final currentMatch = _liveMatches[matchIndex];
      final newExtraTime = (currentMatch.extraTime ?? Duration.zero) + extraTime;

      _liveMatches[matchIndex] = currentMatch.copyWith(
        extraTime: newExtraTime,
      );
      notifyListeners();
    }
  }

  Future<void> resetQuarterTime(String matchId) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex != -1) {
      _liveMatches[matchIndex] = _liveMatches[matchIndex].copyWith(
        currentTime: Duration.zero,
      );
      notifyListeners();
    }
  }

  // Score update methods
  Future<void> updateTeamScore({
    required String matchId,
    required String teamId,
    int? additionalBounces,
    int? additionalWorkoutSeconds,
    int? additionalGoals,
    int? additionalSacrifices3pt,
    int? additionalSacrifices33pt,
    int? additionalGoalSettings,
    double? judgesOverride,
  }) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex == -1) return;

    final currentMatch = _liveMatches[matchIndex];
    LiveScore updatedScore;
    LiveMatch updatedMatch;

    if (currentMatch.teamA.id == teamId) {
      updatedScore = ScoreCalculator.updateScore(
        currentMatch.teamAScore,
        additionalBounces: additionalBounces,
        additionalWorkoutSeconds: additionalWorkoutSeconds,
        additionalGoals: additionalGoals,
        additionalSacrifices3pt: additionalSacrifices3pt,
        additionalSacrifices33pt: additionalSacrifices33pt,
        additionalGoalSettings: additionalGoalSettings,
        judgesOverride: judgesOverride,
      );
      updatedMatch = currentMatch.copyWith(teamAScore: updatedScore);
    } else {
      updatedScore = ScoreCalculator.updateScore(
        currentMatch.teamBScore,
        additionalBounces: additionalBounces,
        additionalWorkoutSeconds: additionalWorkoutSeconds,
        additionalGoals: additionalGoals,
        additionalSacrifices3pt: additionalSacrifices3pt,
        additionalSacrifices33pt: additionalSacrifices33pt,
        additionalGoalSettings: additionalGoalSettings,
        judgesOverride: judgesOverride,
      );
      updatedMatch = currentMatch.copyWith(teamBScore: updatedScore);
    }

    _liveMatches[matchIndex] = updatedMatch;

    // Add event to match history
    await _addMatchEvent(
      matchId: matchId,
      teamId: teamId,
      type: _getEventTypeFromUpdate(
        additionalBounces: additionalBounces,
        additionalGoals: additionalGoals,
        additionalSacrifices3pt: additionalSacrifices3pt,
        additionalSacrifices33pt: additionalSacrifices33pt,
      ),
      description: _generateEventDescription(
        additionalBounces: additionalBounces,
        additionalWorkoutSeconds: additionalWorkoutSeconds,
        additionalGoals: additionalGoals,
        additionalSacrifices3pt: additionalSacrifices3pt,
        additionalSacrifices33pt: additionalSacrifices33pt,
        additionalGoalSettings: additionalGoalSettings,
      ),
    );

    notifyListeners();
  }

  // Event management
  Future<void> _addMatchEvent({
    required String matchId,
    required String teamId,
    required EventType type,
    required String description,
    String? playerId,
    Map<String, dynamic>? data,
  }) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex == -1) return;

    final currentMatch = _liveMatches[matchIndex];
    final event = MatchEvent(
      id: 'event_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      teamId: teamId,
      playerId: playerId,
      timestamp: DateTime.now(),
      quarter: currentMatch.currentQuarter,
      matchTime: currentMatch.currentTime,
      description: description,
      data: data,
    );

    final updatedEvents = List<MatchEvent>.from(currentMatch.events)..add(event);
    _liveMatches[matchIndex] = currentMatch.copyWith(events: updatedEvents);
  }

  // Foul management
  Future<void> addPlayerFoul({
    required String matchId,
    required String playerId,
    required String playerName,
    required String teamId,
    required String foulType,
    required String description,
    bool isCardGiven = false,
    String? cardType,
  }) async {
    final matchIndex = _liveMatches.indexWhere((match) => match.id == matchId);
    if (matchIndex == -1) return;

    final currentMatch = _liveMatches[matchIndex];
    final foul = PlayerFoul(
      id: 'foul_${DateTime.now().millisecondsSinceEpoch}',
      playerId: playerId,
      playerName: playerName,
      teamId: teamId,
      foulType: foulType,
      timestamp: DateTime.now(),
      quarter: currentMatch.currentQuarter,
      matchTime: currentMatch.currentTime,
      description: description,
      isCardGiven: isCardGiven,
      cardType: cardType,
    );

    final updatedFouls = List<PlayerFoul>.from(currentMatch.fouls)..add(foul);
    _liveMatches[matchIndex] = currentMatch.copyWith(fouls: updatedFouls);

    // Also add as an event
    await _addMatchEvent(
      matchId: matchId,
      teamId: teamId,
      type: EventType.foul,
      description: description,
      playerId: playerId,
      data: {'foulType': foulType, 'cardGiven': isCardGiven, 'cardType': cardType},
    );

    notifyListeners();
  }

  // Timer management
  void _startMatchTimer() {
    _matchTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      bool hasUpdates = false;

      for (int i = 0; i < _liveMatches.length; i++) {
        if (_liveMatches[i].isLive) {
          final currentMatch = _liveMatches[i];
          final newTime = currentMatch.currentTime + Duration(seconds: 1);
          final maxTime = currentMatch.quarterDuration + (currentMatch.extraTime ?? Duration.zero);

          if (newTime <= maxTime) {
            _liveMatches[i] = currentMatch.copyWith(currentTime: newTime);
            hasUpdates = true;
          }
        }
      }

      if (hasUpdates) {
        notifyListeners();
      }
    });
  }

  // Helper methods
  EventType _getEventTypeFromUpdate({
    int? additionalBounces,
    int? additionalGoals,
    int? additionalSacrifices3pt,
    int? additionalSacrifices33pt,
  }) {
    if (additionalGoals != null && additionalGoals > 0) return EventType.goal;
    if (additionalSacrifices3pt != null && additionalSacrifices3pt > 0) return EventType.sacrifice;
    if (additionalSacrifices33pt != null && additionalSacrifices33pt > 0) return EventType.sacrifice;
    if (additionalBounces != null && additionalBounces > 0) return EventType.bounce;
    return EventType.skillShow;
  }

  String _generateEventDescription({
    int? additionalBounces,
    int? additionalWorkoutSeconds,
    int? additionalGoals,
    int? additionalSacrifices3pt,
    int? additionalSacrifices33pt,
    int? additionalGoalSettings,
  }) {
    List<String> updates = [];

    if (additionalBounces != null && additionalBounces > 0) {
      updates.add('$additionalBounces bounce${additionalBounces > 1 ? 's' : ''}');
    }
    if (additionalGoals != null && additionalGoals > 0) {
      updates.add('$additionalGoals goal${additionalGoals > 1 ? 's' : ''}');
    }
    if (additionalSacrifices3pt != null && additionalSacrifices3pt > 0) {
      updates.add('$additionalSacrifices3pt 3pt sacrifice${additionalSacrifices3pt > 1 ? 's' : ''}');
    }
    if (additionalSacrifices33pt != null && additionalSacrifices33pt > 0) {
      updates.add('$additionalSacrifices33pt 33pt sacrifice${additionalSacrifices33pt > 1 ? 's' : ''}');
    }
    if (additionalGoalSettings != null && additionalGoalSettings > 0) {
      updates.add('$additionalGoalSettings goal setting${additionalGoalSettings > 1 ? 's' : ''}');
    }
    if (additionalWorkoutSeconds != null && additionalWorkoutSeconds > 0) {
      updates.add('${additionalWorkoutSeconds}s workout time');
    }

    return updates.isEmpty ? 'Score updated' : updates.join(', ');
  }

  @override
  void dispose() {
    _matchTimer?.cancel();
    super.dispose();
  }
}