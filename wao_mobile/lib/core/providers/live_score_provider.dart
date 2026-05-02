import 'dart:async';
import 'package:flutter/material.dart';

enum MatchStatus { upcoming, live, paused, ended, extraTime, finished, halftime, scheduled }
enum Quarter { first, second, third, fourth, extraTime }
enum EventType { bounce, skillShow, goal, sacrifice, goalSetting, foul, timeout, substitution, injury }

class LiveScore {
  final String teamId;
  final double kingdom;
  final double workout;
  final double goalpost;
  final double judges;
  final int bounces;
  final int workoutSeconds;
  final int goals;
  final int sacrifices3pt;
  final int sacrifices33pt;
  final int goalSettings;

  LiveScore({
    required this.teamId,
    required this.kingdom,
    required this.workout,
    required this.goalpost,
    required this.judges,
    required this.bounces,
    required this.workoutSeconds,
    required this.goals,
    required this.sacrifices3pt,
    required this.sacrifices33pt,
    required this.goalSettings,
  });

  double get totalScore => kingdom + workout + goalpost + judges;

  factory LiveScore.empty(String teamId) => LiveScore(
        teamId: teamId,
        kingdom: 0, workout: 0, goalpost: 0, judges: 0,
        bounces: 0, workoutSeconds: 0, goals: 0,
        sacrifices3pt: 0, sacrifices33pt: 0, goalSettings: 0,
      );

  LiveScore copyWith({
    String? teamId, double? kingdom, double? workout, double? goalpost,
    double? judges, int? bounces, int? workoutSeconds, int? goals,
    int? sacrifices3pt, int? sacrifices33pt, int? goalSettings,
  }) => LiveScore(
        teamId: teamId ?? this.teamId,
        kingdom: kingdom ?? this.kingdom,
        workout: workout ?? this.workout,
        goalpost: goalpost ?? this.goalpost,
        judges: judges ?? this.judges,
        bounces: bounces ?? this.bounces,
        workoutSeconds: workoutSeconds ?? this.workoutSeconds,
        goals: goals ?? this.goals,
        sacrifices3pt: sacrifices3pt ?? this.sacrifices3pt,
        sacrifices33pt: sacrifices33pt ?? this.sacrifices33pt,
        goalSettings: goalSettings ?? this.goalSettings,
      );
}

class MatchEvent {
  final String id;
  final EventType type;
  final String teamId;
  final String? playerId;
  final DateTime timestamp;
  final Quarter quarter;
  final Duration matchTime;
  final String description;

  MatchEvent({
    required this.id, required this.type, required this.teamId,
    this.playerId, required this.timestamp, required this.quarter,
    required this.matchTime, required this.description,
  });
}

class PlayerFoul {
  final String id;
  final String playerId;
  final String playerName;
  final String teamId;
  final String foulType;
  final DateTime timestamp;
  final Quarter quarter;
  final Duration matchTime;
  final String description;
  final bool isCardGiven;
  final String? cardType;

  PlayerFoul({
    required this.id, required this.playerId, required this.playerName,
    required this.teamId, required this.foulType, required this.timestamp,
    required this.quarter, required this.matchTime, required this.description,
    required this.isCardGiven, this.cardType,
  });
}

class LiveMatchTeam {
  final String id;
  final String name;

  const LiveMatchTeam({required this.id, required this.name});
}

class LiveMatch {
  final String id;
  final String title;
  final LiveMatchTeam teamA;
  final LiveMatchTeam teamB;
  final MatchStatus status;
  final DateTime startTime;
  final DateTime? endTime;
  final Quarter currentQuarter;
  final Duration currentTime;
  final Duration? extraTime;
  final LiveScore teamAScore;
  final LiveScore teamBScore;
  final List<MatchEvent> events;
  final List<PlayerFoul> fouls;

