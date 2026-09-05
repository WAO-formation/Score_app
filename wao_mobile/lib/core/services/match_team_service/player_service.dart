import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Model/teams_games/team/wao_player.dart';

class PlayerService {
  // Accepts an injected Firestore instance (e.g. a fake for unit tests);
  // defaults to the real app instance so existing call sites (`PlayerService()`)
  // don't need to change.
  PlayerService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // Create a new player
  Future<String> createPlayer(WaoPlayer player) async {
    try {
      final docRef = _firestore.collection('players').doc();
      final playerId = docRef.id;

      await docRef.set(player.copyWith(id: playerId).toFirestore());
      return playerId;
    } catch (e) {
      print('Error creating player: $e');
      rethrow;
    }
  }

  // Get player by ID
  Future<WaoPlayer?> getPlayerById(String playerId) async {
    try {
      final doc = await _firestore.collection('players').doc(playerId).get();
      if (doc.exists && doc.data() != null) {
        return WaoPlayer.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching player: $e');
      rethrow;
    }
  }

  // Get a player by their account email (players aren't linked to a Firebase
  // Auth uid directly — email is the join key between users/ and players/).
  Future<WaoPlayer?> getPlayerByEmail(String email) async {
    try {
      final snap = await _firestore
          .collection('players')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (snap.docs.isEmpty) return null;
      return WaoPlayer.fromFirestore(snap.docs.first.data(), snap.docs.first.id);
    } catch (e) {
      print('Error fetching player by email: $e');
      return null;
    }
  }

  // Get players by team
  Stream<List<WaoPlayer>> getPlayersByTeam(String teamId) {
    return _firestore
        .collection('players')
        .where('currentTeamId', isEqualTo: teamId)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((doc) => WaoPlayer.fromFirestore(doc.data(), doc.id))
          .toList(),
    );
  }

  // Get available players (not in any team). Safety cap, not true
  // pagination — see MOBILE_ARCHITECTURE_REVIEW.md finding #1: this scans
  // every unassigned player platform-wide, unbounded before this.
  static const _availablePlayersLimit = 200;
  Stream<List<WaoPlayer>> getAvailablePlayers() {
    return _firestore
        .collection('players')
        .where('currentTeamId', isEqualTo: null)
        .limit(_availablePlayersLimit)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => WaoPlayer.fromFirestore(doc.data(), doc.id))
            .where((p) => p.status == PlayerStatus.active)
            .toList());
  }

  // Check if player is in a team
  Future<bool> isPlayerInTeam(String playerId) async {
    try {
      final player = await getPlayerById(playerId);
      return player?.currentTeamId != null;
    } catch (e) {
      print('Error checking player team status: $e');
      return false;
    }
  }

  // Assign player to team - ensures one team at a time
  Future<void> assignPlayerToTeam({
    required String playerId,
    required String teamId,
    required String teamName,
  }) async {
    try {
      await _firestore.collection('players').doc(playerId).update({
        'currentTeamId': teamId,
        'currentTeamName': teamName,
        'joinedTeamAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error assigning player to team: $e');
      rethrow;
    }
  }

  // Remove player from team
  Future<void> removePlayerFromTeam(String playerId) async {
    try {
      await _firestore.collection('players').doc(playerId).update({
        'currentTeamId': null,
        'currentTeamName': null,
        'joinedTeamAt': null,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print('Player $playerId removed from team');
    } catch (e) {
      print('Error removing player from team: $e');
      rethrow;
    }
  }

  // Update player status
  Future<void> updatePlayerStatus(String playerId, PlayerStatus status) async {
    try {
      await _firestore.collection('players').doc(playerId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating player status: $e');
      rethrow;
    }
  }

  // Update player role
  Future<void> updatePlayerRole(String playerId, PlayerRole role) async {
    try {
      await _firestore.collection('players').doc(playerId).update({
        'role': role.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating player role: $e');
      rethrow;
    }
  }

  // Update player statistics
  Future<void> updatePlayerStats({
    required String playerId,
    int? gamesPlayed,
    int? goalsScored,
    int? assists,
  }) async {
    try {
      Map<String, dynamic> updates = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (gamesPlayed != null) {
        updates['gamesPlayed'] = FieldValue.increment(gamesPlayed);
      }
      if (goalsScored != null) {
        updates['goalsScored'] = FieldValue.increment(goalsScored);
      }
      if (assists != null) {
        updates['assists'] = FieldValue.increment(assists);
      }

      await _firestore.collection('players').doc(playerId).update(updates);
    } catch (e) {
      print('Error updating player stats: $e');
      rethrow;
    }
  }

  // Delete player
  Future<void> deletePlayer(String playerId) async {
    try {
      // Check if player is in a team
      final isInTeam = await isPlayerInTeam(playerId);
      if (isInTeam) {
        throw Exception('Cannot delete player who is currently in a team. Remove them first.');
      }

      await _firestore.collection('players').doc(playerId).delete();
    } catch (e) {
      print('Error deleting player: $e');
      rethrow;
    }
  }

  // Get active players count for a team. Filters status server-side
  // (rather than fetching every player on the team and filtering in Dart)
  // so this stays a single, cheap query as rosters grow.
  Future<int> getActivePlayersCount(String teamId) async {
    try {
      final snapshot = await _firestore
          .collection('players')
          .where('currentTeamId', isEqualTo: teamId)
          .where('status', isEqualTo: PlayerStatus.active.name)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting active players count: $e');
      return 0;
    }
  }

  // Get inactive players count for a team (inactive + suspended).
  Future<int> getInactivePlayersCount(String teamId) async {
    try {
      final snapshot = await _firestore
          .collection('players')
          .where('currentTeamId', isEqualTo: teamId)
          .where('status', whereIn: [PlayerStatus.inactive.name, PlayerStatus.suspended.name])
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting inactive players count: $e');
      return 0;
    }
  }
}