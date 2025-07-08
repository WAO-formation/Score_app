import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/onboarding/onboarding_screen.dart';
import 'package:wao_mobile/presentation/user/teams/models/teams_provider.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/system_admin/presentation/Teams/model/state_management.dart';
import 'package:wao_mobile/system_admin/presentation/score_board/view/live_score.dart';
import 'package:wao_mobile/system_admin/presentation/admin_bottom_nav.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => LiveScoreProvider()),
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
      home:  AdminBottomNavBar()
    );
  }
}
