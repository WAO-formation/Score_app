import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';

class TeamService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<WaoTeam>> getTeamsByCategory(TeamCategory category) {
    return _firestore
        .collection('teams')
        .where('category', isEqualTo: category.name)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Stream<List<WaoTeam>> getTeamsByCampus(String campusId) {
    return _firestore
        .collection('teams')
        .where('campusId', isEqualTo: campusId)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Stream<List<WaoTeam>> getAllTeams() {
    return _firestore
        .collection('teams')
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  Stream<List<WaoTeam>> getTopTeams({int limit = 5}) {
    return _firestore
        .collection('teams')
        .where('ranking', isGreaterThan: 0)  // Simpler query
        .orderBy('ranking', descending: false)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }


  Future<WaoTeam?> getTeamById(String teamId) async {
    try {
      final doc = await _firestore.collection('teams').doc(teamId).get();
      if (doc.exists && doc.data() != null) {
        return WaoTeam.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching team: $e');
      rethrow;
    }
  }

  Future<String> createTeam(WaoTeam team) async {
    try {
      final docRef = _firestore.collection('teams').doc();
      final teamId = docRef.id;

      await docRef.set(team.copyWith(id: teamId).toFirestore());

      return teamId;
    } catch (e) {
      print('Error creating team: $e');
      rethrow;
    }
  }

  Future<void> updateTeam(String teamId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('teams').doc(teamId).update(updates);
    } catch (e) {
      print('Error updating team: $e');
      rethrow;
    }
  }

  // Follow a team
  Future<void> followTeam(String userId, String teamId) async {
    try {
      final followDoc = _firestore
          .collection('users')
          .doc(userId)
          .collection('followedTeams')
          .doc(teamId);

      await followDoc.set({
        'teamId': teamId,
        'followedAt': FieldValue.serverTimestamp(),
      });

      print('Successfully followed team: $teamId');
    } catch (e) {
      print('Error following team: $e');
      rethrow;
    }
  }

  // Unfollow a team
  Future<void> unfollowTeam(String userId, String teamId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('followedTeams')
          .doc(teamId)
          .delete();

      print('Successfully unfollowed team: $teamId');
    } catch (e) {
      print('Error unfollowing team: $e');
      rethrow;
    }
  }

  // Check if user is following a specific team
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

  // Get all teams followed by user
  Stream<List<String>> getFollowedTeamIds(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('followedTeams')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Get count of followers for a team
  Future<int> getTeamFollowerCount(String teamId) async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('followedTeams')
          .where('teamId', isEqualTo: teamId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      print('Error getting follower count: $e');
      return 0;
    }
  }

  // Toggle follow status
  Future<bool> toggleFollowTeam(String userId, String teamId) async {
    try {
      final isFollowing = await isFollowingTeam(userId, teamId);

      if (isFollowing) {
        await unfollowTeam(userId, teamId);
        return false; // Now not following
      } else {
        await followTeam(userId, teamId);
        return true; // Now following
      }
    } catch (e) {
      print('Error toggling follow status: $e');
      rethrow;
    }
  }

  Future<void> deleteTeam(String teamId) async {
    try {
      await _firestore.collection('teams').doc(teamId).delete();
    } catch (e) {
      print('Error deleting team: $e');
      rethrow;
    }
  }

  Future<void> seedWaoTeams() async {
    final List<WaoTeam> initialTeams = [
      WaoTeam(
        id: 'ug_warriors',
        name: 'UG Warriors',
        category: TeamCategory.campus,
        campusId: 'ug_legon',
        coach: 'Daniel Addae',
        secretary: 'Daniel Addae',
        director: 'Kyei Solomon',
        squadSize: 15,
        logoUrl: '',
        isTopTeam: true,
        ranking: 1,
      ),
      WaoTeam(
        id: 'knust_stars',
        name: 'KNUST Stars',
        category: TeamCategory.campus,
        campusId: 'knust_kumasi',
        coach: 'Samuel B Arthur',
        secretary: 'Admin',
        director: 'Director B',
        squadSize: 14,
        logoUrl: '',
        isTopTeam: true,
        ranking: 2,
      ),
      WaoTeam(
        id: 'ucc_titans',
        name: 'UCC Titans',
        category: TeamCategory.campus,
        campusId: 'ucc_cape_coast',
        coach: 'Kwame Mensah',
        secretary: 'Grace Asante',
        director: 'Dr. Philip Nortey',
        squadSize: 13,
        logoUrl: '',
        isTopTeam: true,
        ranking: 3,
      ),
      WaoTeam(
        id: 'upsa_eagles',
        name: 'UPSA Eagles',
        category: TeamCategory.campus,
        campusId: 'upsa_accra',
        coach: 'Michael Osei',
        secretary: 'Rebecca Tetteh',
        director: 'Ernest Boateng',
        squadSize: 13,
        logoUrl: '',
        isTopTeam: false,
        ranking: 0,
      ),
      WaoTeam(
        id: 'wao_all_stars',
        name: 'WAO All-Stars',
        category: TeamCategory.general,
        campusId: null,
        coach: 'Joseph Ankrah',
        secretary: 'Elizabeth Owusu',
        director: 'Francis Appiah',
        squadSize: 16,
        logoUrl: '',
        isTopTeam: true,
        ranking: 4,
      ),
      WaoTeam(
        id: 'national_champions',
        name: 'National Champions',
        category: TeamCategory.general,
        campusId: null,
        coach: 'Robert Darko',
        secretary: 'Jennifer Ampofo',
        director: 'George Acquah',
        squadSize: 15,
        logoUrl: '',
        isTopTeam: true,
        ranking: 5,
      ),
      WaoTeam(
        id: 'ug_main_boys',
        name: 'UG Main Boys',
        category: TeamCategory.campus,
        campusId: 'ug_legon',
        coach: 'Emmanuel Quartey',
        secretary: 'Sarah Mensah',
        director: 'Dr. Kwame Nkrumah',
        squadSize: 14,
        logoUrl: '',
        isTopTeam: false,
        ranking: 0,
      ),
      WaoTeam(
        id: 'ashesi_thunder',
        name: 'Ashesi Thunder',
        category: TeamCategory.campus,
        campusId: 'ashesi_berekuso',
        coach: 'Patrick Awuah',
        secretary: 'Nana Ama Owusu',
        director: 'Prof. Angela Brooks',
        squadSize: 12,
        logoUrl: '',
        isTopTeam: false,
        ranking: 0,
      ),
      WaoTeam(
        id: 'gimpa_lions',
        name: 'GIMPA Lions',
        category: TeamCategory.campus,
        campusId: 'gimpa_accra',
        coach: 'Collins Owusu',
        secretary: 'Victoria Mensah',
        director: 'Dr. Ernest Aryeetey',
        squadSize: 13,
        logoUrl: '',
        isTopTeam: false,
        ranking: 0,
      ),
      WaoTeam(
        id: 'legon_legends',
        name: 'Legon Legends',
        category: TeamCategory.general,
        campusId: null,
        coach: 'Yaw Preko',
        secretary: 'Abena Serwaa',
        director: 'Kofi Mensah',
        squadSize: 15,
        logoUrl: '',
        isTopTeam: false,
        ranking: 0,
      ),
    ];

    try {
      final batch = _firestore.batch();

      for (var team in initialTeams) {
        final docRef = _firestore.collection('teams').doc(team.id);
        batch.set(docRef, team.toFirestore());
      }

      await batch.commit();
      print('${initialTeams.length} teams seeded successfully');
    } catch (e) {
      print('Error seeding teams: $e');
      rethrow;
    }
  }

  Future<bool> isTeamsEmpty() async {
    try {
      final snapshot = await _firestore.collection('teams').limit(1).get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking teams: $e');
      return true;
    }
  }

  Future<void> clearAllTeams() async {
    try {
      final snapshot = await _firestore.collection('teams').get();
      final batch = _firestore.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('All teams cleared successfully');
    } catch (e) {
      print('Error clearing teams: $e');
      rethrow;
    }
  }
}