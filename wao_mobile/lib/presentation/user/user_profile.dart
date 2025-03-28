import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/user/wao_privacy_policy.dart';
import 'package:wao_mobile/presentation/user/wao_rules.dart';

import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/theme_data.dart';
import '../teams/user_team_spesification.dart';
import 'about_dashboard.dart';




class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Profile',
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 30.0),
          child: Column(
            children: <Widget>[
              const WelcomeToWAO(title: 'Welcome To WAO',),
              const SizedBox(height: 30.0),
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(20.0),
                child: const CircleAvatar(
                  radius: 50.0, // Image size
                  backgroundImage: AssetImage('assets/images/WAO_LOGO.jpg'),
                ),
              ),
              const SizedBox(height: 10.0),
               Center(
                child: Text(
                  'WAO Sport',
                  style: TextStyle(
                    color: lightColorScheme.secondary,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 50.0),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>   userTeamSpecification())
                  );
                },
                child: const ProfileButtons(
                  pageName: 'Team',
                  iconName: Icons.people,
                ),
              ),
              const SizedBox(height: 20.0),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutHome())
                  );
                },
                child: const ProfileButtons(
                  pageName: 'About',
                  iconName: Icons.book,
                ),
              ),
              const SizedBox(height: 20.0),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GameRules())
                  );
                },
                child: const ProfileButtons(
                  pageName: 'Rules',
                  iconName: Icons.list,
                ),
              ),
              const SizedBox(height: 20.0),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrivacyPolicy())
                  );
                },
                child: const ProfileButtons(
                  pageName: 'Privacy',
                  iconName: Icons.shield,
                ),
              ),
              const SizedBox(height: 20.0),


              const ProfileButtons(
                pageName: 'Logout',
                iconName: Icons.logout,
              ),
              const SizedBox(height: 20.0),

            ],
          ),
        ),
      ),
    );
  }
}


class ProfileButtons extends StatelessWidget {
  final String pageName;
  final IconData iconName;

  const ProfileButtons({
    super.key,
    required this.pageName,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffced4da),
      ),
      width: screenWidth * 0.9, // Adjust width as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            pageName,
            style:  TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: lightColorScheme.secondary,
            ),
          ),
          Icon(
            iconName,
            size: 35.0,
            color: lightColorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
