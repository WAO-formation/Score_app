import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/core/theme/app_theme.dart';
import 'package:wao_mobile/core/theme/theme_provider.dart';
import 'package:wao_mobile/system_admin/presentation/Teams/model/state_management.dart';
import 'Model/user_provider.dart';
import 'ViewModel/news_viewmodel/news_viewmodel.dart';
import 'ViewModel/teams_games/championship_viewmodel.dart';
import 'ViewModel/teams_games/match_viewmodel.dart';
import 'ViewModel/teams_games/team_viewmodel.dart';
import 'core/auth_rouths/auth_gate.dart';
import 'core/services/news/news_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

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

    final themeProvider = Provider.of<ThemeProvider>(context);

    return  MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      title: 'WAO Score App',
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}