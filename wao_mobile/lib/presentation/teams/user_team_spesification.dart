import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/teams/teams_dashboard.dart';

import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';




class userTeamSpecification extends StatefulWidget{
  @override
  State<userTeamSpecification> createState() => userTeamSpecificationState();

}

class userTeamSpecificationState extends State<userTeamSpecification>{
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: lightColorScheme.surface,
        appBar:  CustomAppBar(
          title: 'Teams Specification',
          leading: IconButton(
              icon:  Icon(Icons.arrow_back_rounded, color: lightColorScheme.surface),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ),

        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30.0),
            child: const Column(
                children: [
                  WelcomeToWAO(
                    title: 'WAO Teams',
                  ),

                  //the colors here will be used to differciate the types of teams set the user is involved with.
                  //this include player, follower and following
                  //the reason the following is involved is so that the application will be active
                  //and the spectators will be able to receive notifications about the upcoming event of the teams
                  // their level an success in the team games


                  const SizedBox(height: 30.0),
                  teamSpecification(
                    ImagePath: 'assets/images/officiate.jpg',
                    ButtonColor: Color(0xff1565c0),
                    TeamName: 'Team-A',
                    ButtonName: 'Player',
                  ),

                  const SizedBox(height: 15.0),
                  teamSpecification(
                    ImagePath: 'assets/images/teams.jpg',
                    ButtonColor: Color(0xff4ad66d),
                    TeamName: 'Team-p',
                    ButtonName: 'Following',
                  ),
                  const SizedBox(height: 15.0),

                  teamSpecification(
                    ImagePath: 'assets/images/WAO_LOGO.jpg',
                    ButtonColor: Color(0xffC10230),
                    TeamName: 'Team-S',
                    ButtonName: 'Follow',
                  ),

                  const SizedBox(height: 15.0),


                  teamSpecification(
                    ImagePath: 'assets/images/officiate.jpg',
                    ButtonColor: Color(0xff4ad66d),
                    TeamName: 'Team-W',
                    ButtonName: 'Following',
                  ),

                  const SizedBox(height: 15.0),

                  teamSpecification(
                    ImagePath: 'assets/images/teams.jpg',
                    ButtonColor: Color(0xffC10230),
                    TeamName: 'Team-F',
                    ButtonName: 'Follow',
                  ),

                  const SizedBox(height: 15.0),

                ]
            ),
          ),
        )
    );
  }

}

class teamSpecification extends StatelessWidget{

  final String ImagePath;
  final Color ButtonColor;
  final String TeamName;
  final String ButtonName;

  const teamSpecification({
    super.key,
    required this.ImagePath,
    required this.ButtonColor,
    required this.TeamName,
    required this.ButtonName,

  });


  @override
  Widget build(BuildContext context) {


    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TeamsHome(title: '',))
        );
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: lightColorScheme.surface,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Column(
                  children: [
                    CircleAvatar(
                      radius: 40.0, // Image size
                      backgroundImage: AssetImage(ImagePath),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      TeamName,
                      style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary)
                    ),
                  ]
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 15.0),
                  ),
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TeamsHome(title: '',))
                    );
                  },
                  child:  Text(
                    ButtonName,
                    style: AppStyles.informationText.copyWith(fontSize: 15.0)
                  ),
                ),
              ]
            ),
          ),
      ),
    );
  }

}