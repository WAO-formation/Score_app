import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:wao_mobile/system_admin/presentation/score_board/view_model/secure_storage.dart';
import '../model/live_score.dart';


class MatchStateManager extends ChangeNotifier {
  static final MatchStateManager _instance = MatchStateManager._internal();
  factory MatchStateManager() => _instance;
  MatchStateManager._internal();

  // Current matches state
  List<LiveMatch> _matches = [];
  String? _activeMatchId;
  Map<String, Timer> _matchTimers = {};
  Map<String, StreamController<LiveMatch>> _matchStreams = {};

  // Getters
  List<LiveMatch> get matches => List.unmodifiable(_matches);
  String? get activeMatchId => _activeMatchId;

  List<LiveMatch> get liveMatches =>
      _matches.where((match) => match.isLive || match.isPaused).toList();

  List<LiveMatch> get completedMatches =>
      _matches.where((match) => match.isEnded).toList();

  // Initialize and load stored Model
  Future<void> initialize() async {
    await _loadStoredMatches();
    await _loadActiveMatch();
    _startPeriodicSave();
  }

  // Load matches from secure storage
  Future<void> _loadStoredMatches() async {
    try {
      final storedMatches = await SecureStorageService.getStoredMatches();
      _matches = storedMatches;

      // Restore timers for live matches
      for (final match in _matches.where((m) => m.isLive)) {
        await _restoreMatchTimer(match);
      }

      notifyListeners();
    } catch (e) {
      print('Error loading stored matches: $e');
    }
  }

  // Load active match
  Future<void> _loadActiveMatch() async {
    _activeMatchId = await SecureStorageService.getActiveMatchId();
  }

  // Restore timer for a specific match
  Future<void> _restoreMatchTimer(LiveMatch match) async {
    final timerState = await SecureStorageService.getTimerState(match.id);
    if (timerState != null) {
      // Calculate time elapsed since last save
      final now = DateTime.now();
      final elapsed = now.difference(timerState.lastUpdated);

      if (timerState.isRunning && !timerState.isPaused) {
        // Update match time based on elapsed time
        final newCurrentTime = timerState.currentTime + elapsed;
        final updatedMatch = match.copyWith(currentTime: newCurrentTime);
        _updateMatchInList(updatedMatch);

        // Restart timer
        _startMatchTimer(updatedMatch);
      }
    }
  }

  // Add or update match
  Future<void> updateMatch(LiveMatch match) async {
    _updateMatchInList(match);
    await _saveMatches();

    // Handle timer based on match status
    if (match.isLive && !_matchTimers.containsKey(match.id)) {
      _startMatchTimer(match);
    } else if (!match.isLive && _matchTimers.containsKey(match.id)) {
      _stopMatchTimer(match.id);
    }

    // Broadcast match update
    _broadcastMatchUpdate(match);
    notifyListeners();
  }

  // Update match in the list
  void _updateMatchInList(LiveMatch match) {
    final index = _matches.indexWhere((m) => m.id == match.id);
    if (index != -1) {
      _matches[index] = match;
    } else {
      _matches.add(match);
    }
  }

  // Start timer for a match
  void _startMatchTimer(LiveMatch match) {
    _stopMatchTimer(match.id); // Stop existing timer if any

    _matchTimers[match.id] = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentMatch = _matches.firstWhere((m) => m.id == match.id);
      if (currentMatch.isLive) {
        final updatedMatch = currentMatch.copyWith(
          currentTime: currentMatch.currentTime + const Duration(seconds: 1),
        );

        _updateMatchInList(updatedMatch);
        _broadcastMatchUpdate(updatedMatch);

        // Auto-save timer state every 10 seconds
        if (updatedMatch.currentTime.inSeconds % 10 == 0) {
          _saveTimerState(updatedMatch);
        }

        notifyListeners();
      } else {
        timer.cancel();
        _matchTimers.remove(match.id);
      }
    });
  }

  // Stop timer for a match
  void _stopMatchTimer(String matchId) {
    _matchTimers[matchId]?.cancel();
    _matchTimers.remove(matchId);
  }

  // Save timer state
  Future<void> _saveTimerState(LiveMatch match) async {
    final quarterDuration = match.quarterDuration;
    final remainingTime = quarterDuration - match.currentTime;

    final timerState = TimerState(
      currentTime: match.currentTime,
      remainingTime: remainingTime.isNegative ? Duration.zero : remainingTime,
      isRunning: match.isLive,
      isPaused: match.isPaused,
      currentQuarter: match.currentQuarter,
      lastUpdated: DateTime.now(),
    );

    await SecureStorageService.storeTimerState(match.id, timerState);
  }

  // Set active match
  Future<void> setActiveMatch(String matchId) async {
    _activeMatchId = matchId;
    await SecureStorageService.storeActiveMatchId(matchId);
    notifyListeners();
  }

  // Get match stream for real-time updates
  Stream<LiveMatch> getMatchStream(String matchId) {
    if (!_matchStreams.containsKey(matchId)) {
      _matchStreams[matchId] = StreamController<LiveMatch>.broadcast();
    }
    return _matchStreams[matchId]!.stream;
  }

  // Broadcast match update to stream
  void _broadcastMatchUpdate(LiveMatch match) {
    if (_matchStreams.containsKey(match.id)) {
      _matchStreams[match.id]!.add(match);
    }
  }

  // Add event to match
  Future<void> addEventToMatch(String matchId, MatchEvent event) async {
    final match = _matches.firstWhere((m) => m.id == matchId);
    final updatedEvents = [...match.events, event];
    final updatedMatch = match.copyWith(events: updatedEvents);

    await updateMatch(updatedMatch);
    await SecureStorageService.storeMatchEvents(matchId, updatedEvents);
  }

  // Update match score
  Future<void> updateMatchScore(String matchId, String teamId, String category, double value) async {
    final match = _matches.firstWhere((m) => m.id == matchId);
    LiveMatch updatedMatch;

    if (match.teamA.id == teamId) {
      final updatedScore = _updateScoreCategory(match.teamAScore, category, value);
      updatedMatch = match.copyWith(teamAScore: updatedScore);
    } else {
      final updatedScore = _updateScoreCategory(match.teamBScore, category, value);
      updatedMatch = match.copyWith(teamBScore: updatedScore);
    }

    await updateMatch(updatedMatch);
  }

  // Helper to update score category
  LiveScore _updateScoreCategory(LiveScore score, String category, double value) {
    switch (category.toLowerCase()) {
      case 'kg':
      case 'kingdom':
        return score.copyWith(kingdom: value);
      case 'wk':
      case 'workout':
        return score.copyWith(workout: value);
      case 'gp':
      case 'goalpost':
        return score.copyWith(goalpost: value);
      case 'jg':
      case 'judges':
        return score.copyWith(judges: value);
      default:
        return score;
    }
  }

  // Save matches to storage
  Future<void> _saveMatches() async {
    await SecureStorageService.storeMatches(_matches);
  }

  // Start periodic save
  void _startPeriodicSave() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _saveMatches();
    });
  }

  // Get match by ID
  LiveMatch? getMatchById(String matchId) {
    try {
      return _matches.firstWhere((match) => match.id == matchId);
    } catch (e) {
      return null;
    }
  }

  // Clean up resources
  @override
  void dispose() {
    for (final timer in _matchTimers.values) {
      timer.cancel();
    }
    for (final stream in _matchStreams.values) {
      stream.close();
    }
    super.dispose();
  }
}