import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/core/services/Seeding_service.dart';
import 'package:wao_mobile/core/theme/app_theme.dart';
import 'package:wao_mobile/core/theme/theme_provider.dart';
import 'package:wao_mobile/core/providers/live_score_provider.dart';
import 'Model/user_provider.dart';
import 'ViewModel/news_viewmodel/news_viewmodel.dart';
import 'ViewModel/teams_games/championship_viewmodel.dart';
import 'ViewModel/teams_games/match_viewmodel.dart';
import 'ViewModel/teams_games/team_viewmodel.dart';
import 'core/auth_rouths/auth_gate.dart';
import 'core/services/news/news_service.dart';

Future<void> _runSeedOnce() async {
  try {
    await SeedingService().seedAll();
  } catch (e) {
    print('Seed on launch failed: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Web can't read google-services config natively, so it needs explicit
  // options. Native platforms keep using their bundled config files.
  await Firebase.initializeApp(
    options: kIsWeb ? DefaultFirebaseOptions.web : null,
  );

  // Seed demo data once on first launch (creates auth account + Firestore data)
  await _runSeedOnce();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LiveScoreProvider()),
        ChangeNotifierProvider(create: (_) => MatchViewModel()),
        ChangeNotifierProvider(create: (_) => TeamViewModel()),
        ChangeNotifierProvider(create: (_) => ChampionshipViewModel()),
        ChangeNotifierProvider(create: (_) => NewsViewModel(NewsService())),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
      // Locked to light regardless of the device's system setting or any
      // stored preference — the in-app theme picker (Profile > Settings)
      // still writes a preference, it just no longer changes what renders.
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme,
      title: 'WAO Score App',
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}