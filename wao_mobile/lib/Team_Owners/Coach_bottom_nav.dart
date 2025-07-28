import 'package:flutter/material.dart';
import 'package:wao_mobile/Team_Owners/profile/profile.dart';
import 'package:wao_mobile/Team_Owners/team_members/team_members.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import 'Home/home_screen.dart';
import 'chats/chats_list.dart';



class CoachBottomNavBar extends StatefulWidget{
  const CoachBottomNavBar({super.key});

  @override
  State<CoachBottomNavBar> createState() => CoachBottomNavBarState();

}

class CoachBottomNavBarState extends State<CoachBottomNavBar>{
  int currentIndex = 0;
  List pages =  [
    const TeamCoachHome(),
    const TeamManagementScreen(),
    const ChatListScreen(),
    const CoachProfilePage(),
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


            type: BottomNavigationBarType.fixed,


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
                icon: Icon(Icons.people_alt, size: 30.0),
                label: 'Players',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble, size: 30.0),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, size: 30.0),
                label: 'Profile',
              ),
            ],
          ),
        ),

        body: pages[currentIndex]
    );
  }

}