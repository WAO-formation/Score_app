import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wao_mobile/View/onboarding/onboarding_screen.dart';
import 'package:wao_mobile/View/onboarding/splash_screen.dart';
import 'package:wao_mobile/shared/bottom_nav_bar.dart';

import '../../Model/user_provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    // Check if user has seen onboarding before
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      // Skip onboarding if already seen
      if (mounted) {
        setState(() {
          _showOnboarding = false;
        });
      }
    } else {
      // Show onboarding for 3 seconds, then mark as seen
      Future.delayed(const Duration(seconds: 3), () async {
        await prefs.setBool('hasSeenOnboarding', true);
        if (mounted) {
          setState(() {
            _showOnboarding = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return const OnboardingScreen();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          // Initialize user profile when logged in
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            userProvider.loadUserProfile(snapshot.data!.uid);
          });

          return const BottomNavBar();
        }

        // User is not logged in
        return const SplashScreen();
      },
    );
  }
}