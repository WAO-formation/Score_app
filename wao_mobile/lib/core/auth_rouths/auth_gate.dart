import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/View/onboarding/splash_screen.dart';
import 'package:wao_mobile/core/widgets/wao_loading_screen.dart';
import 'package:wao_mobile/shared/bottom_nav_bar.dart';

import '../../Model/user_provider.dart';

/// Decides the first screen after the native launch splash: a brief branded
/// loader while Firebase settles, then either the app shell (signed in) or the
/// "Get Started" screen. There is no separate in-app splash — the OS launch
/// screen is the only splash.
///
/// Firebase Auth persists the signed-in session on-device indefinitely on
/// its own (Keychain on iOS, encrypted prefs on Android) — closing and
/// reopening the app never signs anyone out. Sign-in only ends when
/// signOut() is called explicitly (Profile > Log Out).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const WaoLoadingScreen(message: 'Signing you in');
        }

        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            userProvider.loadUserProfile(user.uid);
          });

          return const BottomNavBar();
        }

        return const SplashScreen();
      },
    );
  }
}
