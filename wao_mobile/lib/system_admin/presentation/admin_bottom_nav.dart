import 'package:flutter/material.dart';

import 'package:wao_mobile/presentation/dashboard/dashboard.dart';
import 'package:wao_mobile/presentation/officiates/officiate_dashboard.dart';

import 'package:wao_mobile/shared/theme_data.dart';
import 'package:wao_mobile/system_admin/presentation/registrations/Officials-and-teams.dart';

import 'match_sheduling/match_sheduling.dart';


class AdminBottomNavBar extends StatefulWidget{
  const AdminBottomNavBar({super.key});

  @override
  State<AdminBottomNavBar> createState() => AdminBottomNavBarState();

}

class AdminBottomNavBarState extends State<AdminBottomNavBar>{
  int currentIndex = 0;
  List pages =  [
    const DashboardHome(title: '',),
    const MatchManagement(),
    const OfficialsAndTeams(),
  ];
  @override
  Widget build(BuildContext context) {

    return  Scaffold(

        bottomNavigationBar: SizedBox(
          height: 80.0,

          child: BottomNavigationBar(
            selectedItemColor: lightColorScheme.onPrimary ,
            unselectedItemColor: const Color(0xffadb5bd),
            backgroundColor: lightColorScheme.secondary,
            onTap: (index){
              setState((){
                currentIndex = index;
              });
            },
            currentIndex: currentIndex,items: [
            BottomNavigationBarItem(icon: const Icon(Icons.home, size:35.0), label: 'Home',
              backgroundColor: lightColorScheme.secondary, ),

            const BottomNavigationBarItem(icon: Icon(Icons.sports_basketball_rounded, size:35.0), label:'Games'),

            const BottomNavigationBarItem(icon: Icon(Icons.people_alt, size:35.0), label:' Officials' ),
          ],
          ),
        ),
        body: pages[currentIndex]
    );
  }

}