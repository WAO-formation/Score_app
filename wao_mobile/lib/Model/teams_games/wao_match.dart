// wao_match.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum MatchStatus { live, upcoming, finished, postponed, suspended, cancelled }
enum MatchType { friendly, championship, campusInternal }

class WaoMatch {
  final String id;
  final String teamAId;
  final String teamBId;
  final String teamAName;
  final String teamBName;
  final int scoreA;
  final int scoreB;
  final MatchStatus status;
  final MatchType type;
  final DateTime startTime;
  final DateTime? scheduledDate;
  final String venue;
  final String? championshipId;
  final bool isFavorite;

  // New scoring fields
  final int teamAKingdom;
  final int teamBKingdom;
  final int teamAWorkout;
  final int teamBWorkout;
  final int teamAGoalSetting;
  final int teamBGoalSetting;
  final int teamAJudges;
  final int teamBJudges;

  // wao-web moderator/access-code + live-scoring-detail fields (additive —
  // mobile writes/reads these but its own UI doesn't require them to be set).
  final String? moderatorUid;
  final String? moderatorName;
  final List<Map<String, String>> judges;
  final Map<String, dynamic>? quarters;
  final Map<String, dynamic>? fouls;
  final List<Map<String, dynamic>> events;
  final String? currentQuarter;
  final String? timeRemaining;
  final String? championshipName;
  final DateTime? completedAt;

  WaoMatch({
    required this.id,
    required this.teamAId,
    required this.teamBId,
    required this.teamAName,
    required this.teamBName,
    this.scoreA = 0,
    this.scoreB = 0,
    required this.status,
    required this.type,
    required this.startTime,
    this.scheduledDate,
    required this.venue,
    this.championshipId,
    this.teamAKingdom = 0,
    this.teamBKingdom = 0,
    this.teamAWorkout = 0,
    this.teamBWorkout = 0,
    this.teamAGoalSetting = 0,
    this.teamBGoalSetting = 0,
    this.teamAJudges = 0,
    this.teamBJudges = 0,
    this.isFavorite = false,
    this.moderatorUid,
    this.moderatorName,
    this.judges = const [],
    this.quarters,
    this.fouls,
    this.events = const [],
    this.currentQuarter,
    this.timeRemaining,
    this.championshipName,
    this.completedAt,
  });

  // Calculate percentage for a category
  double _calculatePercentage(int teamScore, int totalScore) {
    if (totalScore == 0) return 0;
    return (teamScore / totalScore) * 100;
  }

  // Get Kingdom percentages
  Map<String, double> getKingdomPercentages() {
    final total = teamAKingdom + teamBKingdom;
    return {
      'teamA': _calculatePercentage(teamAKingdom, total),
      'teamB': _calculatePercentage(teamBKingdom, total),
    };
  }

  // Get Workout percentages
  Map<String, double> getWorkoutPercentages() {
    final total = teamAWorkout + teamBWorkout;
    return {
      'teamA': _calculatePercentage(teamAWorkout, total),
      'teamB': _calculatePercentage(teamBWorkout, total),
    };
  }

  // Get Goal Setting percentages
  Map<String, double> getGoalSettingPercentages() {
    final total = teamAGoalSetting + teamBGoalSetting;
    return {
      'teamA': _calculatePercentage(teamAGoalSetting, total),
      'teamB': _calculatePercentage(teamBGoalSetting, total),
    };
  }

  // Get Judges percentages
  Map<String, double> getJudgesPercentages() {
    final total = teamAJudges + teamBJudges;
    return {
      'teamA': _calculatePercentage(teamAJudges, total),
      'teamB': _calculatePercentage(teamBJudges, total),
    };
  }

  // Calculate final weighted score
  Map<String, double> getFinalScores() {
    final kingdomPercentages = getKingdomPercentages();
    final workoutPercentages = getWorkoutPercentages();
    final goalSettingPercentages = getGoalSettingPercentages();
    final judgesPercentages = getJudgesPercentages();

    final teamAScore = (kingdomPercentages['teamA']! * 0.30) +
        (workoutPercentages['teamA']! * 0.30) +
        (goalSettingPercentages['teamA']! * 0.30) +
        (judgesPercentages['teamA']! * 0.10);

    final teamBScore = (kingdomPercentages['teamB']! * 0.30) +
        (workoutPercentages['teamB']! * 0.30) +
        (goalSettingPercentages['teamB']! * 0.30) +
        (judgesPercentages['teamB']! * 0.10);

    return {
      'teamA': teamAScore,
      'teamB': teamBScore,
    };
  }

