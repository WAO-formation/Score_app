import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wao_mobile/Model/user_model.dart';

void main() {
  group('UserProfile.fromFirestore role fallback', () {
    test('parses every AccountRole value, including coach/player', () {
      for (final role in ['fan', 'player', 'coach', 'official', 'moderator', 'admin']) {
        final profile = UserProfile.fromFirestore({
          'username': 'u', 'email': 'u@wao.com', 'role': role,
        }, 'uid-$role');
        expect(profile.accountRole.name, role);
      }
    });

    test('an unrecognized role degrades to fan instead of throwing', () {
      expect(
        () => UserProfile.fromFirestore({'username': 'u', 'email': 'u@wao.com', 'role': 'superadmin'}, 'uid-x'),
        returnsNormally,
      );
      final profile = UserProfile.fromFirestore({'username': 'u', 'email': 'u@wao.com', 'role': 'superadmin'}, 'uid-x');
      expect(profile.accountRole, AccountRole.fan);
    });

    test('a missing role also defaults to fan', () {
      final profile = UserProfile.fromFirestore({'username': 'u', 'email': 'u@wao.com'}, 'uid-y');
      expect(profile.accountRole, AccountRole.fan);
    });
  });

  group('UserProfile.isOfficial / isAdmin', () {
    test('official, moderator, and admin are all "official" tier; fan/player/coach are not', () {
      AccountRole roleOf(String r) => AccountRole.values.byName(r);

      for (final r in ['official', 'moderator', 'admin']) {
        final p = UserProfile(uid: 'x', username: 'u', email: 'e', createdAt: DateTime(2026, 1, 1), accountRole: roleOf(r));
        expect(p.isOfficial, isTrue, reason: '$r should be official-tier');
      }
      for (final r in ['fan', 'player', 'coach']) {
        final p = UserProfile(uid: 'x', username: 'u', email: 'e', createdAt: DateTime(2026, 1, 1), accountRole: roleOf(r));
        expect(p.isOfficial, isFalse, reason: '$r should not be official-tier');
      }
    });

    test('only admin satisfies isAdmin', () {
      final admin = UserProfile(uid: 'x', username: 'u', email: 'e', createdAt: DateTime(2026, 1, 1), accountRole: AccountRole.admin);
      final moderator = UserProfile(uid: 'x', username: 'u', email: 'e', createdAt: DateTime(2026, 1, 1), accountRole: AccountRole.moderator);
      expect(admin.isAdmin, isTrue);
      expect(moderator.isAdmin, isFalse);
    });
  });

  group('UserProfile.teamId', () {
    test('round-trips through toFirestore/fromFirestore', () {
      final profile = UserProfile(
        uid: 'coach-1',
        username: 'coach',
        email: 'coach@wao-demo.com',
        createdAt: DateTime(2026, 1, 1),
        accountRole: AccountRole.coach,
        teamId: 'ashesi_thunder',
      );

      final roundTripped = UserProfile.fromFirestore(profile.toFirestore(), profile.uid);
      expect(roundTripped.teamId, 'ashesi_thunder');
      expect(roundTripped.accountRole, AccountRole.coach);
    });

    test('is null for a fan who has not been assigned a team', () {
      final profile = UserProfile.fromFirestore({'username': 'fan', 'email': 'f@wao.com'}, 'fan-1');
      expect(profile.teamId, isNull);
    });
  });

  group('UserProfile.initials', () {
    test('uses first letters of first and last name when there are two+ words', () {
      final profile = UserProfile(
        uid: 'x', username: 'jdoe', email: 'e', displayName: 'Jane Doe', createdAt: DateTime(2026, 1, 1),
      );
      expect(profile.initials, 'JD');
    });

    test('falls back to the first two letters of a single-word name', () {
      final profile = UserProfile(uid: 'x', username: 'admin', email: 'e', createdAt: DateTime(2026, 1, 1));
      expect(profile.initials, 'AD');
    });
  });

  group('ThemePreference fallback', () {
    test('an unrecognized theme value degrades to system', () {
      final profile = UserProfile.fromFirestore({
        'username': 'u', 'email': 'e', 'themePreference': 'solarized',
      }, 'uid-z');
      expect(profile.themePreference, ThemePreference.system);
    });
  });

  test('createdAt falls back to now() only when the Timestamp is truly absent, not corrupted', () {
    final withTimestamp = UserProfile.fromFirestore({
      'username': 'u', 'email': 'e', 'createdAt': Timestamp.fromDate(DateTime(2020, 5, 5)),
    }, 'uid-w');
    expect(withTimestamp.createdAt, DateTime(2020, 5, 5));
  });
}
