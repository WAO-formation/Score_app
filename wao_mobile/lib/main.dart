import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/onboarding/onboarding_screen.dart';
import 'package:wao_mobile/presentation/user/teams/models/teams_provider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TeamProvider()),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'WAO Score App',
      debugShowCheckedModeBanner: false,
      home:  OnboardingScreen()
    );
  }
}
