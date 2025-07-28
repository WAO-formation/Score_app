enum WAORole {
  King,
  Worker,
  Servitor,
  Warrior,
  Protaque,
  Antaque,
  Sacrificer,
}

enum CoachPlayerStatus {
  Active,
  Substitute,
}

class CoachPlayerModel {
  final String id;
  String name;
  WAORole role;
  CoachPlayerStatus status;
  String? imageUrl;
  Map<String, dynamic> stats;

  CoachPlayerModel({
    required this.id,
    required this.name,
    required this.role,
    required this.status,
    this.imageUrl,
    Map<String, dynamic>? stats,
  }) : stats = stats ?? {};

  // Helper method to get role display name
  String get roleDisplayName {
    return role.toString().split('.').last;
  }

  // Helper method to get status display name
  String get statusDisplayName {
    return status == CoachPlayerStatus.Active ? 'Active' : 'Substitute';
  }

  // Create a copy with updated fields
  CoachPlayerModel copyWith({
    String? name,
    WAORole? role,
    CoachPlayerStatus? status,
    String? imageUrl,
    Map<String, dynamic>? stats,
  }) {
    return CoachPlayerModel(
      id: this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      stats: stats ?? this.stats,
    );
  }
}
