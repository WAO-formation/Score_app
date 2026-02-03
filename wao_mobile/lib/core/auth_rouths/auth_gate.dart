import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wao_mobile/View/onboarding/onboarding_screen.dart';
import 'package:wao_mobile/View/onboarding/splash_screen.dart';
import 'package:wao_mobile/shared/bottom_nav_bar.dart';

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
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showOnboarding = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return const OnboardingScreen();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          return const BottomNavBar();
        }

        return const SplashScreen();
      },
    );
  }
}