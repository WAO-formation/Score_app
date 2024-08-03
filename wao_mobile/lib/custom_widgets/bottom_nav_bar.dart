import 'package:flutter/material.dart';

import 'package:wao_mobile/screens/user/about_dashboard.dart';
import 'package:wao_mobile/screens/dashboard/dashboard.dart';
import 'package:wao_mobile/screens/scores/livescore_dashboard.dart';
import 'package:wao_mobile/screens/officiates/officiate_dashboard.dart';
import 'package:wao_mobile/screens/teams/teams_dashboard.dart';

import '../Theme/theme_data.dart';
import '../screens/user/user_profile.dart';

class BottomNavBar extends StatefulWidget{
  @override
  State<BottomNavBar> createState() => BottomNavBarState();

}

class BottomNavBarState extends State<BottomNavBar>{
  int currentIndex = 0;
  List pages =  [
    const DashboardHome(title: '',),
    const LiveScoresHome(title: '',),
    const OfficiateHome(title: '',),
    UserProfile()
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(

      bottomNavigationBar: SizedBox(
        height: 80.0,

        child: BottomNavigationBar(
            selectedItemColor: Colors.white ,
            unselectedItemColor: const Color(0xffadb5bd),
            onTap: (index){
              setState((){
                currentIndex = index;
              });
            },
            currentIndex: currentIndex,items:const [
              BottomNavigationBarItem(icon: Icon(Icons.home, size:35.0), label: 'Home',
                backgroundColor: Color(0xff011E41), ),
              BottomNavigationBarItem(icon: Icon(Icons.leaderboard,size:35.0), label: 'Score'),
              BottomNavigationBarItem(icon: Icon(Icons.supervisor_account, size:35.0), label:'Officiate'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle, size:35.0), label:' Score' ),
            ],
          ),
      ),
        body: pages[currentIndex]
    );
  }

}