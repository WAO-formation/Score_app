import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/dashboard/onboarding_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
       const MyApp(),
  );

  Firebase.initializeApp( options: const FirebaseOptions(apiKey: 'AIzaSyCWXOZkHHkfwchh4j97LREKWtB67-IoKIY', appId: '1:125606910018:web:4b8c1234b094f7ddd2b5db', messagingSenderId: '125606910018', projectId: 'woa-mobile-application'));
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
