import 'package:cloud_firestore/cloud_firestore.dart';

/// "Follow a team" — a plain fan action, distinct from a coach/admin
/// managing a team's roster (TeamService) or its stats (TeamStatisticsService).
/// Split out of the former do-everything TeamService; see
/// MOBILE_ARCHITECTURE_REVIEW.md finding #6.
///
/// Bug fixed while splitting this out: followTeam()/unfollowTeam() only ever
/// wrote users/{uid}/followedTeams/{teamId} (the doc a user's own "which
/// teams do I follow" query reads). getTeamFollowerCount() counted a
/// *different* collection — teams/{teamId}/followers/{userId} — that
/// nothing ever wrote to, so every team's follower count was permanently
/// stuck at 0 despite firestore.rules already having a write rule for that
/// exact path (teams/{teamId}/followers/{userId}: isOwner-only). Both
/// documents are now written/deleted together in one batch.
class TeamFollowService {
  TeamFollowService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<void> followTeam(String userId, String teamId) async {
    try {
      final batch = _firestore.batch();
      batch.set(
        _firestore.collection('users').doc(userId).collection('followedTeams').doc(teamId),
        {'teamId': teamId, 'followedAt': FieldValue.serverTimestamp()},
      );
      batch.set(
        _firestore.collection('teams').doc(teamId).collection('followers').doc(userId),
        {'followedAt': FieldValue.serverTimestamp()},
      );
      await batch.commit();

      await updateFollowerCount(teamId);
    } catch (e) {
      print('Error following team: $e');
      rethrow;
    }
  }

  Future<void> unfollowTeam(String userId, String teamId) async {
    try {
      final batch = _firestore.batch();
      batch.delete(_firestore.collection('users').doc(userId).collection('followedTeams').doc(teamId));
      batch.delete(_firestore.collection('teams').doc(teamId).collection('followers').doc(userId));
      await batch.commit();

      await updateFollowerCount(teamId);
    } catch (e) {
      print('Error unfollowing team: $e');
      rethrow;
    }
  }

  Future<bool> isFollowingTeam(String userId, String teamId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('followedTeams')
          .doc(teamId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error checking follow status: $e');
      return false;
    }
  }

  Stream<List<String>> getFollowedTeamIds(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('followedTeams')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Future<int> getTeamFollowerCount(String teamId) async {
    try {
      final querySnapshot = await _firestore
          .collection('teams')
          .doc(teamId)
          .collection('followers')
          .get();
      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting follower count: $e');
      return 0;
    }
  }

  /// Denormalizes the follower count onto teamStatistics.totalFollowers so
  /// a team's stats card can read it without a subcollection count query.
  Future<void> updateFollowerCount(String teamId) async {
    try {
      final count = await getTeamFollowerCount(teamId);
      await _firestore.collection('teamStatistics').doc(teamId).update({
        'totalFollowers': count,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating follower count: $e');
    }
  }

  Future<bool> toggleFollowTeam(String userId, String teamId) async {
    try {
      final isFollowing = await isFollowingTeam(userId, teamId);
      if (isFollowing) {
        await unfollowTeam(userId, teamId);
        return false;
      } else {
        await followTeam(userId, teamId);
        return true;
      }
    } catch (e) {
      print('Error toggling follow status: $e');
      rethrow;
    }
  }
}
