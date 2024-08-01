import 'package:flutter/material.dart';
import 'package:wao_mobile/screens/dashboard/onboarding_screen.dart';
import 'package:wao_mobile/screens/registration%20and%20login/login.dart';
import 'package:wao_mobile/screens/registration%20and%20login/signup.dart';
import 'package:wao_mobile/team_admin/admin_team_dashboard.dart';
import 'dart:ui';

import 'Theme/dark_theme.dart';
import 'Theme/light_theme.dart';
import 'custom_widgets/bottom_nav_bar.dart';

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
    return MaterialApp(
      title: 'WAO Score App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home:  const onboardingSreen(),
    );
  }
}
