import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/Team_Owners/Home/widgets/past%20games.dart';
import 'package:wao_mobile/Team_Owners/Home/widgets/upcoming_games.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../presentation/dashboard/widgets/ranking.dart';
import '../../presentation/user/teams/models/teams_models.dart';
import '../../provider/Models/coach_model.dart';
import '../../shared/custom_text.dart';
import '../../system_admin/presentation/Teams/view/widgets/team_classes.dart';
import '../../system_admin/presentation/score_board/model/live_score.dart';

class TeamCoachHome extends StatelessWidget {
  final List<Teams>? teams; // Renamed for clarity

  const TeamCoachHome({super.key, this.teams});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> upcomingGamesList = upcomingGames ?? [];
    int teamCount = upcomingGamesList.length;

    // Get the first team or create a sample team for match history
    Teams? currentTeam = _getCurrentTeam() as Teams?;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 20.0),
            _buildQuickStats(),
            const SizedBox(height: 20.0),
            _buildUpcomingMatches(upcomingGamesList, teamCount),
            const SizedBox(height: 20.0),
            _buildRankingSection(),
            const SizedBox(height: 20.0),
            _buildMatchHistorySection(currentTeam),
          ],
        ),
      ),
    );
  }

  Object? _getCurrentTeam() {
    if (teams != null && teams!.isNotEmpty) {
      return teams!.first; // Use the first team
    }


    final sampleTeams = Teams.getSampleTeams();
    if (sampleTeams.isNotEmpty) {
      return sampleTeams.first;
    } else if (sampleTeams is Teams) {
      return sampleTeams;
    }

    return null;
  }

  Widget _buildHeader() {
    return Row(
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
                  style: AppStyles.secondaryTitle.copyWith(fontSize: 18.0),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Lets Play WAO',
                  style: AppStyles.informationText.copyWith(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.notifications_active_outlined,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: lightColorScheme.secondary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Stats",
            style: AppStyles.secondaryTitle.copyWith(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: buildStatCard(title: 'Games Won', value: '10')),
              const SizedBox(width: 5),
              Expanded(child: buildStatCard(title: 'Games Lost', value: '2')),
              const SizedBox(width: 5),
              Expanded(child: buildStatCard(title: 'Total Played', value: '12')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingMatches(List<dynamic> upcomingGamesList, int teamCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upcoming Matches ($teamCount)",
          style: AppStyles.secondaryTitle.copyWith(fontSize: 18.0),
        ),
        const SizedBox(height: 5.0),
        if (upcomingGamesList.isEmpty)
          _buildEmptyUpcomingMatches()
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: upcomingGamesList.map<Widget>((game) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                    width: 320,
                    child: UpcomingGameCard(game: game),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyUpcomingMatches() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.sports_soccer,
              size: 40,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 10),
            Text(
              'No upcoming matches',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ranking",
          style: AppStyles.secondaryTitle.copyWith(fontSize: 18.0),
        ),
        const SizedBox(height: 10.0),
        const LeagueRanking(),
      ],
    );
  }

  Widget _buildMatchHistorySection(Teams? currentTeam) {
    if (currentTeam == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 40,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 10),
              Text(
                'No team data available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return MatchHistory(team: currentTeam);
  }

  /// Quick stats card
  Widget buildStatCard({
    required String title,
    required String value,
    Color backgroundColor = Colors.white12,
    Color textColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppStyles.informationText.copyWith(
              fontSize: 14.0,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: AppStyles.secondaryTitle.copyWith(
              fontSize: 24.0,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}