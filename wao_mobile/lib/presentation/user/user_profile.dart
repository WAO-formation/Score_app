import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/user/howt_to_play.dart';
import 'package:wao_mobile/presentation/user/wao_privacy_policy.dart';
import 'package:wao_mobile/presentation/user/wao_rules.dart';

import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/custom_text.dart';
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
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            children: <Widget>[

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

              const SizedBox(height: 20.0),

              _buildProfileItems(icon: Icons.book_rounded, title: 'About', onTap: () { 
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => const AboutPage())
                );
              }),

              const SizedBox(height: 20.0),

              _buildProfileItems(icon: Icons.list, title: 'Game Rules', onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const GameRules()));
              }),


              const SizedBox(height: 20.0),

              _buildProfileItems(icon: Icons.sports_basketball_rounded, title: 'How To Play WAO', onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HowToPlayWAO()));
              }),


              const SizedBox(height: 20.0),

              _buildProfileItems(icon: Icons.shield_outlined, title: 'Privacy Policy', onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()));
              }),

              const SizedBox(height: 20.0),

              _buildProfileItems(icon: Icons.logout_outlined, title: 'Logout', onTap: () {  }),
              const SizedBox(height: 20.0),

            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProfileItems({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }){
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 25.0, color: lightColorScheme.secondary),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppStyles.informationText,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          const Divider(thickness: 1.1,),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

