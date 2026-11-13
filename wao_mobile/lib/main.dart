import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/core/services/notification_service.dart';
import 'package:wao_mobile/core/theme/app_theme.dart';
import 'package:wao_mobile/core/theme/theme_provider.dart';
import 'Model/user_provider.dart';
import 'ViewModel/news_viewmodel/news_viewmodel.dart';
import 'ViewModel/teams_games/championship_viewmodel.dart';
import 'ViewModel/teams_games/match_viewmodel.dart';
import 'ViewModel/teams_games/player_viewmodel.dart';
import 'ViewModel/teams_games/team_viewmodel.dart';
import 'core/auth_rouths/auth_gate.dart';
import 'core/services/news/news_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Web can't read google-services config natively, so it needs explicit
  // options. Native platforms keep using their bundled config files.
  await Firebase.initializeApp(
    options: kIsWeb ? DefaultFirebaseOptions.web : null,
  );

  // Crashlytics has no web or Windows/Linux implementation at all (unlike
  // firebase_messaging below, which at least supports web) — only android/
  // iOS/macOS. Without this, every error caught in a service's try/catch
  // only ever reached `print`, which goes nowhere in a release build —
  // see MOBILE_ARCHITECTURE_REVIEW.md finding #8. This wires up the two
  // global handlers (sync Flutter framework errors + uncaught async
  // errors); the per-service `print` calls in catch blocks are unchanged —
  // migrating those to explicit recordError calls is a followup, not part
  // of this pass.
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // firebase_messaging has no Windows/Linux desktop support — guarded so a
  // desktop build doesn't crash on startup trying to request permission or
  // fetch a token on a platform the plugin can't run on at all.
  if (kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    try {
      await NotificationService.instance.init();
    } catch (e) {
      print('Notification init failed: $e');
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MatchViewModel()),
        ChangeNotifierProvider(create: (_) => TeamViewModel()),
        ChangeNotifierProvider(create: (_) => PlayerViewModel()),
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