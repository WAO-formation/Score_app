import 'package:wao_mobile/presentation/user/teams/models/teams_models.dart';



class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final Team? playerTeam;
  final bool isPlayer;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.playerTeam,
    this.isPlayer = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      playerTeam: json['playerTeam'] != null ? Team.fromJson(json['playerTeam']) : null,
      isPlayer: json['isPlayer'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'playerTeam': playerTeam?.toJson(),
      'isPlayer': isPlayer,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    Team? playerTeam,
    bool? isPlayer,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      playerTeam: playerTeam ?? this.playerTeam,
      isPlayer: isPlayer ?? this.isPlayer,
    );
  }
}