import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/View/user/profile/edit_profile.dart';
import 'package:wao_mobile/View/user/teams/models/teams_provider.dart';
import 'package:wao_mobile/View/user/teams/teams.dart';

import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';
import '../authentication/login.dart';
import 'documentation/about_dashboard.dart';
import 'contact_us/contact_us.dart';
import 'documentation/howt_to_play.dart';
import 'documentation/wao_privacy_policy.dart';
import 'documentation/wao_rules.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {

    if (_scrollController.offset > 140 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <= 140 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Use a transparent AppBar that changes based on scroll position
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: _showAppBarTitle ? 2 : 0,
        scrolledUnderElevation: 0,
        backgroundColor: _showAppBarTitle ? lightColorScheme.secondary : Colors.transparent,
        title: AnimatedOpacity(
          opacity: _showAppBarTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: Text(
            'Profile',
            style: TextStyle(
              color: lightColorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [


          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 70,
                  bottom: 30
              ),
              decoration: BoxDecoration(
                color: lightColorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [


                  Hero(
                    tag: 'profile-image',
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: lightColorScheme.onPrimary.withOpacity(0.5),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/WAO_LOGO.jpg'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),


                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: lightColorScheme.onPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'johndoe@gmail.com',
                    style: TextStyle(
                      color: lightColorScheme.onPrimary.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20.0,),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          radius: 14.0,
                          backgroundImage: AssetImage("assets/images/WAO_LOGO.jpg"),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "Team A",
                          style: AppStyles.informationText.copyWith(
                            color: lightColorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),

          // Section Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 15),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: lightColorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [

                  _buildProfileItem(
                    icon: Icons.person_2_outlined,
                    title: 'Profile',
                    subtitle: 'View and edit details',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                    },
                  ),
                  _buildDivider(),

                  _buildProfileItem(
                    icon: Icons.people,
                    title: 'Teams',
                    subtitle: 'See your favourite team',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (_) => TeamProvider(),
                            child: const TeamsPage(),
                          ),
                        ),
                      );
                    },
                  ),


                  _buildDivider(),

                  _buildProfileItem(
                    icon: Icons.book_rounded,
                    title: 'About',
                    subtitle: 'Learn about WAO',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const AboutPage()));
                    },
                  ),


                  _buildDivider(),

                  _buildProfileItem(
                    icon: Icons.list_alt_rounded,
                    title: 'Game Rules',
                    subtitle: 'Official game regulations',
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const GameRules()));
                    },
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.sports_basketball_rounded,
                    title: 'How To Play WAO',
                    subtitle: 'Tips and tutorials',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HowToPlayWAO()));
                    },
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.shield_rounded,
                    title: 'Privacy Policy',
                    subtitle: 'Your Model protection',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrivacyPolicy()));
                    },
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.call,
                    title: 'Contact Us',
                    subtitle: 'Call us for any worries',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ContactUsPage()));
                    },
                  ),
                ],
              ),
            ),
          ),

          // Logout Button
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        'Logout',
                        style: AppStyles.secondaryTitle,
                      ),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red[600]),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen())
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightColorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white)
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red[700],
                  elevation: 1,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.red.shade200),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.red[700]),
                    const SizedBox(width: 10),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Version Info
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Version 1.0.2',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: lightColorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 22, color: lightColorScheme.secondary),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        color: lightColorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, thickness: 1, color: Colors.grey[200]),
    );
  }
}