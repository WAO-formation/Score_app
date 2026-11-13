import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';

WaoMatch _buildMatch({String status = 'upcoming', Map<String, dynamic> overrides = const {}}) {
  final data = {
    'teamAId': 'team-a',
    'teamBId': 'team-b',
    'teamAName': 'Team A',
    'teamBName': 'Team B',
    'scoreA': 0,
    'scoreB': 0,
    'status': status,
    'type': 'friendly',
    'startTime': Timestamp.fromDate(DateTime(2026, 1, 1)),
    'venue': 'Test Arena',
    ...overrides,
  };
  return WaoMatch.fromFirestore(data, 'match-1');
}

void main() {
  group('MatchStatus parsing', () {
    test('parses every value in the extended enum, including the newer ones', () {
      for (final status in ['upcoming', 'live', 'finished', 'postponed', 'suspended', 'cancelled']) {
        final match = _buildMatch(status: status);
        expect(match.status.name, status, reason: 'status "$status" should round-trip');
      }
    });

    test('defaults to upcoming when status is missing', () {
      final match = WaoMatch.fromFirestore({
        'teamAId': 'a', 'teamBId': 'b', 'teamAName': 'A', 'teamBName': 'B',
        'startTime': Timestamp.fromDate(DateTime(2026, 1, 1)), 'venue': 'V',
      }, 'm2');
      expect(match.status, MatchStatus.upcoming);
    });
  });

  group('WaoMatch new field round-trip (moderator/judges/live-scoring detail)', () {
    test('toFirestore -> fromFirestore preserves judges, quarters, fouls, events', () {
      final original = WaoMatch(
        id: 'm3',
        teamAId: 'a',
        teamBId: 'b',
        teamAName: 'A',
        teamBName: 'B',
        status: MatchStatus.live,
        type: MatchType.championship,
        startTime: DateTime(2026, 3, 1),
        venue: 'Arena',
        moderatorUid: 'mod-1',
        moderatorName: 'Mod One',
        judges: const [
          {'uid': 'j1', 'name': 'Judge One'},
        ],
        quarters: const {'q1': {'teamA': 10, 'teamB': 5}},
        fouls: const {'teamA': [], 'teamB': []},
        events: const [
          {'type': 'goal', 'teamId': 'a'},
        ],
        currentQuarter: 'Q2',
        timeRemaining: '12:30',
        isPlaying: true,
        championshipName: 'Test Cup',
      );

      final roundTripped = WaoMatch.fromFirestore(original.toFirestore(), original.id);

      expect(roundTripped.moderatorUid, 'mod-1');
      expect(roundTripped.judges, original.judges);
      expect(roundTripped.quarters, original.quarters);
      expect(roundTripped.events, original.events);
      expect(roundTripped.currentQuarter, 'Q2');
      expect(roundTripped.timeRemaining, '12:30');
      expect(roundTripped.isPlaying, isTrue);
      expect(roundTripped.championshipName, 'Test Cup');
    });

    test('all new fields default sensibly when absent from a legacy document', () {
      final match = _buildMatch();

      expect(match.moderatorUid, isNull);
      expect(match.judges, isEmpty);
      expect(match.quarters, isNull);
      expect(match.fouls, isNull);
      expect(match.events, isEmpty);
      expect(match.isPlaying, isFalse);
      expect(match.completedAt, isNull);
    });
  });

  group('WaoMatch.getFinalScores / getWinner', () {
    test('weights kingdom/workout/goalSetting at 30% each and judges at 10%', () {
      final match = _buildMatch(status: 'finished', overrides: {
        'teamAKingdom': 100, 'teamBKingdom': 0,
        'teamAWorkout': 100, 'teamBWorkout': 0,
        'teamAGoalSetting': 100, 'teamBGoalSetting': 0,
        'teamAJudges': 100, 'teamBJudges': 0,
      });

      final scores = match.getFinalScores();
      expect(scores['teamA'], 100.0);
      expect(scores['teamB'], 0.0);
      expect(match.getWinner(), 'Team A');
    });

    test('an even split across every category is a draw', () {
      final match = _buildMatch(status: 'finished', overrides: {
        'teamAKingdom': 50, 'teamBKingdom': 50,
        'teamAWorkout': 50, 'teamBWorkout': 50,
        'teamAGoalSetting': 50, 'teamBGoalSetting': 50,
        'teamAJudges': 50, 'teamBJudges': 50,
      });

      expect(match.getWinner(), 'Draw');
    });

    test('getWinner returns null for a match that has not finished', () {
      final match = _buildMatch(status: 'live');
      expect(match.getWinner(), isNull);
    });

    test('a category with zero total on both sides contributes 0%, not NaN or a crash', () {
      final match = _buildMatch(status: 'finished');
      final scores = match.getFinalScores();
      expect(scores['teamA'], 0.0);
      expect(scores['teamB'], 0.0);
    });
  });
}
