
// models/team_model.dart
import 'dart:ui';

class TeamModel {
  final int id;
  final String name;
  final String logo;
  final String? password;
  final String? email;
  final String? ownerName;
  final String? phone;

  TeamModel({
    required this.id,
    required this.name,
    required this.logo,
    this.ownerName,
    this.email,
    this.phone,
    this.password,
  });
}

// models/referee_model.dart
class RefereeModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final Color color;

  RefereeModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.color,
  });
}

// models/judge_model.dart
class JudgeModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;

  JudgeModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });
}
