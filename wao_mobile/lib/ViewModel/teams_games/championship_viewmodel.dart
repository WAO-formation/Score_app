// championship_viewmodel.dart (Updated)
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Model/teams_games/wao_championship.dart';
import '../../Model/teams_games/wao_team.dart';

class ChampionshipViewModel extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all championships
  Stream<List<WaoChampionship>> getAllChampionships() {
    return _db
        .collection('championships')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => WaoChampionship.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // Create a new championship/league
  Future<String> createLeague({
    required String name,
    required ChampionshipScope scope,
    List<String> selectedCampusIds = const [],
  }) async {
    final docRef = await _db.collection('championships').add({
      'name': name,
      'scope': scope.name,
      'targetCampusIds': selectedCampusIds,
      'createdAt': Timestamp.now(),
    });

    notifyListeners();
    return docRef.id;
  }

  // Get eligible teams for a championship
  Stream<List<WaoTeam>> getEligibleTeams(WaoChampionship championship) {
    if (championship.scope == ChampionshipScope.general) {
      return _db.collection('teams').snapshots().map((snap) => snap.docs
          .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
          .toList());
    } else {
      return _db
          .collection('teams')
          .where('campusId', whereIn: championship.targetCampusIds)
          .snapshots()
          .map((snap) => snap.docs
          .map((doc) => WaoTeam.fromFirestore(doc.data(), doc.id))
          .toList());
    }
  }

  // Delete a championship
  Future<void> deleteChampionship(String championshipId) async {
    await _db.collection('championships').doc(championshipId).delete();
    notifyListeners();
  }
}