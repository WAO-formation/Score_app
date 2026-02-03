// wao_championship.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum ChampionshipScope { general, campusRestricted }

class WaoChampionship {
  final String id;
  final String name;
  final ChampionshipScope scope;
  final List<String> targetCampusIds;
  final DateTime createdAt;

  WaoChampionship({
    required this.id,
    required this.name,
    required this.scope,
    this.targetCampusIds = const [],
    required this.createdAt,
  });

  factory WaoChampionship.fromFirestore(Map<String, dynamic> data, String id) {
    return WaoChampionship(
      id: id,
      name: data['name'] ?? '',
      scope: ChampionshipScope.values.byName(data['scope']),
      targetCampusIds: List<String>.from(data['targetCampusIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'scope': scope.name,
      'targetCampusIds': targetCampusIds,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}