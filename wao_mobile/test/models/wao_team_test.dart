import 'package:flutter_test/flutter_test.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';

void main() {
  group('WaoTeam.fromFirestore tolerates an unresolved FieldValue.serverTimestamp() sentinel', () {
    test('toFirestore() with no updatedAt round-trips to null instead of crashing (MOBILE_ARCHITECTURE_REVIEW.md finding #9)', () {
      final team = WaoTeam(
        id: 't5', name: 'Sentinel FC', category: TeamCategory.senior,
        coach: 'C', secretary: 'S', director: 'D', logoUrl: '',
        createdAt: DateTime(2026, 1, 1),
        // updatedAt intentionally omitted.
      );
      final roundTripped = WaoTeam.fromFirestore(team.toFirestore(), team.id);
      expect(roundTripped.updatedAt, isNull);
      expect(roundTripped.name, 'Sentinel FC');
    });
  });

  group('TeamRoster', () {
    test('totalPlayers and getAllPlayerIds cover all 8 role buckets', () {
      final roster = TeamRoster(
        kingIds: ['k1'],
        workerIds: ['w1', 'w2'],
        protagueIds: ['pr1'],
        antagueIds: ['a1'],
        warriorIds: ['wa1'],
        sacrificerIds: ['s1'],
        servitorIds: ['sv1'],
        substituteIds: ['su1', 'su2'],
      );

      expect(roster.totalPlayers, 10);
      expect(roster.getAllPlayerIds(), containsAll(['k1', 'w1', 'w2', 'pr1', 'a1', 'wa1', 's1', 'sv1', 'su1', 'su2']));
      expect(roster.getAllPlayerIds().length, 10);
    });

    test('fromFirestore/toFirestore round-trips every id list, including new servitor/substitute', () {
      final roster = TeamRoster(
        kingIds: ['k1'],
        servitorIds: ['sv1', 'sv2'],
        substituteIds: ['su1'],
      );

      final roundTripped = TeamRoster.fromFirestore(roster.toFirestore());

      expect(roundTripped.kingIds, roster.kingIds);
      expect(roundTripped.servitorIds, roster.servitorIds);
      expect(roundTripped.substituteIds, roster.substituteIds);
      expect(roundTripped.totalPlayers, roster.totalPlayers);
    });

    test('an empty roster defaults every list to empty, not null', () {
      final roster = TeamRoster.fromFirestore({});
      expect(roster.totalPlayers, 0);
      expect(roster.getAllPlayerIds(), isEmpty);
    });
  });

  group('WaoTeam.fromFirestore category fallback', () {
    test('parses a valid senior/junior/youth category', () {
      final team = WaoTeam.fromFirestore({
        'name': 'Test FC',
        'category': 'junior',
        'coach': 'Coach A',
        'secretary': 'Sec A',
        'director': 'Dir A',
        'logoUrl': '',
      }, 'team-1');

      expect(team.category, TeamCategory.junior);
    });

    test('degrades an unrecognized legacy category (e.g. "campus") to senior instead of throwing', () {
      expect(
        () => WaoTeam.fromFirestore({
          'name': 'Legacy FC',
          'category': 'campus',
          'coach': 'Coach A',
          'secretary': 'Sec A',
          'director': 'Dir A',
          'logoUrl': '',
        }, 'team-2'),
        returnsNormally,
      );

      final team = WaoTeam.fromFirestore({
        'name': 'Legacy FC',
        'category': 'campus',
        'coach': 'Coach A',
        'secretary': 'Sec A',
        'director': 'Dir A',
        'logoUrl': '',
      }, 'team-2');

      expect(team.category, TeamCategory.senior);
    });

    test('missing category also defaults to senior', () {
      final team = WaoTeam.fromFirestore({
        'name': 'No Category FC',
        'coach': 'Coach A',
        'secretary': 'Sec A',
        'director': 'Dir A',
        'logoUrl': '',
      }, 'team-3');

      expect(team.category, TeamCategory.senior);
    });
  });

  group('WaoTeam.canAddPlayers / availableSlots', () {
    test('allows up to the 12-player max squad size', () {
      final fullRoster = TeamRoster(
        kingIds: List.generate(2, (i) => 'k$i'),
        workerIds: List.generate(2, (i) => 'w$i'),
        protagueIds: List.generate(2, (i) => 'pr$i'),
        antagueIds: List.generate(2, (i) => 'a$i'),
        warriorIds: List.generate(2, (i) => 'wa$i'),
        sacrificerIds: List.generate(2, (i) => 's$i'),
      );
      final team = WaoTeam(
        id: 't1',
        name: 'Full FC',
        category: TeamCategory.senior,
        coach: 'C',
        secretary: 'S',
        director: 'D',
        logoUrl: '',
        roster: fullRoster,
        createdAt: DateTime(2026, 1, 1),
      );

      expect(fullRoster.totalPlayers, 12);
      expect(team.canAddPlayers, isFalse);
      expect(team.availableSlots, 0);
    });

    test('an empty-roster team can add players and has 12 slots free', () {
      final team = WaoTeam(
        id: 't2',
        name: 'Empty FC',
        category: TeamCategory.senior,
        coach: 'C',
        secretary: 'S',
        director: 'D',
        logoUrl: '',
        createdAt: DateTime(2026, 1, 1),
      );

      expect(team.canAddPlayers, isTrue);
      expect(team.availableSlots, 12);
    });
  });
}
