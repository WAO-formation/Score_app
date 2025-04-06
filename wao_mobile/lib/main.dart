import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/authentication/login.dart';
import 'package:wao_mobile/presentation/officiates/officiate_dashboard.dart';
import 'package:wao_mobile/presentation/onboarding/onboarding_screen.dart';
import 'package:wao_mobile/presentation/onboarding/splash_screen.dart';
import 'package:wao_mobile/shared/bottom_nav_bar.dart';


void main() {
  runApp(
       MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'WAO Score App',
      debugShowCheckedModeBanner: false,
      home:  BottomNavBar()
    );
  }
}
