// wao_match.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum MatchStatus { live, upcoming, finished }
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

  // New scoring fields
  final int teamAKingdom;
  final int teamBKingdom;
  final int teamAWorkout;
  final int teamBWorkout;
  final int teamAGoalSetting;
  final int teamBGoalSetting;
  final int teamAJudges;
  final int teamBJudges;

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
    );
  }
}