// match_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';

class MatchService {
  MatchService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  // Safety caps, not true cursor-based pagination — see
  // MOBILE_ARCHITECTURE_REVIEW.md finding #1. High enough to never
  // practically truncate live/upcoming games (there are only ever a
  // handful at once); `getFinishedMatches` below gets a real ordered+limited
  // query since match history is the one list here that grows unboundedly.
  static const _defensiveLimit = 200;

  // Fetches exactly the given match docs (chunked by 10, Firestore's
  // documentId-`whereIn` cap) instead of downloading the whole collection
  // and filtering client-side — used for a fan's starred-match list, which
  // previously called getAllMatches() for this (MOBILE_ARCHITECTURE_REVIEW.md
  // finding #1).
  Future<List<WaoMatch>> getMatchesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final chunks = <List<String>>[];
    for (var i = 0; i < ids.length; i += 10) {
      chunks.add(ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10));
    }
    final results = await Future.wait(chunks.map(
      (chunk) => _db.collection('matches').where(FieldPath.documentId, whereIn: chunk).get(),
    ));
    return results
        .expand((snap) => snap.docs)
        .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Live updates for a single match — used by the live/upcoming/past detail
  // screens so a score change is reflected while the user is looking at it,
  // instead of the page showing a frozen snapshot from when it was opened.
  Stream<WaoMatch?> getMatchStream(String matchId) {
    return _db.collection('matches').doc(matchId).snapshots().map(
          (doc) => doc.exists && doc.data() != null ? WaoMatch.fromFirestore(doc.data()!, doc.id) : null,
        );
  }

  Stream<List<WaoMatch>> getAllMatches() {
    return _db
        .collection('matches')
        .limit(_defensiveLimit)
        .snapshots()
        .map((snap) {
      final matches = snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();
      matches.sort((a, b) => b.startTime.compareTo(a.startTime));
      return matches;
    });
  }

  Stream<List<WaoMatch>> getMatchesByStatus(MatchStatus status) {
    return _db
        .collection('matches')
        .where('status', isEqualTo: status.name)
        .limit(_defensiveLimit)
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

  // Unlike live/upcoming (naturally small), finished matches accumulate
  // forever — this is the one list that actually needs real pagination
  // rather than just a defensive cap. Ordered + limited server-side
  // (requires the composite index in firestore.indexes.json: status ASC,
  // startTime DESC) so "most recent 100" is correct, not an arbitrary 100.
  Stream<List<WaoMatch>> getFinishedMatches({int limit = 100}) {
    return _db
        .collection('matches')
        .where('status', isEqualTo: MatchStatus.finished.name)
        .orderBy('startTime', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id)).toList());
  }

  // Safety cap, not true pagination — high enough to never truncate a real
  // team's history for years, just a backstop against unbounded growth.
  // (MOBILE_ARCHITECTURE_REVIEW.md finding #1.)
  static const _teamMatchesSafetyLimit = 200;

  Stream<List<WaoMatch>> getTeamMatches(String teamId) {
    return _db
        .collection('matches')
        .where('teamAId', isEqualTo: teamId)
        .limit(_teamMatchesSafetyLimit)
        .snapshots()
        .asyncMap((snapA) async {
      final matchesA = snapA.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      final snapB = await _db
          .collection('matches')
          .where('teamBId', isEqualTo: teamId)
          .limit(_teamMatchesSafetyLimit)
          .get();

      final matchesB = snapB.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .toList();

      final allMatches = [...matchesA, ...matchesB];
      allMatches.sort((a, b) => b.startTime.compareTo(a.startTime));
      return allMatches;
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

  // Get matches for multiple teams (a fan's followed teams). Previously
  // downloaded the *entire* matches collection on every update and filtered
  // client-side — the worst offender found in MOBILE_ARCHITECTURE_REVIEW.md
  // finding #1. Now queries only the relevant teams via `whereIn` (chunked
  // by 10, Firestore's per-query cap): the first chunk drives the live
  // listener, any further chunks (only when a fan follows >10 teams) are
  // merged in via one-time reads alongside each update.
  Stream<List<WaoMatch>> getMatchesForTeams(List<String> teamIds) {
    if (teamIds.isEmpty) {
      return Stream.value([]);
    }

    final chunks = <List<String>>[];
    for (var i = 0; i < teamIds.length; i += 10) {
      chunks.add(teamIds.sublist(i, i + 10 > teamIds.length ? teamIds.length : i + 10));
    }

    Future<List<WaoMatch>> matchesWhereTeamIn(String field, List<String> ids) async {
      final snap = await _db.collection('matches').where(field, whereIn: ids).get();
      return snap.docs.map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id)).toList();
    }

    return _db
        .collection('matches')
        .where('teamAId', whereIn: chunks.first)
        .snapshots()
        .asyncMap((primarySnap) async {
      final results = await Future.wait([
        Future.value(primarySnap.docs.map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id)).toList()),
        matchesWhereTeamIn('teamBId', chunks.first),
        for (final chunk in chunks.skip(1)) matchesWhereTeamIn('teamAId', chunk),
        for (final chunk in chunks.skip(1)) matchesWhereTeamIn('teamBId', chunk),
      ]);

      final byId = <String, WaoMatch>{};
      for (final list in results) {
        for (final match in list) {
          byId[match.id] = match;
        }
      }
      final matches = byId.values.toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
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
        'updatedAt': FieldValue.serverTimestamp(),
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
        'updatedAt': FieldValue.serverTimestamp(),
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
        updates['updatedAt'] = FieldValue.serverTimestamp();
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
          .update({
            'status': status.name,
            'updatedAt': FieldValue.serverTimestamp(),
          })
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
    try {
      await _db.collection('matches').doc(matchId).update({
        'status': MatchStatus.finished.name,
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }).timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error ending match: $e');
      rethrow;
    }
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
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) => WaoMatch.fromFirestore(doc.data(), doc.id))
          .where((m) => m.isFavorite)
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    });
  }

}