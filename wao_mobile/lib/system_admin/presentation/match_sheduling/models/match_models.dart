// models/match_model.dart
import 'package:flutter/material.dart';

enum MatchStatus { upcoming, inProgress, completed, cancelled }

class MatchModel {
  final int id;
  DateTime date;
  String time;
  LocationModel location;
  final TeamModel team1;
  final TeamModel team2;
  List<RefereeModel> referees;
  List<JudgeModel> judges;
  MatchStatus status;

  MatchModel({
    required this.id,
    required this.date,
    required this.time,
    required this.location,
    required this.team1,
    required this.team2,
    required this.referees,
    required this.judges,
    required this.status,
  });
}


enum GameStatus { upcoming, inProgress, completed, cancelled }

class GameModel {
  final int? id;
  DateTime? date;
  String? time;
  LocationModel? location;
  final TeamModel? team1;
  final TeamModel? team2;
  int? score1;
  int? score2;
  String? elapsedTime;
  List<RefereeModel>? referees;
  List<JudgeModel>? judges;
  MatchStatus? status;
  GamePerformance? gamePerformance;

  GameModel({
    this.id,
    this.date,
    this.time,
    this.location,
    this.team1,
    this.team2,
    this.score1,
    this.score2,
    this.elapsedTime,
    this.referees,
    this.judges,
    this.status,
    this.gamePerformance,
  });
}


class GamePerformance {
  final TeamModel? team1;
  final TeamModel? team2;
  final int? team1Score;
  final int? team2Score;
  final int? team1KingdomPoints;
  final int? team2KingdomPoints;
  final int? team1WorkoutPoints;
  final int? team2WorkoutPoints;
  final int? team1GoalpostPoints;
  final int? team2GoalpostPoints;
  final int? team1JudgePoints;
  final int? team2JudgePoints;
  final List<PlayerEvent>? playerEvents;

  GamePerformance({
    this.team1,
    this.team2,
    this.team1Score,
    this.team2Score,
    this.team1KingdomPoints,
    this.team2KingdomPoints,
    this.team1WorkoutPoints,
    this.team2WorkoutPoints,
    this.team1GoalpostPoints,
    this.team2GoalpostPoints,
    this.team1JudgePoints,
    this.team2JudgePoints,
    this.playerEvents,
  });
}

// Player Event Model (was missing in the original code)
enum EventType { kingdom, workout, goalpost, foul }

class PlayerEvent {
  final int? playerId;
  final String? playerName;
  final int? teamId;
  final EventType? eventType;
  final String? eventDetail;
  final String? timestamp;
  final int? points;

  PlayerEvent({
    this.playerId,
    this.playerName,
    this.teamId,
    this.eventType,
    this.eventDetail,
    this.timestamp,
    this.points,
  });
}

// models/team_model.dart
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


class LocationModel {
  final int id;
  final String name;


  LocationModel({
    required this.id,
    required this.name,

  });
}