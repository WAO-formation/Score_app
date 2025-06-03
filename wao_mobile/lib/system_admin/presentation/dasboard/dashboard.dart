import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/dashboard/widgets/liveMatches.dart';
import 'package:wao_mobile/presentation/dashboard/widgets/ranking.dart';

import '../../../presentation/dashboard/widgets/up_coming _matches.dart';
import '../../../shared/custom_appbar.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/theme_data.dart';
import '../score_board/model/live_score.dart';
import '../Teams/model/team_model.dart';
import '../Teams/view/teams_details.dart';
import '../match_sheduling/models/match_models.dart';
import '../team_list/view/team_list.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key, required this.title,  this.teamValue});

  final Teams? teamValue;
  final String title;

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // User profile section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30.0,
                      backgroundImage: AssetImage("assets/images/teams.jpg"),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Hi Afanyu",
                            style: AppStyles.secondaryTitle.copyWith(fontSize: 18.0)
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                            'Lets Play WAO',
                            style: AppStyles.informationText.copyWith(
                                color: Colors.grey,
                                fontSize: 14.0
                            )
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: const Icon(Icons.notifications_active_outlined, color: Colors.grey),
                )
              ],
            ),

            const SizedBox(height: 20.0),

            // Live matches section
            const LiveMatchesCarousel(),

            const SizedBox(height: 30.0),

            // Upcoming games section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Upcoming Games',
                    style: AppStyles.secondaryTitle
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            const UpcomingGamesCarousel(),

            const SizedBox(height: 30.0),

            // Ranking section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Ranking',
                    style: AppStyles.secondaryTitle
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            const LeagueRanking(),

            const SizedBox(height: 30.0),

            // Teams section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    'Teams',
                    style: AppStyles.secondaryTitle
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            TeamsItems(
              title: 'All Teams',
              teams: Teams.getSampleTeams(),
            )


          ],
        ),
      ),
    );
  }

}



class TeamsItems extends StatelessWidget {
  final String title;
  final List<Teams> teams;

  const TeamsItems({super.key, required this.title, required this.teams});

  @override
  Widget build(BuildContext context) {
    if (teams.isEmpty) {
      return const Center(child: Text('No teams available'));
    }

    return Column(
      children: teams.map((team) => TeamItem(team: team)).toList(),
    );
  }
}



class TeamItem extends StatelessWidget {
  final Teams team;

  const TeamItem({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(team.logoUrl),
        ),
        title: Text(team.name),
        subtitle: Text('${team.region} | Score: ${team.totalScore.toStringAsFixed(1)}'),
        trailing: Text('#${team.tablePosition}'),
        onTap: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => TeamDetailsPage(team: team,)));
        },
      ),
    );
  }
}
