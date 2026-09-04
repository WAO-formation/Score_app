import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wao_mobile/View/games_details/games.dart';
import 'package:wao_mobile/View/user/documentation/how_to_play.dart';
import 'package:wao_mobile/View/user/user_profile.dart';

import '../View/dashboard/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const MatchesScreen(),
    const HowToPlayWAO(showBackButton: false),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Lets page content scroll behind the floating bar instead of the
      // bar squeezing the body's height — the point of a floating nav.
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: pages[currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        // Only the bottom inset matters here (home indicator / gesture
        // area); `minimum` adds the actual floating gap on top of it.
        top: false,
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              // Real glass: content scrolling behind (extendBody) gets
              // blurred rather than just tinted, so the bar reads as
              // frosted glass instead of a flat white card.
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 1.2,
                  ),
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  selectedItemColor: const Color(0xFFC81434),
                  unselectedItemColor: Colors.black.withOpacity(0.35),
                  selectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  currentIndex: currentIndex,
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.grid_view_rounded, size: 26),
                      ),
                      activeIcon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.grid_view_rounded, size: 28),
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.stadium_outlined, size: 26),
                      ),
                      activeIcon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.stadium, size: 28),
                      ),
                      label: 'Games',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.sports_handball_outlined, size: 26),
                      ),
                      activeIcon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.sports_handball, size: 28),
                      ),
                      label: 'Rules',
                    ),
                    BottomNavigationBarItem(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.account_circle_outlined, size: 26),
                      ),
                      activeIcon: Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.account_circle, size: 28),
                      ),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}