  factory WaoMatch.fromFirestore(Map<String, dynamic> data, String id) {
    return WaoMatch(
      id: id,
      teamAId: data['teamAId'] ?? '',
      teamBId: data['teamBId'] ?? '',
      teamAName: data['teamAName'] ?? '',
      teamBName: data['teamBName'] ?? '',
      scoreA: data['scoreA'] ?? 0,
      scoreB: data['scoreB'] ?? 0,
      status: MatchStatus.values.byName(data['status'] ?? 'upcoming'),
      type: MatchType.values.byName(data['type'] ?? 'friendly'),
      startTime: (data['startTime'] as Timestamp).toDate(),
      scheduledDate: data['scheduledDate'] != null
          ? (data['scheduledDate'] as Timestamp).toDate()
          : null,
      venue: data['venue'] ?? 'WaoSphere',
      championshipId: data['championshipId'],
      teamAKingdom: data['teamAKingdom'] ?? 0,
      teamBKingdom: data['teamBKingdom'] ?? 0,
      teamAWorkout: data['teamAWorkout'] ?? 0,
      teamBWorkout: data['teamBWorkout'] ?? 0,
      teamAGoalSetting: data['teamAGoalSetting'] ?? 0,
      teamBGoalSetting: data['teamBGoalSetting'] ?? 0,
      teamAJudges: data['teamAJudges'] ?? 0,
      teamBJudges: data['teamBJudges'] ?? 0,
      isFavorite: data['isFavorite'] ?? false,
      moderatorUid: data['moderatorUid'],
      moderatorName: data['moderatorName'],
      judges: data['judges'] != null
          ? List<Map<String, String>>.from(
              (data['judges'] as List).map((j) => Map<String, String>.from(j as Map)))
          : [],
      quarters: data['quarters'] != null
          ? Map<String, dynamic>.from(data['quarters'] as Map)
          : null,
      fouls: data['fouls'] != null
          ? Map<String, dynamic>.from(data['fouls'] as Map)
          : null,
      events: data['events'] != null
          ? List<Map<String, dynamic>>.from(
              (data['events'] as List).map((e) => Map<String, dynamic>.from(e as Map)))
          : [],
      currentQuarter: data['currentQuarter'],
      timeRemaining: data['timeRemaining'],
      championshipName: data['championshipName'],
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'teamAId': teamAId,
      'teamBId': teamBId,
      'teamAName': teamAName,
      'teamBName': teamBName,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'status': status.name,
      'type': type.name,
      'startTime': Timestamp.fromDate(startTime),
      'scheduledDate': scheduledDate != null
          ? Timestamp.fromDate(scheduledDate!)
          : null,
      'venue': venue,
      'championshipId': championshipId,
      'teamAKingdom': teamAKingdom,
      'teamBKingdom': teamBKingdom,
      'teamAWorkout': teamAWorkout,
      'teamBWorkout': teamBWorkout,
      'teamAGoalSetting': teamAGoalSetting,
      'teamBGoalSetting': teamBGoalSetting,
      'teamAJudges': teamAJudges,
      'teamBJudges': teamBJudges,
      'isFavorite': isFavorite,
      'moderatorUid': moderatorUid,
      'moderatorName': moderatorName,
      'judges': judges,
      'quarters': quarters,
      'fouls': fouls,
      'events': events,
      'currentQuarter': currentQuarter,
      'timeRemaining': timeRemaining,
      'championshipName': championshipName,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  String? getWinner() {
    if (status != MatchStatus.finished) return null;
    final finalScores = getFinalScores();
    if (finalScores['teamA']! > finalScores['teamB']!) return teamAName;
    if (finalScores['teamB']! > finalScores['teamA']!) return teamBName;
    return 'Draw';
  }

  WaoMatch copyWith({
    String? id,
    String? teamAId,
    String? teamBId,
    String? teamAName,
    String? teamBName,
    int? scoreA,
    int? scoreB,
    MatchStatus? status,
    MatchType? type,
    DateTime? startTime,
    DateTime? scheduledDate,
    String? venue,
    String? championshipId,
    int? teamAKingdom,
    int? teamBKingdom,
    int? teamAWorkout,
    int? teamBWorkout,
    int? teamAGoalSetting,
    int? teamBGoalSetting,
    int? teamAJudges,
    int? teamBJudges,
    bool? isFavorite,
    String? moderatorUid,
    String? moderatorName,
    List<Map<String, String>>? judges,
    Map<String, dynamic>? quarters,
    Map<String, dynamic>? fouls,
    List<Map<String, dynamic>>? events,
    String? currentQuarter,
    String? timeRemaining,
    String? championshipName,
    DateTime? completedAt,
  }) {
    return WaoMatch(
      id: id ?? this.id,
      teamAId: teamAId ?? this.teamAId,
      teamBId: teamBId ?? this.teamBId,
      teamAName: teamAName ?? this.teamAName,
      teamBName: teamBName ?? this.teamBName,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      status: status ?? this.status,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      venue: venue ?? this.venue,
      championshipId: championshipId ?? this.championshipId,
      teamAKingdom: teamAKingdom ?? this.teamAKingdom,
      teamBKingdom: teamBKingdom ?? this.teamBKingdom,
      teamAWorkout: teamAWorkout ?? this.teamAWorkout,
      teamBWorkout: teamBWorkout ?? this.teamBWorkout,
      teamAGoalSetting: teamAGoalSetting ?? this.teamAGoalSetting,
      teamBGoalSetting: teamBGoalSetting ?? this.teamBGoalSetting,
      teamAJudges: teamAJudges ?? this.teamAJudges,
      teamBJudges: teamBJudges ?? this.teamBJudges,
      isFavorite: isFavorite ?? this.isFavorite,
      moderatorUid: moderatorUid ?? this.moderatorUid,
      moderatorName: moderatorName ?? this.moderatorName,
      judges: judges ?? this.judges,
      quarters: quarters ?? this.quarters,
      fouls: fouls ?? this.fouls,
      events: events ?? this.events,
      currentQuarter: currentQuarter ?? this.currentQuarter,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      championshipName: championshipName ?? this.championshipName,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}