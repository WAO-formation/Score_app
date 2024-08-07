import 'package:flutter/material.dart';
import 'package:wao_mobile/screens/dashboard/onboarding_screen.dart';

import 'Theme/dark_theme.dart';
import 'Theme/light_theme.dart';

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
