import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/dashboard/onboarding_screen.dart';


void main() {
  runApp(
       MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'WAO Score App',
      debugShowCheckedModeBanner: false,
      home:  OnboardingScreen(),
    );
  }
}
