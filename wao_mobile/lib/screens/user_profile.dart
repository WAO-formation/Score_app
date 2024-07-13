import 'package:flutter/material.dart';
import '../custom_widgets/Welcome_box.dart';
import '../custom_widgets/custom_appbar.dart';


class UserProfile extends StatefulWidget {
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
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 50.0),
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
              const Center(
                child: Text(
                  'WAO Sport',
                  style: TextStyle(
                    color: Color(0xff011638),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 50.0),

              const ProfileButtons(
                pageName: 'Profile',
                iconName: Icons.person,
              ),
              const SizedBox(height: 20.0),

              const ProfileButtons(
                pageName: 'Team',
                iconName: Icons.people,
              ),
              const SizedBox(height: 20.0),

              const ProfileButtons(
                pageName: 'About',
                iconName: Icons.book,
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
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Color(0xff011638),
            ),
          ),
          Icon(
            iconName,
            size: 35.0,
            color: const Color(0xff011638),
          ),
        ],
      ),
    );
  }
}
