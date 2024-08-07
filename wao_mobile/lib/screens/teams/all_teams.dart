import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wao_mobile/screens/teams/teams_dashboard.dart';

import '../../Theme/theme_data.dart';
import '../../custom_widgets/Welcome_box.dart';
import '../../custom_widgets/custom_appbar.dart';

class allTeams extends StatefulWidget{
  @override
  State<allTeams> createState() => allTeamsState();

}

class allTeamsState extends State<allTeams>{
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: Colors.white,
        appBar:  CustomAppBar(
          title: 'All Teams',
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ),

        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50.0),
            child: const Column(
                children: [
                  WelcomeToWAO(
                    title: 'WAO Teams',
                  ),

                  const SizedBox(height: 30.0),

                  teams(
                    teamName: 'Team A',
                    imagePath: 'assets/images/teams.jpg',
                  ),
                  const SizedBox(height: 20.0),

                  teams(
                    teamName: 'Team G',
                    imagePath: 'assets/images/officiate.jpg',
                  ),
                  const SizedBox(height: 20.0),

                  teams(
                    teamName: 'Team A',
                    imagePath: 'assets/images/teams.jpg',
                  ),
                  const SizedBox(height: 20.0),

                  teams(
                    teamName: 'Team G',
                    imagePath: 'assets/images/officiate.jpg',
                  ),
                  const SizedBox(height: 20.0),

                ]
            ),
          ),
        )
    );
  }

}

class teams extends StatelessWidget{
  final String teamName;
  final String imagePath;

  const teams({
    super.key,
    required this.teamName,
    required this.imagePath
  });


  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: screenWidth * 0.9,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenWidth * 0.02),
          decoration: BoxDecoration(
            color: const Color(0xffdee2e6),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              Image.asset(
                imagePath,
                height: 140.0,
                fit: BoxFit.cover,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 10.0),
              Text(
                teamName,
                style:  TextStyle(
                  color: lightColorScheme.secondary,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightColorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                ),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TeamsHome(title: '',))
                  );
                },
                child: const Text(
                  'View More',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }

}