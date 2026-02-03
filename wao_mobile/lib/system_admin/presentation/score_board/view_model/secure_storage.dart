import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../model/live_score.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Keys for different Model types
  static const String _matchesKey = 'stored_matches';
  static const String _activeMatchKey = 'active_match';
  static const String _matchEventsKey = 'match_events';
  static const String _timerStateKey = 'timer_state';

  // Store matches
  static Future<void> storeMatches(List<LiveMatch> matches) async {
    try {
      final matchesJson = matches.map((match) => match.toJson()).toList();
      await _storage.write(
        key: _matchesKey,
        value: jsonEncode(matchesJson),
      );
    } catch (e) {
      print('Error storing matches: $e');
    }
  }

  // Retrieve matches
  static Future<List<LiveMatch>> getStoredMatches() async {
    try {
      final matchesString = await _storage.read(key: _matchesKey);
      if (matchesString != null) {
        final List<dynamic> matchesJson = jsonDecode(matchesString);
        return matchesJson.map((json) => LiveMatch.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error retrieving matches: $e');
    }
    return [];
  }

  // Store active match ID
  static Future<void> storeActiveMatchId(String matchId) async {
    await _storage.write(key: _activeMatchKey, value: matchId);
  }

  // Get active match ID
  static Future<String?> getActiveMatchId() async {
    return await _storage.read(key: _activeMatchKey);
  }

  // Store match events with unique IDs
  static Future<void> storeMatchEvents(String matchId, List<MatchEvent> events) async {
    try {
      final eventsJson = events.map((event) => event.toJson()).toList();
      await _storage.write(
        key: '${_matchEventsKey}_$matchId',
        value: jsonEncode(eventsJson),
      );
    } catch (e) {
      print('Error storing match events: $e');
    }
  }

  // Get match events
  static Future<List<MatchEvent>> getMatchEvents(String matchId) async {
    try {
      final eventsString = await _storage.read(key: '${_matchEventsKey}_$matchId');
      if (eventsString != null) {
        final List<dynamic> eventsJson = jsonDecode(eventsString);
        return eventsJson.map((json) => MatchEvent.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error retrieving match events: $e');
    }
    return [];
  }

  // Store timer state for specific match
  static Future<void> storeTimerState(String matchId, TimerState timerState) async {
    try {
      await _storage.write(
        key: '${_timerStateKey}_$matchId',
        value: jsonEncode(timerState.toJson()),
      );
    } catch (e) {
      print('Error storing timer state: $e');
    }
  }

  // Get timer state
  static Future<TimerState?> getTimerState(String matchId) async {
    try {
      final timerString = await _storage.read(key: '${_timerStateKey}_$matchId');
      if (timerString != null) {
        return TimerState.fromJson(jsonDecode(timerString));
      }
    } catch (e) {
      print('Error retrieving timer state: $e');
    }
    return null;
  }

  // Clear all stored Model
  static Future<void> clearAllData() async {
    await _storage.deleteAll();
  }

  // Clear specific match Model
  static Future<void> clearMatchData(String matchId) async {
    await _storage.delete(key: '${_matchEventsKey}_$matchId');
    await _storage.delete(key: '${_timerStateKey}_$matchId');
  }
}

// Timer state model for persistence
class TimerState {
  final Duration currentTime;
  final Duration remainingTime;
  final bool isRunning;
  final bool isPaused;
  final Quarter currentQuarter;
  final DateTime lastUpdated;

  TimerState({
    required this.currentTime,
    required this.remainingTime,
    required this.isRunning,
    required this.isPaused,
    required this.currentQuarter,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentTime': currentTime.inMilliseconds,
      'remainingTime': remainingTime.inMilliseconds,
      'isRunning': isRunning,
      'isPaused': isPaused,
      'currentQuarter': currentQuarter.name,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory TimerState.fromJson(Map<String, dynamic> json) {
    return TimerState(
      currentTime: Duration(milliseconds: json['currentTime']),
      remainingTime: Duration(milliseconds: json['remainingTime']),
      isRunning: json['isRunning'],
      isPaused: json['isPaused'],
      currentQuarter: Quarter.values.firstWhere((e) => e.name == json['currentQuarter']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }
}