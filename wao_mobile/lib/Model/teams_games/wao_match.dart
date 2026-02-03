// wao_match.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum MatchStatus { live, upcoming, finished }
enum MatchType { friendly, championship, campusInternal }

class WaoMatch {
  final String id;
  final String teamAId;
  final String teamBId;
  final String teamAName;
  final String teamBName;
  final int scoreA;
  final int scoreB;
  final MatchStatus status;
  final MatchType type;
  final DateTime startTime;
  final String venue;
  final String? championshipId;

  WaoMatch({
    required this.id,
    required this.teamAId,
    required this.teamBId,
    required this.teamAName,
    required this.teamBName,
    this.scoreA = 0,
    this.scoreB = 0,
    required this.status,
    required this.type,
    required this.startTime,
    required this.venue,
    this.championshipId,
  });

  // Factory to convert Firestore Map to Dart Object
  factory WaoMatch.fromFirestore(Map<String, dynamic> data, String id) {
    return WaoMatch(
      id: id,
      teamAId: data['teamAId'] ?? '',
      teamBId: data['teamBId'] ?? '',
      teamAName: data['teamAName'] ?? '',
      teamBName: data['teamBName'] ?? '',
      scoreA: data['scoreA'] ?? 0,
      scoreB: data['scoreB'] ?? 0,
      status: MatchStatus.values.byName(data['status'] ?? 'upcoming'),
      type: MatchType.values.byName(data['type'] ?? 'friendly'),
      startTime: (data['startTime'] as Timestamp).toDate(),
      venue: data['venue'] ?? 'WaoSphere',
      championshipId: data['championshipId'],
    );
  }

  // Convert Model to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'teamAId': teamAId,
      'teamBId': teamBId,
      'teamAName': teamAName,
      'teamBName': teamBName,
      'scoreA': scoreA,
      'scoreB': scoreB,
      'status': status.name,
      'type': type.name,
      'startTime': Timestamp.fromDate(startTime),
      'venue': venue,
      'championshipId': championshipId,
    };
  }

  // Helper method to get winner
  String? getWinner() {
    if (status != MatchStatus.finished) return null;
    if (scoreA > scoreB) return teamAName;
    if (scoreB > scoreA) return teamBName;
    return 'Draw';
  }

  // Create a copy with updated fields
  WaoMatch copyWith({
    String? id,
    String? teamAId,
    String? teamBId,
    String? teamAName,
    String? teamBName,
    int? scoreA,
    int? scoreB,
    MatchStatus? status,
    MatchType? type,
    DateTime? startTime,
    String? venue,
    String? championshipId,
  }) {
    return WaoMatch(
      id: id ?? this.id,
      teamAId: teamAId ?? this.teamAId,
      teamBId: teamBId ?? this.teamBId,
      teamAName: teamAName ?? this.teamAName,
      teamBName: teamBName ?? this.teamBName,
      scoreA: scoreA ?? this.scoreA,
      scoreB: scoreB ?? this.scoreB,
      status: status ?? this.status,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      venue: venue ?? this.venue,
      championshipId: championshipId ?? this.championshipId,
    );
  }
}