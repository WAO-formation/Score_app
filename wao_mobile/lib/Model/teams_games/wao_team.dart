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
    };
  }
}