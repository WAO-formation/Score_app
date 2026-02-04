import 'package:cloud_firestore/cloud_firestore.dart';

enum TeamCategory { general, campus }

class WaoTeam {
  final String id;
  final String name;
  final TeamCategory category;
  final String? campusId;
  final String coach;
  final String secretary;
  final String director;
  final int squadSize;
  final String logoUrl;
  final bool isTopTeam;        // NEW: Mark as top team
  final int ranking;           // NEW: For ordering top teams
  final DateTime? createdAt;   // NEW: Useful for sorting

  WaoTeam({
    required this.id,
    required this.name,
    required this.category,
    this.campusId,
    required this.coach,
    required this.secretary,
    required this.director,
    this.squadSize = 13,
    required this.logoUrl,
    this.isTopTeam = false,    // Default to false
    this.ranking = 0,          // Default ranking
    this.createdAt,
  });

  // Convert Firestore Document to Model
  factory WaoTeam.fromFirestore(Map<String, dynamic> data, String id) {
    return WaoTeam(
      id: id,
      name: data['name'] ?? '',
      category: TeamCategory.values.byName(data['category'] ?? 'general'),
      campusId: data['campusId'],
      coach: data['coach'] ?? 'Unknown Coach',
      secretary: data['secretary'] ?? '',
      director: data['director'] ?? '',
      squadSize: data['squadSize'] ?? 13,
      logoUrl: data['logoUrl'] ?? '',
      isTopTeam: data['isTopTeam'] ?? false,
      ranking: data['ranking'] ?? 0,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert Model to Map for Firestore upload
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category.name,
      'campusId': campusId,
      'coach': coach,
      'secretary': secretary,
      'director': director,
      'squadSize': squadSize,
      'logoUrl': logoUrl,
      'isTopTeam': isTopTeam,
      'ranking': ranking,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Helper method to create a copy with updated fields
  WaoTeam copyWith({
    String? id,
    String? name,
    TeamCategory? category,
    String? campusId,
    String? coach,
    String? secretary,
    String? director,
    int? squadSize,
    String? logoUrl,
    bool? isTopTeam,
    int? ranking,
    DateTime? createdAt,
  }) {
    return WaoTeam(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      campusId: campusId ?? this.campusId,
      coach: coach ?? this.coach,
      secretary: secretary ?? this.secretary,
      director: director ?? this.director,
      squadSize: squadSize ?? this.squadSize,
      logoUrl: logoUrl ?? this.logoUrl,
      isTopTeam: isTopTeam ?? this.isTopTeam,
      ranking: ranking ?? this.ranking,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}