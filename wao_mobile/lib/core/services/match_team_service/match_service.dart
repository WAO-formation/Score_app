// match_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';

class MatchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<WaoMatch>> getAllMatches() {
    return _db
        .collection('matches')
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Stream<List<WaoMatch>> getMatchesByStatus(MatchStatus status) {
    return _db
        .collection('matches')
        .where('status', isEqualTo: status.name)
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      if (status == MatchStatus.finished) {
        matches.sort((a, b) => b.startTime.compareTo(a.startTime));
      } else {
        matches.sort((a, b) => a.startTime.compareTo(b.startTime));
      }

      return matches;
    });
  }

  Stream<List<WaoMatch>> getLiveMatches() {
    return getMatchesByStatus(MatchStatus.live);
  }

  Stream<List<WaoMatch>> getUpcomingMatches() {
    return getMatchesByStatus(MatchStatus.upcoming);
  }

  Stream<List<WaoMatch>> getFinishedMatches() {
    return getMatchesByStatus(MatchStatus.finished);
  }

  Stream<List<WaoMatch>> getMatchesByType(MatchType type) {
    return _db
        .collection('matches')
        .where('type', isEqualTo: type.name)
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      matches.sort((a, b) => b.startTime.compareTo(a.startTime));
      return matches;
    });
  }

  Stream<List<WaoMatch>> getTeamMatches(String teamId) {
    return _db
        .collection('matches')
        .where('teamAId', isEqualTo: teamId)
        .snapshots()
        .asyncMap((snapA) async {
      final matchesA = snapA.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      final snapB = await _db
          .collection('matches')
          .where('teamBId', isEqualTo: teamId)
          .get();

      final matchesB = snapB.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      final allMatches = [...matchesA, ...matchesB];
      allMatches.sort((a, b) => b.startTime.compareTo(a.startTime));
      return allMatches;
    });
  }

  Stream<List<WaoMatch>> getChampionshipMatches(String championshipId) {
    return _db
        .collection('matches')
        .where('championshipId', isEqualTo: championshipId)
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      matches.sort((a, b) => a.startTime.compareTo(b.startTime));
      return matches;
    });
  }

  // NEW: Get matches for a specific date
  Stream<List<WaoMatch>> getMatchesByDate(DateTime date) {
    // Start of day (00:00:00)
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    // End of day (23:59:59)
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _db
        .collection('matches')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      // Sort by start time (earliest first)
      matches.sort((a, b) => a.startTime.compareTo(b.startTime));
      return matches;
    });
  }

  // NEW: Get matches in a date range
  Stream<List<WaoMatch>> getMatchesInDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final start = DateTime(startDate.year, startDate.month, startDate.day, 0, 0, 0);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return _db
        .collection('matches')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      matches.sort((a, b) => a.startTime.compareTo(b.startTime));
      return matches;
    });
  }

  // NEW: Get matches for multiple teams (for followed teams)
  Stream<List<WaoMatch>> getMatchesForTeams(List<String> teamIds) {
    if (teamIds.isEmpty) {
      return Stream.value([]);
    }

    return _db
        .collection('matches')
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .where((match) => teamIds.contains(match.teamAId) || teamIds.contains(match.teamBId))
          .toList();

      matches.sort((a, b) => a.startTime.compareTo(b.startTime));
      return matches;
    });
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
    try {
      final docRef = await _db.collection('matches').add({
        'teamAId': teamAId,
        'teamBId': teamBId,
        'teamAName': teamAName,
        'teamBName': teamBName,
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': type.name,
        'startTime': Timestamp.fromDate(startTime),
        'scheduledDate': scheduledDate != null
            ? Timestamp.fromDate(scheduledDate)
            : null,
        'venue': venue,
        'championshipId': championshipId,
        'teamAKingdom': 0,
        'teamBKingdom': 0,
        'teamAWorkout': 0,
        'teamBWorkout': 0,
        'teamAGoalSetting': 0,
        'teamBGoalSetting': 0,
        'teamAJudges': 0,
        'teamBJudges': 0,
      }).timeout(const Duration(seconds: 5));

      return docRef.id;
    } catch (e) {
      print('Error creating match: $e');
      rethrow;
    }
  }

  Future<void> updateScore(String matchId, int scoreA, int scoreB) async {
    try {
      await _db
          .collection('matches')
          .doc(matchId)
          .update({
        'scoreA': scoreA,
        'scoreB': scoreB,
      })
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error updating score: $e');
      rethrow;
    }
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
    try {
      Map<String, dynamic> updates = {};

      if (teamAKingdom != null) updates['teamAKingdom'] = teamAKingdom;
      if (teamBKingdom != null) updates['teamBKingdom'] = teamBKingdom;
      if (teamAWorkout != null) updates['teamAWorkout'] = teamAWorkout;
      if (teamBWorkout != null) updates['teamBWorkout'] = teamBWorkout;
      if (teamAGoalSetting != null) updates['teamAGoalSetting'] = teamAGoalSetting;
      if (teamBGoalSetting != null) updates['teamBGoalSetting'] = teamBGoalSetting;
      if (teamAJudges != null) updates['teamAJudges'] = teamAJudges;
      if (teamBJudges != null) updates['teamBJudges'] = teamBJudges;

      if (updates.isNotEmpty) {
        await _db
            .collection('matches')
            .doc(matchId)
            .update(updates)
            .timeout(const Duration(seconds: 5));
      }
    } catch (e) {
      print('Error updating category scores: $e');
      rethrow;
    }
  }

  Future<void> updateMatchStatus(String matchId, MatchStatus status) async {
    try {
      await _db
          .collection('matches')
          .doc(matchId)
          .update({'status': status.name})
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error updating match status: $e');
      rethrow;
    }
  }

  Future<void> startMatch(String matchId) async {
    await updateMatchStatus(matchId, MatchStatus.live);
  }

  Future<void> endMatch(String matchId) async {
    await updateMatchStatus(matchId, MatchStatus.finished);
  }

  Future<void> deleteMatch(String matchId) async {
    try {
      await _db
          .collection('matches')
          .doc(matchId)
          .delete()
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error deleting match: $e');
      rethrow;
    }
  }

  Future<void> seedMatches() async {
    final now = DateTime.now();

    final List<Map<String, dynamic>> sampleMatches = [
      // Live matches
      {
        'teamAId': 'ug_warriors',
        'teamBId': 'knust_stars',
        'teamAName': 'UG Warriors',
        'teamBName': 'KNUST Stars',
        'scoreA': 45,
        'scoreB': 38,
        'status': MatchStatus.live.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.subtract(const Duration(minutes: 30))),
        'scheduledDate': Timestamp.fromDate(now.subtract(const Duration(minutes: 30))),
        'venue': 'Legon Sports Complex',
        'championshipId': null,
        'teamAKingdom': 120,
        'teamBKingdom': 95,
        'teamAWorkout': 85,
        'teamBWorkout': 110,
        'teamAGoalSetting': 100,
        'teamBGoalSetting': 88,
        'teamAJudges': 45,
        'teamBJudges': 38,
      },
      {
        'teamAId': 'ucc_titans',
        'teamBId': 'upsa_eagles',
        'teamAName': 'UCC Titans',
        'teamBName': 'UPSA Eagles',
        'scoreA': 52,
        'scoreB': 55,
        'status': MatchStatus.live.name,
        'type': MatchType.friendly.name,
        'startTime': Timestamp.fromDate(now.subtract(const Duration(minutes: 45))),
        'scheduledDate': Timestamp.fromDate(now.subtract(const Duration(minutes: 45))),
        'venue': 'Cape Coast Arena',
        'championshipId': null,
        'teamAKingdom': 90,
        'teamBKingdom': 105,
        'teamAWorkout': 92,
        'teamBWorkout': 88,
        'teamAGoalSetting': 78,
        'teamBGoalSetting': 95,
        'teamAJudges': 52,
        'teamBJudges': 55,
      },
      {
        'teamAId': 'wao_all_stars',
        'teamBId': 'national_champions',
        'teamAName': 'WAO All-Stars',
        'teamBName': 'National Champions',
        'scoreA': 67,
        'scoreB': 63,
        'status': MatchStatus.live.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.subtract(const Duration(hours: 1))),
        'scheduledDate': Timestamp.fromDate(now.subtract(const Duration(hours: 1))),
        'venue': 'WaoSphere',
        'championshipId': null,
        'teamAKingdom': 115,
        'teamBKingdom': 108,
        'teamAWorkout': 102,
        'teamBWorkout': 98,
        'teamAGoalSetting': 110,
        'teamBGoalSetting': 95,
        'teamAJudges': 67,
        'teamBJudges': 63,
      },

      // Upcoming matches - TODAY
      {
        'teamAId': 'legon_lions',
        'teamBId': 'knust_stars',
        'teamAName': 'Legon Lions',
        'teamBName': 'KNUST Stars',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(hours: 3))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(hours: 3))),
        'venue': 'Legon Stadium',
        'championshipId': null,
        'teamAKingdom': 0,
        'teamBKingdom': 0,
        'teamAWorkout': 0,
        'teamBWorkout': 0,
        'teamAGoalSetting': 0,
        'teamBGoalSetting': 0,
        'teamAJudges': 0,
        'teamBJudges': 0,
      },
      {
        'teamAId': 'gimpa_gladiators',
        'teamBId': 'ucc_titans',
        'teamAName': 'GIMPA Gladiators',
        'teamBName': 'UCC Titans',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.friendly.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(hours: 5))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(hours: 5))),
        'venue': 'GIMPA Arena',
        'championshipId': null,
        'teamAKingdom': 0,
        'teamBKingdom': 0,
        'teamAWorkout': 0,
        'teamBWorkout': 0,
        'teamAGoalSetting': 0,
        'teamBGoalSetting': 0,
        'teamAJudges': 0,
        'teamBJudges': 0,
      },

      // Upcoming matches - TOMORROW
      {
        'teamAId': 'ug_warriors',
        'teamBId': 'upsa_eagles',
        'teamAName': 'UG Warriors',
        'teamBName': 'UPSA Eagles',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(days: 1, hours: 14))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(days: 1, hours: 14))),
        'venue': 'National Stadium',
        'championshipId': null,
        'teamAKingdom': 0,
        'teamBKingdom': 0,
        'teamAWorkout': 0,
        'teamBWorkout': 0,
        'teamAGoalSetting': 0,
        'teamBGoalSetting': 0,
        'teamAJudges': 0,
        'teamBJudges': 0,
      },
      {
        'teamAId': 'wao_all_stars',
        'teamBId': 'legon_lions',
        'teamAName': 'WAO All-Stars',
        'teamBName': 'Legon Lions',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.friendly.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(days: 1, hours: 16))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(days: 1, hours: 16))),
        'venue': 'WaoSphere',
        'championshipId': null,
        'teamAKingdom': 0,
        'teamBKingdom': 0,
        'teamAWorkout': 0,
        'teamBWorkout': 0,
        'teamAGoalSetting': 0,
        'teamBGoalSetting': 0,
        'teamAJudges': 0,
        'teamBJudges': 0,
      },

      // Upcoming matches - DAY 3
      {
        'teamAId': 'upsa_eagles',
        'teamBId': 'ug_warriors',
        'teamAName': 'UPSA Eagles',
        'teamBName': 'UG Warriors',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(days: 3, hours: 14))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(days: 3, hours: 14))),
        'venue': 'UPSA Arena',
        'championshipId': null,
        'teamAKingdom': 0,
        'teamBKingdom': 0,
        'teamAWorkout': 0,
        'teamBWorkout': 0,
        'teamAGoalSetting': 0,
        'teamBGoalSetting': 0,
        'teamAJudges': 0,
        'teamBJudges': 0,
      },
      {
        'teamAId': 'knust_stars',
        'teamBId': 'gimpa_gladiators',
        'teamAName': 'KNUST Stars',
        'teamBName': 'GIMPA Gladiators',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.campusInternal.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(days: 3, hours: 18))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(days: 3, hours: 18))),
        'venue': 'KNUST Sports Complex',
        'championshipId': null,
        'teamAKingdom': 0,
        'teamBKingdom': 0,
        'teamAWorkout': 0,
        'teamBWorkout': 0,
        'teamAGoalSetting': 0,
        'teamBGoalSetting': 0,
        'teamAJudges': 0,
        'teamBJudges': 0,
      },

      // Upcoming matches - DAY 4
      {
        'teamAId': 'national_champions',
        'teamBId': 'ucc_titans',
        'teamAName': 'National Champions',
        'teamBName': 'UCC Titans',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.friendly.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(days: 4, hours: 10))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(days: 4, hours: 10))),
        'venue': 'Cape Coast Arena',
        'championshipId': null,
        'teamAKingdom': 0,
        'teamBKingdom': 0,
        'teamAWorkout': 0,
        'teamBWorkout': 0,
        'teamAGoalSetting': 0,
        'teamBGoalSetting': 0,
        'teamAJudges': 0,
        'teamBJudges': 0,
      },

      // Upcoming matches - DAY 5
      {
        'teamAId': 'legon_lions',
        'teamBId': 'upsa_eagles',
        'teamAName': 'Legon Lions',
        'teamBName': 'UPSA Eagles',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(days: 5, hours: 15))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(days: 5, hours: 15))),
        'venue': 'Legon Stadium',
        'championshipId': null,
        'teamAKingdom': 0,
        'teamBKingdom': 0,
        'teamAWorkout': 0,
        'teamBWorkout': 0,
        'teamAGoalSetting': 0,
        'teamBGoalSetting': 0,
        'teamAJudges': 0,
        'teamBJudges': 0,
      },

      // Finished matches
      {
        'teamAId': 'ug_warriors',
        'teamBId': 'ucc_titans',
        'teamAName': 'UG Warriors',
        'teamBName': 'UCC Titans',
        'scoreA': 58,
        'scoreB': 52,
        'status': MatchStatus.finished.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.subtract(const Duration(days: 2))),
        'scheduledDate': Timestamp.fromDate(now.subtract(const Duration(days: 2))),
        'venue': 'Legon Sports Complex',
        'championshipId': null,
        'teamAKingdom': 125,
        'teamBKingdom': 105,
        'teamAWorkout': 88,
        'teamBWorkout': 95,
        'teamAGoalSetting': 92,
        'teamBGoalSetting': 85,
        'teamAJudges': 58,
        'teamBJudges': 52,
      },
      {
        'teamAId': 'wao_all_stars',
        'teamBId': 'gimpa_gladiators',
        'teamAName': 'WAO All-Stars',
        'teamBName': 'GIMPA Gladiators',
        'scoreA': 71,
        'scoreB': 68,
        'status': MatchStatus.finished.name,
        'type': MatchType.friendly.name,
        'startTime': Timestamp.fromDate(now.subtract(const Duration(days: 5))),
        'scheduledDate': Timestamp.fromDate(now.subtract(const Duration(days: 5))),
        'venue': 'WaoSphere',
        'championshipId': null,
        'teamAKingdom': 118,
        'teamBKingdom': 112,
        'teamAWorkout': 105,
        'teamBWorkout': 102,
        'teamAGoalSetting': 98,
        'teamBGoalSetting': 95,
        'teamAJudges': 71,
        'teamBJudges': 68,
      },
    ];

    try {
      for (var match in sampleMatches) {
        await _db
            .collection('matches')
            .add(match)
            .timeout(const Duration(seconds: 5));
      }
      print('${sampleMatches.length} matches seeded successfully');
    } catch (e) {
      print('Error seeding matches: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTeamStats(String teamId) async {
    try {
      final matches = await _db
          .collection('matches')
          .where('status', isEqualTo: MatchStatus.finished.name)
          .get();

      int wins = 0;
      int losses = 0;
      int draws = 0;
      int totalPoints = 0;
      int totalConceded = 0;

      for (var doc in matches.docs) {
        final match = WaoMatch.fromFirestore(doc.data(), doc.id);
        final finalScores = match.getFinalScores();

        if (match.teamAId == teamId) {
          totalPoints += finalScores['teamA']!.round();
          totalConceded += finalScores['teamB']!.round();
          if (finalScores['teamA']! > finalScores['teamB']!) {
            wins++;
          } else if (finalScores['teamA']! < finalScores['teamB']!) {
            losses++;
          } else {
            draws++;
          }
        } else if (match.teamBId == teamId) {
          totalPoints += finalScores['teamB']!.round();
          totalConceded += finalScores['teamA']!.round();
          if (finalScores['teamB']! > finalScores['teamA']!) {
            wins++;
          } else if (finalScores['teamB']! < finalScores['teamA']!) {
            losses++;
          } else {
            draws++;
          }
        }
      }

      return {
        'wins': wins,
        'losses': losses,
        'draws': draws,
        'totalPoints': totalPoints,
        'totalConceded': totalConceded,
        'matchesPlayed': wins + losses + draws,
      };
    } catch (e) {
      print('Error getting team stats: $e');
      rethrow;
    }
  }

  Future<bool> isMatchesEmpty() async {
    try {
      final snapshot = await _db.collection('matches').limit(1).get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking matches: $e');
      return true;
    }
  }

  /// Toggle favorite status for a match
  Future<void> toggleMatchFavorite(String matchId, bool isFavorite) async {
    try {
      await _db
          .collection('matches')
          .doc(matchId)
          .update({'isFavorite': isFavorite})
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error toggling match favorite: $e');
      rethrow;
    }
  }

  /// Get all favorite matches
  Stream<List<WaoMatch>> getFavoriteMatches() {
    return _db
        .collection('matches')
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      matches.sort((a, b) => a.startTime.compareTo(b.startTime));
      return matches;
    });
  }

  /// Get favorite matches by date
  Stream<List<WaoMatch>> getFavoriteMatchesByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _db
        .collection('matches')
        .where('isFavorite', isEqualTo: true)
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      matches.sort((a, b) => a.startTime.compareTo(b.startTime));
      return matches;
    });
  }

}