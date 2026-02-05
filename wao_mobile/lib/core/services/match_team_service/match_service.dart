// services/match_service.dart
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
      },
      {
        'teamAId': 'ug_warriors',
        'teamBId': 'ucc_titans',
        'teamAName': 'UG Warriors',
        'teamBName': 'UCC Titans',
        'scoreA': 78,
        'scoreB': 72,
        'status': MatchStatus.finished.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.subtract(const Duration(days: 2))),
        'scheduledDate': Timestamp.fromDate(now.subtract(const Duration(days: 2))),
        'venue': 'University Gym',
        'championshipId': null,
      },
      {
        'teamAId': 'knust_stars',
        'teamBId': 'national_champions',
        'teamAName': 'KNUST Stars',
        'teamBName': 'National Champions',
        'scoreA': 65,
        'scoreB': 70,
        'status': MatchStatus.finished.name,
        'type': MatchType.friendly.name,
        'startTime': Timestamp.fromDate(now.subtract(const Duration(days: 7))),
        'scheduledDate': Timestamp.fromDate(now.subtract(const Duration(days: 7))),
        'venue': 'KNUST Sports Stadium',
        'championshipId': null,
      },
      {
        'teamAId': 'upsa_eagles',
        'teamBId': 'ug_warriors',
        'teamAName': 'UPSA Eagles',
        'teamBName': 'UG Warriors',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(days: 3))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(days: 3, hours: 14))),
        'venue': 'UPSA Arena',
        'championshipId': null,
      },
      {
        'teamAId': 'wao_all_stars',
        'teamBId': 'ucc_titans',
        'teamAName': 'WAO All-Stars',
        'teamBName': 'UCC Titans',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.campusInternal.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(days: 5))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(days: 5, hours: 16, minutes: 30))),
        'venue': 'WaoSphere',
        'championshipId': null,
      },
      {
        'teamAId': 'knust_stars',
        'teamBId': 'upsa_eagles',
        'teamAName': 'KNUST Stars',
        'teamBName': 'UPSA Eagles',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.friendly.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(hours: 6))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(hours: 6))),
        'venue': 'KNUST Sports Stadium',
        'championshipId': null,
      },
      {
        'teamAId': 'ug_warriors',
        'teamBId': 'wao_all_stars',
        'teamAName': 'UG Warriors',
        'teamBName': 'WAO All-Stars',
        'scoreA': 0,
        'scoreB': 0,
        'status': MatchStatus.upcoming.name,
        'type': MatchType.championship.name,
        'startTime': Timestamp.fromDate(now.add(const Duration(days: 1))),
        'scheduledDate': Timestamp.fromDate(now.add(const Duration(days: 1, hours: 18))),
        'venue': 'Legon Sports Complex',
        'championshipId': null,
      },
    ];

    try {
      for (var match in sampleMatches) {
        await _db
            .collection('matches')
            .add(match)
            .timeout(const Duration(seconds: 5));
      }
      print('Matches seeded successfully');
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

        if (match.teamAId == teamId) {
          totalPoints += match.scoreA;
          totalConceded += match.scoreB;
          if (match.scoreA > match.scoreB) {
            wins++;
          } else if (match.scoreA < match.scoreB) {
            losses++;
          } else {
            draws++;
          }
        } else if (match.teamBId == teamId) {
          totalPoints += match.scoreB;
          totalConceded += match.scoreA;
          if (match.scoreB > match.scoreA) {
            wins++;
          } else if (match.scoreB < match.scoreA) {
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
}