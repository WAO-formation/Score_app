import 'package:flutter/material.dart';

import 'package:wao_mobile/presentation/dashboard/dashboard.dart';
import 'package:wao_mobile/presentation/officiates/officiate_dashboard.dart';

import 'package:wao_mobile/shared/theme_data.dart';
import '../presentation/user/user_profile.dart';

class BottomNavBar extends StatefulWidget{
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => BottomNavBarState();

}

class BottomNavBarState extends State<BottomNavBar>{
  int currentIndex = 0;
  List pages =  [
    const DashboardHome(title: '',),
    const OfficiateHome(),
    UserProfile()
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

          const BottomNavigationBarItem(icon: Icon(Icons.supervisor_account, size:35.0), label:'Officiate'),

          const BottomNavigationBarItem(icon: Icon(Icons.account_circle, size:35.0), label:' Profile' ),
            ],
          ),
      ),
        body: pages[currentIndex]
    );
  }

}