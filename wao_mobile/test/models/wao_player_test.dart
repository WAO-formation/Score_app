import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wao_mobile/Model/teams_games/team/wao_player.dart';

void main() {
  group('WaoPlayer.fromFirestore', () {
    test('parses a fully-populated document', () {
      final now = DateTime(2026, 1, 1);
      final player = WaoPlayer.fromFirestore({
        'name': 'Kwame Nkrumah',
        'email': 'kwame@wao.com',
        'role': 'king',
        'status': 'active',
        'currentTeamId': 'ashesi_thunder',
        'currentTeamName': 'Ashesi Thunder',
        'joinedTeamAt': Timestamp.fromDate(now),
        'gamesPlayed': 5,
        'goalsScored': 2,
        'assists': 1,
        'createdAt': Timestamp.fromDate(now),
        'jerseyNumber': 9,
        'age': 22,
      }, 'player-1');

      expect(player.id, 'player-1');
      expect(player.name, 'Kwame Nkrumah');
      expect(player.role, PlayerRole.king);
      expect(player.status, PlayerStatus.active);
      expect(player.currentTeamId, 'ashesi_thunder');
      expect(player.gamesPlayed, 5);
      expect(player.jerseyNumber, 9);
      expect(player.age, 22);
    });

    test('defaults role to worker and status to active when absent', () {
      final player = WaoPlayer.fromFirestore({
        'name': 'No Role',
        'email': 'x@wao.com',
      }, 'p2');

      expect(player.role, PlayerRole.worker);
      expect(player.status, PlayerStatus.active);
      expect(player.currentTeamId, isNull);
      expect(player.jerseyNumber, isNull);
    });

    test('parses the newer servitor and substitute roles', () {
      final servitor = WaoPlayer.fromFirestore({'name': 'S', 'email': 'a@b.com', 'role': 'servitor'}, 'p3');
      final sub = WaoPlayer.fromFirestore({'name': 'Sub', 'email': 'a@b.com', 'role': 'substitute'}, 'p4');

      expect(servitor.role, PlayerRole.servitor);
      expect(sub.role, PlayerRole.substitute);
    });
  });

  group('WaoPlayer.toFirestore round-trip', () {
    test('re-parsing toFirestore output reproduces the same player', () {
      final original = WaoPlayer(
        id: 'p5',
        name: 'Round Trip',
        email: 'rt@wao.com',
        role: PlayerRole.warrior,
        status: PlayerStatus.inactive,
        currentTeamId: 'team-x',
        currentTeamName: 'Team X',
        joinedTeamAt: DateTime(2026, 2, 1),
        gamesPlayed: 3,
        createdAt: DateTime(2026, 1, 1),
        // Deliberately non-null: toFirestore() writes FieldValue.serverTimestamp()
        // when updatedAt is null (see "known issue" below), which only ever
        // resolves to a real Timestamp after an actual Firestore round-trip —
        // feeding it straight back into fromFirestore() without one throws.
        updatedAt: DateTime(2026, 2, 5),
        jerseyNumber: 7,
        age: 20,
      );

      final roundTripped = WaoPlayer.fromFirestore(original.toFirestore(), original.id);

      expect(roundTripped.name, original.name);
      expect(roundTripped.role, original.role);
      expect(roundTripped.status, original.status);
      expect(roundTripped.currentTeamId, original.currentTeamId);
      expect(roundTripped.gamesPlayed, original.gamesPlayed);
      expect(roundTripped.jerseyNumber, original.jerseyNumber);
      expect(roundTripped.age, original.age);
    });
  });

  group('Known issue: FieldValue.serverTimestamp() sentinel is not round-trip safe', () {
    test('toFirestore() with no updatedAt writes a FieldValue sentinel that fromFirestore() cannot parse locally', () {
      final player = WaoPlayer(
        id: 'p6', name: 'N', email: 'n@wao.com', role: PlayerRole.worker,
        createdAt: DateTime(2026, 1, 1),
        // updatedAt intentionally omitted.
      );

      final map = player.toFirestore();
      // This is safe in production: Firestore always resolves the sentinel
      // to a real Timestamp before any read/listener sees the document. It
      // is NOT safe to feed straight back into fromFirestore() without a
      // real server round-trip in between — this throws today.
      expect(() => WaoPlayer.fromFirestore(map, player.id), throwsA(isA<TypeError>()));
    });
  });

  group('WaoPlayer.isAvailable', () {
    test('true only when unassigned and active', () {
      final base = WaoPlayer(
        id: 'p',
        name: 'P',
        email: 'p@wao.com',
        role: PlayerRole.worker,
        createdAt: DateTime(2026, 1, 1),
      );

      expect(base.isAvailable, isTrue);
      expect(base.copyWith(currentTeamId: 'team-a').isAvailable, isFalse);
      expect(base.copyWith(status: PlayerStatus.inactive).isAvailable, isFalse);
      expect(base.copyWith(status: PlayerStatus.suspended).isAvailable, isFalse);
    });
  });
}
