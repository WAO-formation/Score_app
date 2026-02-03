// services/team_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';


class TeamService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all teams under a specific category (General or Campus)
  Stream<List<WaoTeam>> getTeamsByCategory(TeamCategory category) {
    return _db
        .collection('teams')
        .where('category', isEqualTo: category.name)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // Fetch teams belonging to a specific campus
  Stream<List<WaoTeam>> getTeamsByCampus(String campusId) {
    return _db
        .collection('teams')
        .where('campusId', isEqualTo: campusId)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // Fetch all teams
  Stream<List<WaoTeam>> getAllTeams() {
    return _db
        .collection('teams')
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // Get a single team by ID
  Future<WaoTeam?> getTeamById(String teamId) async {
    try {
      final doc = await _db.collection('teams').doc(teamId).get();
      if (doc.exists && doc.data() != null) {
        return WaoTeam.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching team: $e');
      rethrow;
    }
  }

  // Create a new team
  Future<String> createTeam(WaoTeam team) async {
    try {
      final docRef = await _db
          .collection('teams')
          .doc(team.id)
          .set(team.toFirestore())
          .timeout(const Duration(seconds: 5));

      return team.id;
    } catch (e) {
      print('Error creating team: $e');
      rethrow;
    }
  }

  // Update a team
  Future<void> updateTeam(String teamId, Map<String, dynamic> updates) async {
    try {
      await _db
          .collection('teams')
          .doc(teamId)
          .update(updates)
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error updating team: $e');
      rethrow;
    }
  }

  // Delete a team
  Future<void> deleteTeam(String teamId) async {
    try {
      await _db
          .collection('teams')
          .doc(teamId)
          .delete()
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print('Error deleting team: $e');
      rethrow;
    }
  }

  // SEEDING: Creating the 6 teams
  Future<void> seedWaoTeams() async {
    final List<WaoTeam> initialTeams = [
      // Campus Teams
      WaoTeam(
        id: 'ug_warriors',
        name: 'UG Warriors',
        category: TeamCategory.campus,
        campusId: 'ug_legon',
        coach: 'Daniel Addae',
        secretary: 'Daniel Addae',
        director: 'Kyei Solomon',
        logoUrl: 'assets/logos/ug.png',
      ),
      WaoTeam(
        id: 'knust_stars',
        name: 'KNUST Stars',
        category: TeamCategory.campus,
        campusId: 'knust_kumasi',
        coach: 'Samuel B Arthur',
        secretary: 'Admin',
        director: 'Director B',
        logoUrl: 'assets/logos/knust.png',
      ),
      WaoTeam(
        id: 'ucc_titans',
        name: 'UCC Titans',
        category: TeamCategory.campus,
        campusId: 'ucc_cape_coast',
        coach: 'Kwame Mensah',
        secretary: 'Grace Asante',
        director: 'Dr. Philip Nortey',
        logoUrl: 'assets/logos/ucc.png',
      ),
      WaoTeam(
        id: 'upsa_eagles',
        name: 'UPSA Eagles',
        category: TeamCategory.campus,
        campusId: 'upsa_accra',
        coach: 'Michael Osei',
        secretary: 'Rebecca Tetteh',
        director: 'Ernest Boateng',
        logoUrl: 'assets/logos/upsa.png',
      ),
      // General Teams
      WaoTeam(
        id: 'wao_all_stars',
        name: 'WAO All-Stars',
        category: TeamCategory.general,
        campusId: null,
        coach: 'Joseph Ankrah',
        secretary: 'Elizabeth Owusu',
        director: 'Francis Appiah',
        logoUrl: 'assets/logos/all_stars.png',
      ),
      WaoTeam(
        id: 'national_champions',
        name: 'National Champions',
        category: TeamCategory.general,
        campusId: null,
        coach: 'Robert Darko',
        secretary: 'Jennifer Ampofo',
        director: 'George Acquah',
        logoUrl: 'assets/logos/champions.png',
      ),
    ];

    try {
      for (var team in initialTeams) {
        await _db
            .collection('teams')
            .doc(team.id)
            .set(team.toFirestore())
            .timeout(const Duration(seconds: 5));
      }
      print('Teams seeded successfully');
    } catch (e) {
      print('Error seeding teams: $e');
      rethrow;
    }
  }

  // Check if teams collection is empty
  Future<bool> isTeamsEmpty() async {
    try {
      final snapshot = await _db.collection('teams').limit(1).get();
      return snapshot.docs.isEmpty;
    } catch (e) {
      print('Error checking teams: $e');
      return true;
    }
  }
}