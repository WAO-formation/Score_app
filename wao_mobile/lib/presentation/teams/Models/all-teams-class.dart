import 'package:flutter/material.dart';
import 'package:wao_mobile/screens/teams/Models/teamModel.dart';

import '../../../Theme/theme_data.dart';
import '../teams_dashboard.dart';

class AllTeamsList extends StatelessWidget {
  const AllTeamsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: teams.map((teams) {
          return TeamsCart(teams: teams);
        }).toList(),
      ),
    );
  }
}

class TeamsCart extends StatelessWidget {
  final teamproperties teams; // Updated this line

  const TeamsCart({super.key, required this.teams});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 15.0),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: screenWidth * 0.8,
            padding: const EdgeInsets.symmetric(
                horizontal: 10.0, vertical: 15.0),
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
                  style: TextStyle(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60.0, vertical: 10.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TeamsHome(
                                  title: '',
                                )));
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
      ),
    );
  }
}
