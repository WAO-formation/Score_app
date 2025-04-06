import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/custom_appbar.dart';

import '../../../shared/custom_text.dart';
import '../../../shared/theme_data.dart';

class GameDetailsPage extends StatelessWidget {
  const GameDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: "Game Details",
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back, color: Colors.white,)),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// Match Header Banner
            _buildMatchHeader(),

            const SizedBox(height: 10.0,),

            /// Game Status Info
            _buildGameStatusInfo(),

            const SizedBox(height: 10.0,),

            /// Teams Player Lineup
            _buildTeamLineups(),

            const SizedBox(height: 10.0,),

            /// Recent Performance Stats
            _buildRecentPerformance(),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xffA7C8FE),
            const Color(0xffA7C8FE).withOpacity(0.85),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
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
                  "WAO! Sport League",
                  style: AppStyles.informationText.copyWith(
                    color: lightColorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Team A
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 40.0,
                      backgroundImage: AssetImage("assets/images/teams.jpg"),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "Team Alpha",
                    style: AppStyles.secondaryTitle.copyWith(
                      color: lightColorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // VS and Time
              Column(
                children: [
                  Text(
                    "VS",
                    style: AppStyles.secondaryTitle.copyWith(
                      color: lightColorScheme.error,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "15:30",
                      style: AppStyles.informationText.copyWith(
                        color: lightColorScheme.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              // Team B
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 40.0,
                      backgroundImage: AssetImage("assets/images/teams.jpg"),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    "Team Beta",
                    style: AppStyles.secondaryTitle.copyWith(
                      color: lightColorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameStatusInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          Text(
            "Game Info",
            style: AppStyles.primaryTitle.copyWith(
              fontSize: 18,
              color: lightColorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Date
          _buildInfoRow(
            Icons.calendar_today,
            "Date",
            "April 15, 2025",
          ),
          const Divider(height: 24),

          // Time
          _buildInfoRow(
            Icons.access_time,
            "Kick-off Time",
            "15:30",
          ),
          const Divider(height: 24),

          // Venue
          _buildInfoRow(
            Icons.location_on,
            "Venue",
            "Central Stadium",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: lightColorScheme.secondary,
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppStyles.informationText.copyWith(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: AppStyles.informationText.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildTeamLineups() {

    /// Static player data with specialized roles for both teams
    final teamAPlayers = [
      {'name': 'John Smith', 'role': 'King', 'number': '1'},
      {'name': 'David Chen', 'role': 'Protaque', 'number': '3'},
      {'name': 'Michael Rodriguez', 'role': 'Antaque', 'number': '4'},
      {'name': 'James Wilson', 'role': 'Warrior', 'number': '8'},
      {'name': 'Robert Johnson', 'role': 'Worker', 'number': '10'},
      {'name': 'Lucas Parker', 'role': 'Servitor', 'number': '6'},
      {'name': 'Connor White', 'role': 'Sacrificer', 'number': '11'},
    ];

    final teamBPlayers = [
      {'name': 'Thomas Brown', 'role': 'King', 'number': '1'},
      {'name': 'Daniel Williams', 'role': 'Protaque', 'number': '2'},
      {'name': 'Christopher Davis', 'role': 'Antaque', 'number': '6'},
      {'name': 'Anthony Martinez', 'role': 'Warrior', 'number': '11'},
      {'name': 'Kevin Taylor', 'role': 'Worker', 'number': '9'},
      {'name': 'Eric Thompson', 'role': 'Servitor', 'number': '5'},
      {'name': 'Brandon Lee', 'role': 'Sacrificer', 'number': '7'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Team Rosters",
            style: AppStyles.primaryTitle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Team A Players
          _buildTeamPlayersSection("Team Alpha", teamAPlayers),
          const SizedBox(height: 24),

          // Team B Players
          _buildTeamPlayersSection("Team Beta", teamBPlayers),
        ],
      ),
    );
  }

  Widget _buildTeamPlayersSection(String teamName, List<Map<String, String>> players) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16.0,
                backgroundImage: AssetImage("assets/images/teams.jpg"),
              ),
              const SizedBox(width: 10),
              Text(
                teamName,
                style: AppStyles.secondaryTitle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Group players by role categories
          _buildRoleGroupPlayers('Leadership',
              players.where((p) => p['role'] == 'King' || p['role'] == 'Protaque').toList()),
          const SizedBox(height: 16),

          _buildRoleGroupPlayers('Offense',
              players.where((p) => p['role'] == 'Antaque' || p['role'] == 'Warrior').toList()),
          const SizedBox(height: 16),

          _buildRoleGroupPlayers('Support',
              players.where((p) => p['role'] == 'Worker' || p['role'] == 'Servitor' || p['role'] == 'Sacrificer').toList()),
        ],
      ),
    );
  }

  Widget _buildRoleGroupPlayers(String groupName, List<Map<String, String>> players) {
    if (players.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: lightColorScheme.secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            groupName,
            style: TextStyle(
              color: lightColorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...players.map((player) => _buildPlayerCard(player)),
      ],
    );
  }

  Widget _buildPlayerCard(Map<String, String> player) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [

            /// Player Avatar with Role Badge
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: const AssetImage("assets/images/teams.jpg"),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _getRoleColor(player['role']!),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      player['number']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            /// Player Name and Role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _getRoleColor(player['role']!).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      player['role']!,
                      style: TextStyle(
                        color: _getRoleColor(player['role']!),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'King':
        return Colors.purple;
      case 'Protaque':
        return Colors.blue;
      case 'Antaque':
        return Colors.red;
      case 'Warrior':
        return Colors.orange;
      case 'Worker':
        return Colors.green;
      case 'Servitor':
        return Colors.teal;
      case 'Sacrificer':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRecentPerformance() {
    // Static performance data
    final teamAPerformance = {'wins': 3, 'draws': 1, 'losses': 1};
    final teamBPerformance = {'wins': 2, 'draws': 2, 'losses': 1};

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Performance",
            style: AppStyles.primaryTitle.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Column(
            children: [

               _buildPerformanceCard(
                  "Team Alpha",
                  teamAPerformance['wins']!,
                  teamAPerformance['draws']!,
                  teamAPerformance['losses']!,
                ),

              const SizedBox(height: 20.0),

              // Team B Performance
             _buildPerformanceCard(
                  "Team Beta",
                  teamBPerformance['wins']!,
                  teamBPerformance['draws']!,
                  teamBPerformance['losses']!,
                ),

            ],
          ),

          const SizedBox(height: 24),

          // Last 5 games visualization
          _buildLastGamesVisualization(),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(String teamName, int wins, int draws, int losses) {
    final total = wins + draws + losses;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 12.0,
                backgroundImage: AssetImage("assets/images/teams.jpg"),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  teamName,
                  style: AppStyles.informationText.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Performance stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('W', wins.toString(), Colors.green),
              _buildStatItem('D', draws.toString(), Colors.amber),
              _buildStatItem('L', losses.toString(), Colors.red),
            ],
          ),

          const SizedBox(height: 12),

          // Win percentage
          LinearProgressIndicator(
            value: wins / (total > 0 ? total : 1),
            backgroundColor: Colors.grey[200],
            color: Colors.green,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            'Win rate: ${((wins / (total > 0 ? total : 1)) * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLastGamesVisualization() {
    /// Static game results: W = Win, D = Draw, L = Loss

    final teamALastGames = ['W', 'W', 'L', 'D', 'W'];
    final teamBLastGames = ['W', 'D', 'D', 'L', 'W'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Last 5 Games",
            style: AppStyles.informationText.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),

          // Team A last games
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  "Team Alpha",
                  style: AppStyles.informationText.copyWith(
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              ...teamALastGames.map((result) => _buildResultIndicator(result)),
            ],
          ),

          const SizedBox(height: 16),

          // Team B last games
          Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  "Team Beta",
                  style: AppStyles.informationText.copyWith(
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              ...teamBLastGames.map((result) => _buildResultIndicator(result)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultIndicator(String result) {
    Color color;
    switch (result) {
      case 'W':
        color = Colors.green;
        break;
      case 'D':
        color = Colors.amber;
        break;
      case 'L':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        result,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}