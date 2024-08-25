import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../presentation/teams/teams_dashboard.dart';
import 'custom_text.dart';




class UpcomingMatches extends StatelessWidget {
  final String teamA;
  final String teamB;
  final String date;
  final String time;
  final String ImagePath1;
  final String ImagePath2;


  const UpcomingMatches({
    Key? key,
    required this.teamA,
    required this.teamB,
    required this.date,
    required this.time,
    required this.ImagePath1,
    required this.ImagePath2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    //in this container we describe the container that will be used to display the upcoming matches in a slider
    return Center(
      child: Container(
        width: screenWidth * 0.9,
        height: screenWidth * 0.6,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenWidth * 0.05),
        decoration: BoxDecoration(
          color: const Color(0xffF8C3D0),
          borderRadius: BorderRadius.circular(20.0), // Adding border radius to the container
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40.0, // Image size
                      backgroundImage: AssetImage(ImagePath1),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      teamA,
                      style: AppStyles.secondaryTitle,
                    ),
                  ],
                ),
                 Text(
                    'VS',
                    style: AppStyles.primaryTitle.copyWith(fontSize: 25.0)
                ),
                Column(
                  children: [
                     CircleAvatar(
                      radius: 40.0, // Image size
                      backgroundImage: AssetImage(ImagePath2),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      teamB,
                      style: AppStyles.secondaryTitle,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              "$date : $time",
              style: AppStyles.primaryTitle.copyWith(fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }
}


// here we have the widget to define the verious teams that are top in the competition
class TopTeams extends StatefulWidget{
  final String teamName;
  final String imagePath;

  const TopTeams({
    super.key,
    required this.teamName,
    required this.imagePath
  });

  @override
  State<TopTeams> createState() => TopTeamsState();
}


// this is for the best performing team in the game

class TopTeamsState extends State<TopTeams> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: screenWidth * 0.9,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01, vertical: screenWidth * 0.02),
        decoration: BoxDecoration(
      color: const Color(0xffdee2e6),
      borderRadius: BorderRadius.circular(20.0),
      ),

        child:  Column(
          children:[
            Image.asset(
                widget.imagePath,
                height: 235.0
            ),

            const SizedBox(height:10.0),
             Text(
              widget.teamName,
              style: AppStyles.secondaryTitle,
            ),
            const SizedBox(height:10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:  lightColorScheme.primary,
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
              child:  Text(
                'Visit Team',
                style: AppStyles.informationText.copyWith(fontSize: 15.0),
              ),
            ),
            const SizedBox(height:5.0)
          ]
        )
      ),
    );
  }
}


// here we have the widget to define the verious teams that are top in the competition
class otherTeams extends StatefulWidget{
   final String teamName;
   final String imagePath;

  const otherTeams({
    super.key,
    required this.teamName,
    required this.imagePath
  });

  @override
  State<otherTeams> createState() => otherTeamsState();
}

class otherTeamsState extends State<otherTeams> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        width: screenWidth * 0.43,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenWidth * 0.02),
        decoration: BoxDecoration(
          color: const Color(0xffdee2e6),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            Image.asset(
              widget.imagePath,
              height: 135.0,
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.teamName,
              style:  TextStyle(
                color: lightColorScheme.secondary,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:lightColorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
              ),
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TeamsHome(title: '',))
                );
              },
              child: const Text(
                'Visit',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
          ],
        ),
      ),
    )
    ;
  }
}