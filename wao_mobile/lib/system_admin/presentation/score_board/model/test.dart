// live_score_model.dart
import 'package:wao_mobile/system_admin/presentation/Teams/model/team_model.dart';



enum MatchStatus { upcoming, live, paused, ended, extraTime, finished, halftime, scheduled }
enum Quarter { first, second, third, fourth, extraTime }

class LiveMatch {
  final String id;
  final String title;
  final Teams teamA;
  final Teams teamB;
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
    required this.id,
    required this.title,
    required this.teamA,
    required this.teamB,
    required this.status,
    required this.startTime,
    this.endTime,
    required this.currentQuarter,
    required this.currentTime,
    this.extraTime,
    required this.teamAScore,
    required this.teamBScore,
    required this.events,
    required this.fouls,
  });

  String get displayTitle => '${teamA.name} vs ${teamB.name}';

  bool get isLive => status == MatchStatus.live;
  bool get isPaused => status == MatchStatus.paused;
  bool get isEnded => status == MatchStatus.ended;
  bool get isInExtraTime => status == MatchStatus.extraTime;

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

  String get timeDisplayString {
    int minutes = currentTime.inMinutes;
    int seconds = currentTime.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get quarterDisplayString {
    switch (currentQuarter) {
      case Quarter.first:
        return '1st Q';
      case Quarter.second:
        return '2nd Q';
      case Quarter.third:
        return '3rd Q';
      case Quarter.fourth:
        return '4th Q';
      case Quarter.extraTime:
        return 'ET';
    }
  }

  // Factory for creating a new match
  factory LiveMatch.create({
    required String id,
    required Teams teamA,
    required Teams teamB,
    DateTime? startTime,
  }) {
    return LiveMatch(
      id: id,
      title: '${teamA.name} vs ${teamB.name}',
      teamA: teamA,
      teamB: teamB,
      status: MatchStatus.upcoming,
      startTime: startTime ?? DateTime.now(),
      currentQuarter: Quarter.first,
      currentTime: Duration.zero,
      teamAScore: LiveScore.empty(teamA.id),
      teamBScore: LiveScore.empty(teamB.id),
      events: [],
      fouls: [],
    );
  }

  LiveMatch copyWith({
    String? id,
    String? title,
    Teams? teamA,
    Teams? teamB,
    MatchStatus? status,
    DateTime? startTime,
    DateTime? endTime,
    Quarter? currentQuarter,
    Duration? currentTime,
    Duration? extraTime,
    LiveScore? teamAScore,
    LiveScore? teamBScore,
    List<MatchEvent>? events,
    List<PlayerFoul>? fouls,
  }) {
    return LiveMatch(
      id: id ?? this.id,
      title: title ?? this.title,
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
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

  // Static method for sample live matches
  static List<LiveMatch> getSampleLiveMatches() {
    List<Teams> teams = Teams.getSampleTeams();

    return [
      LiveMatch.create(
        id: 'live_001',
        teamA: teams[0], // Thunder Bolts
        teamB: teams[1], // Fire Eagles
        startTime: DateTime.now().subtract(const Duration(minutes: 1)),
      ).copyWith(
        status: MatchStatus.live,
        currentQuarter: Quarter.second,
        currentTime: const Duration(minutes: 1, seconds: 45),
        teamAScore: LiveScore(
          teamId: teams[0].id,
          kingdom:0,
          workout: 0,
          goalpost: 0,
          judges: 0,
          bounces: 0,
          workoutSeconds: 0,
          goals: 0,
          sacrifices3pt: 0,
          sacrifices33pt: 0,
          goalSettings: 0,
        ),
        teamBScore: LiveScore(
          teamId: teams[1].id,
          kingdom: 0,
          workout: 0,
          goalpost: 0,
          judges: 0,
          bounces: 0,
          workoutSeconds: 0,
          goals: 0,
          sacrifices3pt: 0,
          sacrifices33pt: 0,
          goalSettings: 0,
        ),
      ),

      LiveMatch.create(
        id: 'live_002',
        teamA: teams[2], // Ice Wolves
        teamB: teams[3], // Storm Hawks
        startTime: DateTime.now().subtract(const Duration(minutes: 1)),
      ).copyWith(
        status: MatchStatus.paused,
        currentQuarter: Quarter.third,
        currentTime: const Duration(minutes: 1, seconds: 12),
        teamAScore: LiveScore(
          teamId: teams[2].id,
          kingdom: 0,
          workout: 0,
          goalpost: 0,
          judges: 0,
          bounces: 0,
          workoutSeconds: 0,
          goals: 0,
          sacrifices3pt: 0,
          sacrifices33pt: 0,
          goalSettings: 0,
        ),
        teamBScore: LiveScore(
          teamId: teams[3].id,
          kingdom: 0,
          workout: 0,
          goalpost: 0,
          judges: 0,
          bounces: 0,
          workoutSeconds: 0,
          goals: 0,
          sacrifices3pt: 0,
          sacrifices33pt: 0,
          goalSettings: 0,
        ),
      ),
    ];
  }
}

class LiveScore {
  final String teamId;
  final double kingdom;
  final double workout;
  final double goalpost;
  final double judges;

  // Raw Model for calculations
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

  // Factory for empty score
  factory LiveScore.empty(String teamId) {
    return LiveScore(
      teamId: teamId,
      kingdom: 0.0,
      workout: 0.0,
      goalpost: 0.0,
      judges: 0.0,
      bounces: 0,
      workoutSeconds: 0,
      goals: 0,
      sacrifices3pt: 0,
      sacrifices33pt: 0,
      goalSettings: 0,
    );
  }

  LiveScore copyWith({
    String? teamId,
    double? kingdom,
    double? workout,
    double? goalpost,
    double? judges,
    int? bounces,
    int? workoutSeconds,
    int? goals,
    int? sacrifices3pt,
    int? sacrifices33pt,
    int? goalSettings,
  }) {
    return LiveScore(
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
}

enum EventType { bounce, skillShow, goal, sacrifice, goalSetting, foul, timeout, substitution, injury }

class MatchEvent {
  final String id;
  final EventType type;
  final String teamId;
  final String? playerId;
  final DateTime timestamp;
  final Quarter quarter;
  final Duration matchTime;
  final String description;
  final Map<String, dynamic>? data;

  MatchEvent({
    required this.id,
    required this.type,
    required this.teamId,
    this.playerId,
    required this.timestamp,
    required this.quarter,
    required this.matchTime,
    required this.description,
    this.data,
  });

  MatchEvent copyWith({
    String? id,
    EventType? type,
    String? teamId,
    String? playerId,
    DateTime? timestamp,
    Quarter? quarter,
    Duration? matchTime,
    String? description,
    Map<String, dynamic>? data,
  }) {
    return MatchEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      teamId: teamId ?? this.teamId,
      playerId: playerId ?? this.playerId,
      timestamp: timestamp ?? this.timestamp,
      quarter: quarter ?? this.quarter,
      matchTime: matchTime ?? this.matchTime,
      description: description ?? this.description,
      data: data ?? this.data,
    );
  }
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
    required this.id,
    required this.playerId,
    required this.playerName,
    required this.teamId,
    required this.foulType,
    required this.timestamp,
    required this.quarter,
    required this.matchTime,
    required this.description,
    required this.isCardGiven,
    this.cardType,
  });

  PlayerFoul copyWith({
    String? id,
    String? playerId,
    String? playerName,
    String? teamId,
    String? foulType,
    DateTime? timestamp,
    Quarter? quarter,
    Duration? matchTime,
    String? description,
    bool? isCardGiven,
    String? cardType,
  }) {
    return PlayerFoul(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      playerName: playerName ?? this.playerName,
      teamId: teamId ?? this.teamId,
      foulType: foulType ?? this.foulType,
      timestamp: timestamp ?? this.timestamp,
      quarter: quarter ?? this.quarter,
      matchTime: matchTime ?? this.matchTime,
      description: description ?? this.description,
      isCardGiven: isCardGiven ?? this.isCardGiven,
      cardType: cardType ?? this.cardType,
    );
  }
}

// Helper class for score calculations
class ScoreCalculator {
  // Calculate Kingdom percentage from bounces
  static double calculateKingdomScore(int bounces) {
    // Example calculation - adjust based on your WAO! rules
    return (bounces * 5.5).clamp(0.0, 100.0);
  }

  // Calculate Workout percentage from seconds
  static double calculateWorkoutScore(int seconds) {
    // Example calculation - adjust based on your WAO! rules
    double minutes = seconds / 60.0;
    return (minutes * 8.2).clamp(0.0, 100.0);
  }

  // Calculate Goalpost percentage from goals and special actions
  static double calculateGoalpostScore({
    required int goals,
    required int sacrifices3pt,
    required int sacrifices33pt,
    required int goalSettings,
  }) {
    double baseScore = goals * 10.0;
    double sacrificeScore = (sacrifices3pt * 3.0) + (sacrifices33pt * 33.0);
    double goalSettingScore = goalSettings * 2.0;

    return (baseScore + sacrificeScore + goalSettingScore).clamp(0.0, 100.0);
  }

  // Update live score with new Model
  static LiveScore updateScore(LiveScore currentScore, {
    int? additionalBounces,
    int? additionalWorkoutSeconds,
    int? additionalGoals,
    int? additionalSacrifices3pt,
    int? additionalSacrifices33pt,
    int? additionalGoalSettings,
    double? judgesOverride,
  }) {
    int newBounces = currentScore.bounces + (additionalBounces ?? 0);
    int newWorkoutSeconds = currentScore.workoutSeconds + (additionalWorkoutSeconds ?? 0);
    int newGoals = currentScore.goals + (additionalGoals ?? 0);
    int newSacrifices3pt = currentScore.sacrifices3pt + (additionalSacrifices3pt ?? 0);
    int newSacrifices33pt = currentScore.sacrifices33pt + (additionalSacrifices33pt ?? 0);
    int newGoalSettings = currentScore.goalSettings + (additionalGoalSettings ?? 0);

    return currentScore.copyWith(
      bounces: newBounces,
      workoutSeconds: newWorkoutSeconds,
      goals: newGoals,
      sacrifices3pt: newSacrifices3pt,
      sacrifices33pt: newSacrifices33pt,
      goalSettings: newGoalSettings,
      kingdom: calculateKingdomScore(newBounces),
      workout: calculateWorkoutScore(newWorkoutSeconds),
      goalpost: calculateGoalpostScore(
        goals: newGoals,
        sacrifices3pt: newSacrifices3pt,
        sacrifices33pt: newSacrifices33pt,
        goalSettings: newGoalSettings,
      ),
      judges: judgesOverride ?? currentScore.judges,
    );
  }
}

