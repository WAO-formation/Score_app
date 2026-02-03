import 'package:flutter/material.dart';
import 'package:wao_mobile/provider/Models/teamModel.dart';

import '../../View/teams/teams_dashboard.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';



class TopTeamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: teams.map((teams) {
          return TeamsCart(teams: teams);
        }).toList(),
      ),
    );
  }
}

class TeamsCart extends StatelessWidget {
  final teamproperties teams; // Updated this line

  const TeamsCart({required this.teams});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(left: 15.0),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          width: screenWidth * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: const Color(0xffdee2e6),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              Image.asset(
                teams.image,
                height: 140.0,
                fit: BoxFit.cover,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              const SizedBox(height: 10.0),
              Text(
                teams.teamName,
                style: AppStyles.secondaryTitle
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TeamsHome(title: '',)),
                  );
                },
                child:  Text(
                  'View More',
                  style: AppStyles.informationText.copyWith(fontSize: 15.0)
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
