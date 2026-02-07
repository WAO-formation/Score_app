import 'package:flutter/material.dart';

import 'package:wao_mobile/shared/theme_data.dart';
import 'package:wao_mobile/system_admin/presentation/registrations/Officials-and-teams.dart';

import 'score_board/view/live_score.dart';
import 'dasboard/dashboard.dart';
import 'match_sheduling/match_sheduling.dart';


class AdminBottomNavBar extends StatefulWidget{
  const AdminBottomNavBar({super.key});

  @override
  State<AdminBottomNavBar> createState() => AdminBottomNavBarState();

}

class AdminBottomNavBarState extends State<AdminBottomNavBar>{
  int currentIndex = 0;
  List pages =  [
    const AdminDashboard(title: '',),
    const LiveScoresPage(),
    const OfficialsAndTeams(),
  ];
  @override
  Widget build(BuildContext context) {

    return  Scaffold(

        bottomNavigationBar: SizedBox(
          height: 80.0,
          child: BottomNavigationBar(
            selectedItemColor: lightColorScheme.onPrimary,
            unselectedItemColor: const Color(0xffadb5bd),
            backgroundColor: lightColorScheme.secondary,

            // ✅ Add this to show all labels
            type: BottomNavigationBarType.fixed,

            // ✅ Optional: to make selected label bold
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),

            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30.0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_basketball_rounded, size: 30.0),
                label: 'Games',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.gamepad_outlined, size: 30.0),
                label: 'Live',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt, size: 30.0),
                label: 'Officials',
              ),
            ],
          ),
        ),

        body: pages[currentIndex]
    );
  }

}