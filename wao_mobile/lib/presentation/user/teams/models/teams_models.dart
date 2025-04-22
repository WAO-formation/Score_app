class Team {
  final String id;
  final String name;
  final String? logoUrl;
  final String? description;
  final List<String> players;
  final String? coach;
  final String? location;

  Team({
    required this.id,
    required this.name,
    this.logoUrl,
    this.description,
    this.players = const [],
    this.coach,
    this.location,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      logoUrl: json['logoUrl'],
      description: json['description'],
      players: List<String>.from(json['players'] ?? []),
      coach: json['coach'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'description': description,
      'players': players,
      'coach': coach,
      'location': location,
    };
  }
}