import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../Model/teams_games/team/team_stat.dart';
import '../../Model/teams_games/team/wao_player.dart';
import '../../Model/teams_games/wao_team.dart';
import '../../ViewModel/teams_games/player_viewmodel.dart';
import 'match_team_service/match_service.dart';
import 'match_team_service/team_service.dart';
import 'news/news_service.dart';

class SeedingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TeamService _teamService = TeamService();
  final PlayerService _playerService = PlayerService();
  final MatchService _matchService = MatchService();
  final NewsService _newsService = NewsService();

  // ==================== SEED PLAYERS ====================

  Future<Map<String, String>> seedPlayers() async {
    print('🌱 Starting to seed players...');

    // If players already exist, load them into the map and skip
    final existing = await _firestore.collection('players').get();
    if (existing.docs.isNotEmpty) {
      print('ℹ️  Players already seeded, loading existing...');
      final Map<String, String> playerMap = {};
      for (var doc in existing.docs) {
        final name = doc.data()['name'] as String?;
        if (name != null) playerMap[name] = doc.id;
      }
      return playerMap;
    }

    final Map<String, String> playerMap = {};

    final List<Map<String, dynamic>> playersData = [
      // Kings
      {'name': 'Kwame Nkrumah', 'email': 'kwame@wao.com', 'role': PlayerRole.king},
      {'name': 'Yaa Asantewaa', 'email': 'yaa@wao.com', 'role': PlayerRole.king},
      {'name': 'John Atta Mills', 'email': 'john@wao.com', 'role': PlayerRole.king},
      {'name': 'Akosua Mansa', 'email': 'akosua@wao.com', 'role': PlayerRole.king},

      // Workers
      {'name': 'Kofi Mensah', 'email': 'kofi.mensah@wao.com', 'role': PlayerRole.worker},
      {'name': 'Ama Serwaa', 'email': 'ama.serwaa@wao.com', 'role': PlayerRole.worker},
      {'name': 'Kwesi Appiah', 'email': 'kwesi.appiah@wao.com', 'role': PlayerRole.worker},
      {'name': 'Efua Danso', 'email': 'efua.danso@wao.com', 'role': PlayerRole.worker},
      {'name': 'Kojo Owusu', 'email': 'kojo.owusu@wao.com', 'role': PlayerRole.worker},
      {'name': 'Abena Boateng', 'email': 'abena.boateng@wao.com', 'role': PlayerRole.worker},
      {'name': 'Yaw Preko', 'email': 'yaw.preko@wao.com', 'role': PlayerRole.worker},
      {'name': 'Adwoa Amoako', 'email': 'adwoa.amoako@wao.com', 'role': PlayerRole.worker},

      // Protagues
      {'name': 'Emmanuel Agyemang', 'email': 'emmanuel.agyemang@wao.com', 'role': PlayerRole.protague},
      {'name': 'Grace Asante', 'email': 'grace.asante@wao.com', 'role': PlayerRole.protague},
      {'name': 'Daniel Addae', 'email': 'daniel.addae@wao.com', 'role': PlayerRole.protague},
      {'name': 'Felicia Osei', 'email': 'felicia.osei@wao.com', 'role': PlayerRole.protague},
      {'name': 'Joseph Ankrah', 'email': 'joseph.ankrah@wao.com', 'role': PlayerRole.protague},

      // Antagues
      {'name': 'Samuel Arthur', 'email': 'samuel.arthur@wao.com', 'role': PlayerRole.antague},
      {'name': 'Rebecca Tetteh', 'email': 'rebecca.tetteh@wao.com', 'role': PlayerRole.antague},
      {'name': 'Michael Osei', 'email': 'michael.osei@wao.com', 'role': PlayerRole.antague},
      {'name': 'Jennifer Ampofo', 'email': 'jennifer.ampofo@wao.com', 'role': PlayerRole.antague},
      {'name': 'Patrick Awuah', 'email': 'patrick.awuah@wao.com', 'role': PlayerRole.antague},

      // Warriors
      {'name': 'Ernest Boateng', 'email': 'ernest.boateng@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Victoria Mensah', 'email': 'victoria.mensah@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Collins Owusu', 'email': 'collins.owusu@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Sarah Mensah', 'email': 'sarah.mensah@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Robert Darko', 'email': 'robert.darko@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Nana Ama Owusu', 'email': 'nana.ama@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Francis Appiah', 'email': 'francis.appiah@wao.com', 'role': PlayerRole.warrior},

      // Sacrificers
      {'name': 'George Acquah', 'email': 'george.acquah@wao.com', 'role': PlayerRole.sacrificer},
      {'name': 'Elizabeth Owusu', 'email': 'elizabeth.owusu@wao.com', 'role': PlayerRole.sacrificer},
      {'name': 'Emmanuel Quartey', 'email': 'emmanuel.quartey@wao.com', 'role': PlayerRole.sacrificer},
      {'name': 'Abena Serwaa', 'email': 'abena.serwaa@wao.com', 'role': PlayerRole.sacrificer},
      {'name': 'Kyei Solomon', 'email': 'kyei.solomon@wao.com', 'role': PlayerRole.sacrificer},

      // Additional players for other teams
      {'name': 'Philip Nortey', 'email': 'philip.nortey@wao.com', 'role': PlayerRole.king},
      {'name': 'Angela Brooks', 'email': 'angela.brooks@wao.com', 'role': PlayerRole.worker},
      {'name': 'Ernest Aryeetey', 'email': 'ernest.aryeetey@wao.com', 'role': PlayerRole.protague},
      {'name': 'Linda Asiedu', 'email': 'linda.asiedu@wao.com', 'role': PlayerRole.antague},
      {'name': 'Richard Mensah', 'email': 'richard.mensah@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Comfort Acheampong', 'email': 'comfort.acheampong@wao.com', 'role': PlayerRole.sacrificer},

      {'name': 'Stephen Amoah', 'email': 'stephen.amoah@wao.com', 'role': PlayerRole.worker},
      {'name': 'Margaret Ofosu', 'email': 'margaret.ofosu@wao.com', 'role': PlayerRole.protague},
      {'name': 'Benjamin Mensah', 'email': 'benjamin.mensah@wao.com', 'role': PlayerRole.antague},
      {'name': 'Joyce Amponsah', 'email': 'joyce.amponsah@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Isaac Donkor', 'email': 'isaac.donkor@wao.com', 'role': PlayerRole.sacrificer},
      {'name': 'Patience Frimpong', 'email': 'patience.frimpong@wao.com', 'role': PlayerRole.worker},

      {'name': 'Andrew Boakye', 'email': 'andrew.boakye@wao.com', 'role': PlayerRole.king},
      {'name': 'Faustina Agyei', 'email': 'faustina.agyei@wao.com', 'role': PlayerRole.protague},
      {'name': 'Solomon Adu', 'email': 'solomon.adu@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Vivian Opoku', 'email': 'vivian.opoku@wao.com', 'role': PlayerRole.worker},
      {'name': 'Thomas Afriyie', 'email': 'thomas.afriyie@wao.com', 'role': PlayerRole.antague},

      // More players for complete rosters
      {'name': 'Peter Adjei', 'email': 'peter.adjei@wao.com', 'role': PlayerRole.worker},
      {'name': 'Mary Asare', 'email': 'mary.asare@wao.com', 'role': PlayerRole.protague},
      {'name': 'James Okyere', 'email': 'james.okyere@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Ruth Ansah', 'email': 'ruth.ansah@wao.com', 'role': PlayerRole.sacrificer},
      {'name': 'Charles Mensah', 'email': 'charles.mensah@wao.com', 'role': PlayerRole.king},

      {'name': 'Esther Gyasi', 'email': 'esther.gyasi@wao.com', 'role': PlayerRole.worker},
      {'name': 'David Owusu', 'email': 'david.owusu@wao.com', 'role': PlayerRole.antague},
      {'name': 'Doris Asamoah', 'email': 'doris.asamoah@wao.com', 'role': PlayerRole.protague},
      {'name': 'Frederick Adu', 'email': 'frederick.adu@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Hannah Boateng', 'email': 'hannah.boateng@wao.com', 'role': PlayerRole.sacrificer},

      {'name': 'Christopher Antwi', 'email': 'christopher.antwi@wao.com', 'role': PlayerRole.king},
      {'name': 'Lydia Owusu', 'email': 'lydia.owusu@wao.com', 'role': PlayerRole.worker},
      {'name': 'Albert Mensah', 'email': 'albert.mensah@wao.com', 'role': PlayerRole.protague},
      {'name': 'Cynthia Osei', 'email': 'cynthia.osei@wao.com', 'role': PlayerRole.antague},
      {'name': 'Nicholas Agyei', 'email': 'nicholas.agyei@wao.com', 'role': PlayerRole.warrior},
      {'name': 'Deborah Asante', 'email': 'deborah.asante@wao.com', 'role': PlayerRole.sacrificer},
    ];

    try {
      final batch = _firestore.batch();
      int count = 0;

      for (var playerData in playersData) {
        final docRef = _firestore.collection('players').doc();
        final playerId = docRef.id;

        final player = WaoPlayer(
          id: playerId,
          name: playerData['name'] as String,
          email: playerData['email'] as String,
          role: playerData['role'] as PlayerRole,
          status: PlayerStatus.active,
          createdAt: DateTime.now(),
        );

        batch.set(docRef, player.toFirestore());
        playerMap[player.name] = playerId;
        count++;
      }

      await batch.commit();
      print('✅ Successfully seeded $count players');
      return playerMap;
    } catch (e) {
      print('❌ Error seeding players: $e');
      rethrow;
    }
  }

  // ==================== SEED TEAMS ====================

  Future<void> seedTeams(Map<String, String> playerMap) async {
    print('🌱 Starting to seed teams...');

    final existingTeams = await _firestore.collection('teams').get();
    if (existingTeams.docs.isNotEmpty) {
      print('ℹ️  Teams already seeded, skipping...');
      return;
    }

    final List<Map<String, dynamic>> teamsData = [
      {
        'id': 'ug_warriors',
        'name': 'UG Warriors',
        'category': TeamCategory.senior,
        'campusId': 'ug_legon',
        'coach': 'Daniel Addae',
        'secretary': 'Grace Asante',
        'director': 'Kyei Solomon',
        'logoUrl': '',
        'isTopTeam': true,
        'ranking': 1,
        'players': {
          'kings': ['Kwame Nkrumah'],
          'workers': ['Kofi Mensah', 'Ama Serwaa'],
          'protagues': ['Emmanuel Agyemang', 'Daniel Addae'],
          'antagues': ['Samuel Arthur', 'Rebecca Tetteh'],
          'warriors': ['Ernest Boateng', 'Victoria Mensah', 'Collins Owusu'],
          'sacrificers': ['George Acquah', 'Elizabeth Owusu', 'Emmanuel Quartey'],
        }
      },
      {
        'id': 'knust_stars',
        'name': 'KNUST Stars',
        'category': TeamCategory.senior,
        'campusId': 'knust_kumasi',
        'coach': 'Samuel Arthur',
        'secretary': 'Rebecca Tetteh',
        'director': 'Ernest Boateng',
        'logoUrl': '',
        'isTopTeam': true,
        'ranking': 2,
        'players': {
          'kings': ['Yaa Asantewaa'],
          'workers': ['Kwesi Appiah', 'Efua Danso', 'Kojo Owusu'],
          'protagues': ['Grace Asante', 'Felicia Osei'],
          'antagues': ['Michael Osei', 'Jennifer Ampofo'],
          'warriors': ['Sarah Mensah', 'Robert Darko'],
          'sacrificers': ['Abena Serwaa', 'Kyei Solomon'],
        }
      },
      {
        'id': 'ucc_titans',
        'name': 'UCC Titans',
        'category': TeamCategory.senior,
        'campusId': 'ucc_cape_coast',
        'coach': 'Michael Osei',
        'secretary': 'Jennifer Ampofo',
        'director': 'Philip Nortey',
        'logoUrl': '',
        'isTopTeam': true,
        'ranking': 3,
        'players': {
          'kings': ['John Atta Mills'],
          'workers': ['Abena Boateng', 'Yaw Preko'],
          'protagues': ['Joseph Ankrah', 'Margaret Ofosu'],
          'antagues': ['Patrick Awuah', 'Linda Asiedu'],
          'warriors': ['Nana Ama Owusu', 'Francis Appiah', 'Richard Mensah'],
          'sacrificers': ['Comfort Acheampong', 'Isaac Donkor'],
        }
      },
      {
        'id': 'upsa_eagles',
        'name': 'UPSA Eagles',
        'category': TeamCategory.senior,
        'campusId': 'upsa_accra',
        'coach': 'Patrick Awuah',
        'secretary': 'Nana Ama Owusu',
        'director': 'George Acquah',
        'logoUrl': '',
        'isTopTeam': false,
        'ranking': 0,
        'players': {
          'kings': ['Akosua Mansa'],
          'workers': ['Adwoa Amoako', 'Stephen Amoah', 'Angela Brooks'],
          'protagues': ['Ernest Aryeetey', 'Faustina Agyei'],
          'antagues': ['Benjamin Mensah', 'Thomas Afriyie'],
          'warriors': ['Joyce Amponsah', 'Solomon Adu'],
          'sacrificers': ['Patience Frimpong', 'Ruth Ansah'],
        }
      },
      {
        'id': 'wao_all_stars',
        'name': 'WAO All-Stars',
        'category': TeamCategory.senior,
        'campusId': null,
        'coach': 'Joseph Ankrah',
        'secretary': 'Elizabeth Owusu',
        'director': 'Francis Appiah',
        'logoUrl': '',
        'isTopTeam': true,
        'ranking': 4,
        'players': {
          'kings': ['Philip Nortey', 'Andrew Boakye'],
          'workers': ['Vivian Opoku', 'Peter Adjei'],
          'protagues': ['Mary Asare', 'Doris Asamoah'],
          'antagues': ['David Owusu', 'Cynthia Osei'],
          'warriors': ['James Okyere', 'Frederick Adu'],
          'sacrificers': ['Hannah Boateng', 'Deborah Asante'],
        }
      },
      {
        'id': 'ashesi_thunder',
        'name': 'Ashesi Thunder',
        'category': TeamCategory.senior,
        'campusId': 'ashesi_berekuso',
        'coach': 'Angela Brooks',
        'secretary': 'Comfort Acheampong',
        'director': 'Ernest Aryeetey',
        'logoUrl': '',
        'isTopTeam': false,
        'ranking': 0,
        'players': {
          'kings': ['Charles Mensah'],
          'workers': ['Esther Gyasi', 'Lydia Owusu'],
          'protagues': ['Albert Mensah'],
          'antagues': [],
          'warriors': ['Nicholas Agyei'],
          'sacrificers': [],
        }
      },
    ];

    try {
      final batch = _firestore.batch();
      int teamCount = 0;

      for (var teamData in teamsData) {
        final teamId = teamData['id'] as String;
        final teamDocRef = _firestore.collection('teams').doc(teamId);

        // Build roster from player names - FIXED TYPE CASTING
        final playersData = teamData['players'] as Map<String, dynamic>;

        // Helper function to safely convert player names to IDs
        List<String> getPlayerIds(List<dynamic> playerNames) {
          return playerNames
              .cast<String>() // Cast to List<String> first
              .map((name) {
            if (!playerMap.containsKey(name)) {
              throw Exception('Player "$name" not found in playerMap');
            }
            return playerMap[name]!;
          })
              .toList();
        }

        final roster = TeamRoster(
          kingIds: getPlayerIds(playersData['kings'] as List<dynamic>),
          workerIds: getPlayerIds(playersData['workers'] as List<dynamic>),
          protagueIds: getPlayerIds(playersData['protagues'] as List<dynamic>),
          antagueIds: getPlayerIds(playersData['antagues'] as List<dynamic>),
          warriorIds: getPlayerIds(playersData['warriors'] as List<dynamic>),
          sacrificerIds: getPlayerIds(playersData['sacrificers'] as List<dynamic>),
        );

        final team = WaoTeam(
          id: teamId,
          name: teamData['name'] as String,
          category: teamData['category'] as TeamCategory,
          campusId: teamData['campusId'] as String?,
          coach: teamData['coach'] as String,
          secretary: teamData['secretary'] as String,
          director: teamData['director'] as String,
          logoUrl: teamData['logoUrl'] as String,
          isTopTeam: teamData['isTopTeam'] as bool,
          ranking: teamData['ranking'] as int,
          roster: roster,
          createdAt: DateTime.now(),
        );

        // Add team document
        batch.set(teamDocRef, team.toFirestore());

        // Initialize team statistics
        final statsDocRef = _firestore.collection('teamStatistics').doc(teamId);
        final stats = TeamStatistics(
          teamId: teamId,
          activePlayers: roster.totalPlayers,
          updatedAt: DateTime.now(),
        );
        batch.set(statsDocRef, stats.toFirestore());

        // Update player documents with team assignments
        for (var playerId in roster.getAllPlayerIds()) {
          final playerDocRef = _firestore.collection('players').doc(playerId);
          batch.update(playerDocRef, {
            'currentTeamId': teamId,
            'currentTeamName': team.name,
            'joinedTeamAt': FieldValue.serverTimestamp(),
          });
        }

        teamCount++;
      }

      await batch.commit();
      print('✅ Successfully seeded $teamCount teams');
    } catch (e) {
      print('❌ Error seeding teams: $e');
      rethrow;
    }
  }

  // ==================== SEED SAMPLE GAMES ====================

  Future<void> seedSampleGames() async {
    print('🌱 Starting to seed sample games...');

    final existingStats = await _firestore.collection('teamStatistics')
        .where('gamesPlayed', isGreaterThan: 0).limit(1).get();
    if (existingStats.docs.isNotEmpty) {
      print('ℹ️  Sample games already seeded, skipping...');
      return;
    }

    final List<Map<String, dynamic>> gamesData = [
      {
        'teamId': 'ug_warriors',
        'gameResult': GameResult(
          gameId: 'game_001',
          opponentTeamId: 'knust_stars',
          opponentTeamName: 'KNUST Stars',
          teamScore: 3,
          opponentScore: 2,
          playedAt: DateTime.now().subtract(const Duration(days: 30)),
          isHomeGame: true,
        ),
      },
      {
        'teamId': 'ug_warriors',
        'gameResult': GameResult(
          gameId: 'game_002',
          opponentTeamId: 'ucc_titans',
          opponentTeamName: 'UCC Titans',
          teamScore: 2,
          opponentScore: 2,
          playedAt: DateTime.now().subtract(const Duration(days: 23)),
          isHomeGame: false,
        ),
      },
      {
        'teamId': 'ug_warriors',
        'gameResult': GameResult(
          gameId: 'game_003',
          opponentTeamId: 'upsa_eagles',
          opponentTeamName: 'UPSA Eagles',
          teamScore: 4,
          opponentScore: 1,
          playedAt: DateTime.now().subtract(const Duration(days: 16)),
          isHomeGame: true,
        ),
      },
      {
        'teamId': 'knust_stars',
        'gameResult': GameResult(
          gameId: 'game_001',
          opponentTeamId: 'ug_warriors',
          opponentTeamName: 'UG Warriors',
          teamScore: 2,
          opponentScore: 3,
          playedAt: DateTime.now().subtract(const Duration(days: 30)),
          isHomeGame: false,
        ),
      },
      {
        'teamId': 'knust_stars',
        'gameResult': GameResult(
          gameId: 'game_004',
          opponentTeamId: 'wao_all_stars',
          opponentTeamName: 'WAO All-Stars',
          teamScore: 3,
          opponentScore: 1,
          playedAt: DateTime.now().subtract(const Duration(days: 20)),
          isHomeGame: true,
        ),
      },
      {
        'teamId': 'ucc_titans',
        'gameResult': GameResult(
          gameId: 'game_002',
          opponentTeamId: 'ug_warriors',
          opponentTeamName: 'UG Warriors',
          teamScore: 2,
          opponentScore: 2,
          playedAt: DateTime.now().subtract(const Duration(days: 23)),
          isHomeGame: true,
        ),
      },
      {
        'teamId': 'ucc_titans',
        'gameResult': GameResult(
          gameId: 'game_005',
          opponentTeamId: 'upsa_eagles',
          opponentTeamName: 'UPSA Eagles',
          teamScore: 1,
          opponentScore: 0,
          playedAt: DateTime.now().subtract(const Duration(days: 14)),
          isHomeGame: false,
        ),
      },
    ];

    try {
      for (var gameData in gamesData) {
        await _teamService.updateTeamStatisticsAfterGame(
          teamId: gameData['teamId'] as String,
          gameResult: gameData['gameResult'] as GameResult,
        );
      }

      print('✅ Successfully seeded ${gamesData.length} game results');
    } catch (e) {
      print('❌ Error seeding games: $e');
      rethrow;
    }
  }

  // ==================== SEED ADMIN PROFILE ====================

  Future<void> seedAdminProfile() async {
    print('🌱 Seeding admin profile...');
    const email = 'afanyuemma2002@gmail.com';
    const password = 'Wao@2024Demo';

    String uid;

    // Check if Firestore profile already exists by querying email
    final existing = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      print('ℹ️  Admin profile already exists, skipping...');
      return;
    }

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      uid = credential.user!.uid;
      await credential.user!.updateDisplayName('Afanyu Emmanuel');
      // Sign out immediately so app auth state is not affected
      await FirebaseAuth.instance.signOut();
      print('✅ Firebase Auth account created');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('ℹ️  Auth account already exists, fetching UID...');
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        uid = credential.user!.uid;
        await FirebaseAuth.instance.signOut();
      } else {
        rethrow;
      }
    }

    // firestore.rules only allows a user to create their own profile with
    // role: 'fan' — no client, including this seeding script, can hand
    // itself 'admin'. Create as fan, then promote by hand in the Firebase
    // Console (Firestore Data tab: users/{uid} -> role -> "admin") or via
    // the Admin SDK, which is exempt from these rules. Every other seed
    // step (players/teams/matches/news) needs that promotion to have
    // happened first, since they all require an official/admin caller.
    await _firestore.collection('users').doc(uid).set({
      'username': 'afanyuemma',
      'email': email,
      'displayName': 'Afanyu Emmanuel',
      'photoUrl': null,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'favoriteTeamIds': [],
      'favoriteMatchIds': [],
      'totalMatches': 0,
      'totalTeams': 0,
      'themePreference': 'system',
      'notificationsEnabled': true,
      'emailNotifications': false,
      'language': 'English',
      'role': 'fan',
    }, SetOptions(merge: true));

    print('✅ Profile created for $email — now open the Firebase Console,');
    print('   set users/$uid . role to "admin", then re-run the rest of seedAll().');
  }

  // ==================== MASTER SEED FUNCTION ====================

  Future<void> seedAll() async {
    print('');
    print('🚀 ========================================');
    print('🚀 Starting Complete Database Seeding');
    print('🚀 ========================================');
    print('');

    try {
      // Step 1: Seed Admin Profile
      print('📍 Step 1/5: Seeding Admin Profile...');
      await seedAdminProfile();
      print('');

      // Step 2: Seed Players
      print('📍 Step 2/5: Seeding Players...');
      final playerMap = await seedPlayers();
      print('');

      // Step 3: Seed Teams
      print('📍 Step 3/5: Seeding Teams...');
      await seedTeams(playerMap);
      print('');

      // Step 4: Seed Sample Games
      print('📍 Step 4/5: Seeding Sample Games...');
      await seedSampleGames();
      print('');

      // Step 5: Seed Matches
      print('📍 Step 5/6: Seeding Matches...');
      final matchesEmpty = await _matchService.isMatchesEmpty();
      if (matchesEmpty) {
        await _matchService.seedMatches();
      } else {
        print('ℹ️  Matches already seeded, skipping...');
      }
      print('');

      // Step 6: Seed News
      print('📍 Step 6/6: Seeding News...');
      final newsEmpty = (await _firestore.collection('news').limit(1).get()).docs.isEmpty;
      if (newsEmpty) {
        await _newsService.addSampleNews();
      } else {
        print('ℹ️  News already seeded, skipping...');
      }
      print('');

      print('🎉 ========================================');
      print('🎉 Database Seeding Completed Successfully!');
      print('🎉 ========================================');
      print('');
      print('📊 Summary:');
      print('   - Admin profile: Afanyu Emmanuel');
      print('   - ${playerMap.length} players created');
      print('   - 6 teams created');
      print('   - Sample game history added');
      print('   - Matches seeded (live, upcoming, finished)');
      print('   - News articles seeded');
      print('');
    } catch (e) {
      print('');
      print('💥 ========================================');
      print('💥 Seeding Failed!');
      print('💥 ========================================');
      print('Error: $e');
      print('');
      rethrow;
    }
  }

  // ==================== CLEAR DATABASE ====================

  Future<void> clearAll() async {
    print('');
    print('🗑️  ========================================');
    print('🗑️  Clearing Database...');
    print('🗑️  ========================================');
    print('');

    try {
      final batch = _firestore.batch();

      // Clear teams
      print('Clearing teams...');
      final teamsSnapshot = await _firestore.collection('teams').get();
      for (var doc in teamsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Clear team statistics
      print('Clearing team statistics...');
      final statsSnapshot = await _firestore.collection('teamStatistics').get();
      for (var doc in statsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Clear players
      print('Clearing players...');
      final playersSnapshot = await _firestore.collection('players').get();
      for (var doc in playersSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      print('');
      print('✅ Database cleared successfully');
      print('');
    } catch (e) {
      print('❌ Error clearing database: $e');
      rethrow;
    }
  }

  // ==================== CHECK DATABASE STATUS ====================

  Future<void> checkDatabaseStatus() async {
    try {
      final teamsCount = (await _firestore.collection('teams').get()).docs.length;
      final playersCount = (await _firestore.collection('players').get()).docs.length;
      final statsCount = (await _firestore.collection('teamStatistics').get()).docs.length;

      print('');
      print('📊 Database Status:');
      print('   - Teams: $teamsCount');
      print('   - Players: $playersCount');
      print('   - Team Statistics: $statsCount');
      print('');
    } catch (e) {
      print('Error checking database: $e');
    }
  }
}