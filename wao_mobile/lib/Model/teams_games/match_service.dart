// services/match_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';


class MatchService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all matches
  Stream<List<WaoMatch>> getAllMatches() {
    return _db
        .collection('matches')
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // Fetch matches by status - OPTIMIZED VERSION
  // This version fetches by status only, then sorts in-memory to avoid composite index
  Stream<List<WaoMatch>> getMatchesByStatus(MatchStatus status) {
    return _db
        .collection('matches')
        .where('status', isEqualTo: status.name)
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      // Sort in-memory instead of using orderBy in Firestore
      // This avoids the need for a composite index
      if (status == MatchStatus.finished) {
        matches.sort((a, b) => b.startTime.compareTo(a.startTime)); // descending
      } else {
        matches.sort((a, b) => a.startTime.compareTo(b.startTime)); // ascending
      }

      return matches;
    });
  }

  // Fetch live matches
  Stream<List<WaoMatch>> getLiveMatches() {
    return getMatchesByStatus(MatchStatus.live);
  }

  // Fetch upcoming matches
  Stream<List<WaoMatch>> getUpcomingMatches() {
    return getMatchesByStatus(MatchStatus.upcoming);
  }

  // Fetch finished matches
  Stream<List<WaoMatch>> getFinishedMatches() {
    return getMatchesByStatus(MatchStatus.finished);
  }

  // Fetch matches by type - OPTIMIZED VERSION
  Stream<List<WaoMatch>> getMatchesByType(MatchType type) {
    return _db
        .collection('matches')
        .where('type', isEqualTo: type.name)
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      // Sort in-memory
      matches.sort((a, b) => b.startTime.compareTo(a.startTime));
      return matches;
    });
  }

  // Fetch matches for a specific team
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

  // Fetch matches for a specific championship
  Stream<List<WaoMatch>> getChampionshipMatches(String championshipId) {
    return _db
        .collection('matches')
        .where('championshipId', isEqualTo: championshipId)
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      // Sort in-memory
      matches.sort((a, b) => a.startTime.compareTo(b.startTime));
      return matches;
    });
  }

  // Create a new match
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
        'venue': venue,
        'championshipId': championshipId,
      }).timeout(const Duration(seconds: 5));

      return docRef.id;
    } catch (e) {
      print('Error creating match: $e');
      rethrow;
    }
  }

  // Update match score
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

  // Update match status
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

  // Start a match (set to live)
  Future<void> startMatch(String matchId) async {
    await updateMatchStatus(matchId, MatchStatus.live);
  }

  // End a match (set to finished)
  Future<void> endMatch(String matchId) async {
    await updateMatchStatus(matchId, MatchStatus.finished);
  }

  // Delete a match
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

  // Seed sample matches - 3 LIVE MATCHES
  Future<void> seedMatches() async {
    final now = DateTime.now();

    final List<Map<String, dynamic>> sampleMatches = [
      // === 3 LIVE MATCHES ===
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
        'venue': 'WaoSphere',
        'championshipId': null,
      },

      // === FINISHED MATCHES ===
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
        'venue': 'KNUST Sports Stadium',
        'championshipId': null,
      },

      // === UPCOMING MATCHES ===
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
        'venue': 'WaoSphere',
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
      print('✅ Matches seeded successfully');
    } catch (e) {
      print('❌ Error seeding matches: $e');
      rethrow;
    }
  }

  // Get team statistics
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

  // Check if matches collection is empty
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