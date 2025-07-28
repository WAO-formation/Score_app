import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/onboarding/onboarding_screen.dart';
import 'package:wao_mobile/presentation/user/teams/models/teams_provider.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/provider/services/chat_services.dart';
import 'package:wao_mobile/provider/services/coach_player_team.dart';
import 'package:wao_mobile/shared/bottom_nav_bar.dart';
import 'package:wao_mobile/system_admin/presentation/Teams/model/state_management.dart';
import 'package:wao_mobile/system_admin/presentation/score_board/view/live_score.dart';
import 'package:wao_mobile/system_admin/presentation/admin_bottom_nav.dart';

import 'Team_Owners/Coach_bottom_nav.dart';
import 'Team_Owners/Home/home_screen.dart';
import 'Team_Owners/chats/chats_list.dart';
import 'Team_Owners/profile/profile.dart';
import 'Team_Owners/team_members/team_members.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TeamProvider()),
        ChangeNotifierProvider(create: (_) => LiveScoreProvider()),
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => CoachTeamProvider()),
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
      home:  BottomNavBar()
    );
  }
}