  LiveMatch({
    required this.id, required this.title,
    required this.teamA, required this.teamB,
    required this.status, required this.startTime,
    this.endTime, required this.currentQuarter,
    required this.currentTime, this.extraTime,
    required this.teamAScore, required this.teamBScore,
    required this.events, required this.fouls,
  });

  String get displayTitle => '${teamA.name} vs ${teamB.name}';
  bool get isLive => status == MatchStatus.live;
  bool get isPaused => status == MatchStatus.paused;
  bool get isEnded => status == MatchStatus.ended;

  Duration get quarterDuration {
    switch (currentQuarter) {
      case Quarter.first:
      case Quarter.second:
        return const Duration(minutes: 17);
      case Quarter.third:
      case Quarter.fourth:
        return const Duration(minutes: 13);
      case Quarter.extraTime:
        return const Duration(minutes: 10);
    }
  }

  String get quarterDisplayString {
    switch (currentQuarter) {
      case Quarter.first: return '1st Q';
      case Quarter.second: return '2nd Q';
      case Quarter.third: return '3rd Q';
      case Quarter.fourth: return '4th Q';
      case Quarter.extraTime: return 'ET';
    }
  }

  LiveMatch copyWith({
    String? id, String? title, LiveMatchTeam? teamA, LiveMatchTeam? teamB,
    MatchStatus? status, DateTime? startTime, DateTime? endTime,
    Quarter? currentQuarter, Duration? currentTime, Duration? extraTime,
    LiveScore? teamAScore, LiveScore? teamBScore,
    List<MatchEvent>? events, List<PlayerFoul>? fouls,
  }) => LiveMatch(
        id: id ?? this.id, title: title ?? this.title,
        teamA: teamA ?? this.teamA, teamB: teamB ?? this.teamB,
        status: status ?? this.status, startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        currentQuarter: currentQuarter ?? this.currentQuarter,
        currentTime: currentTime ?? this.currentTime,
        extraTime: extraTime ?? this.extraTime,
        teamAScore: teamAScore ?? this.teamAScore,
        teamBScore: teamBScore ?? this.teamBScore,
        events: events ?? List.from(this.events),
        fouls: fouls ?? List.from(this.fouls),
      );
}

class LiveScoreProvider extends ChangeNotifier {
  List<LiveMatch> _liveMatches = [];
  LiveMatch? _selectedMatch;
  Timer? _matchTimer;

  List<LiveMatch> get liveMatches => _liveMatches;
  List<LiveMatch> get ongoingMatches => _liveMatches
      .where((m) => m.status == MatchStatus.live || m.status == MatchStatus.paused)
      .toList();
  List<LiveMatch> get endedMatches =>
      _liveMatches.where((m) => m.status == MatchStatus.ended).toList();
  LiveMatch? get selectedMatch => _selectedMatch;
  bool get hasLiveMatches => ongoingMatches.isNotEmpty;

  LiveScoreProvider() {
    _startMatchTimer();
  }

  void selectMatch(String matchId) {
    _selectedMatch = _liveMatches.firstWhere((m) => m.id == matchId,
        orElse: () => _liveMatches.first);
    notifyListeners();
  }

  void clearSelectedMatch() {
    _selectedMatch = null;
    notifyListeners();
  }

  void _startMatchTimer() {
    _matchTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      bool hasUpdates = false;
      for (int i = 0; i < _liveMatches.length; i++) {
        if (_liveMatches[i].isLive) {
          final m = _liveMatches[i];
          final newTime = m.currentTime + const Duration(seconds: 1);
          final maxTime = m.quarterDuration + (m.extraTime ?? Duration.zero);
          if (newTime <= maxTime) {
            _liveMatches[i] = m.copyWith(currentTime: newTime);
            hasUpdates = true;
          }
        }
      }
      if (hasUpdates) notifyListeners();
    });
  }

  @override
  void dispose() {
    _matchTimer?.cancel();
    super.dispose();
  }
}
