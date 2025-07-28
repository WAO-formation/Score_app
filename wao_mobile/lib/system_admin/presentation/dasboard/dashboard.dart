import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/dashboard/widgets/liveMatches.dart';
import 'package:wao_mobile/presentation/dashboard/widgets/ranking.dart';
import 'package:wao_mobile/system_admin/presentation/dasboard/widgets/drawer.dart';

import '../../../presentation/dashboard/widgets/up_coming _matches.dart';
import '../../../shared/custom_appbar.dart';
import '../../../shared/custom_text.dart';
import '../score_board/model/live_score.dart';
import '../Teams/view/teams_details.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key, required this.title, this.teamValue});

  final Teams? teamValue;
  final String title;

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  bool _showMainDashboard = true;

  // Create placeholder pages for drawer navigation
  final List<Widget> _adminPages = [
    const NotificationPagePlaceholder(),
    const UsersPagePlaceholder(),
    const ChangePasswordPagePlaceholder(),
  ];

  final List<String> _pageTitles = [
    'Notifications',
    'Users Management',
    'Change Password',
  ];

  void _onDrawerItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      _showMainDashboard = false;
    });
    Navigator.pop(context);
  }

  void _showDashboard() {
    setState(() {
      _showMainDashboard = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _showMainDashboard ? 'Dashboard' : _pageTitles[_selectedIndex],
        // Add back button for admin pages
        leading: !_showMainDashboard
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: _showDashboard,
        )
            : null,
      ),
      drawer: AdminDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: _onDrawerItemSelected,
        onDashboardSelected: _showDashboard,
      ),
      body: _showMainDashboard ? _buildMainDashboard() : _adminPages[_selectedIndex],
    );
  }

  Widget _buildMainDashboard() {
    return SingleChildScrollView(
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
                  // Fixed: Use Builder to get the correct context
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        // Open drawer using the correct context
                        Scaffold.of(context).openDrawer();
                      },
                      child: const CircleAvatar(
                        radius: 30.0,
                        backgroundImage: AssetImage("assets/images/teams.jpg"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Hi Afanyu",
                          style: AppStyles.secondaryTitle.copyWith(fontSize: 18.0)),
                      const SizedBox(height: 5.0),
                      Text('Lets Play WAO',
                          style: AppStyles.informationText.copyWith(
                              color: Colors.grey, fontSize: 14.0)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(50)),
                child: const Icon(Icons.notifications_active_outlined,
                    color: Colors.grey),
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
              Text('Upcoming Games', style: AppStyles.secondaryTitle),
            ],
          ),
          const SizedBox(height: 10.0),

          const UpcomingGamesCarousel(),

          const SizedBox(height: 30.0),

          // Ranking section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ranking', style: AppStyles.secondaryTitle),
            ],
          ),
          const SizedBox(height: 10.0),

          const LeagueRanking(),

          const SizedBox(height: 30.0),

          // Teams section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Teams', style: AppStyles.secondaryTitle),
            ],
          ),
          const SizedBox(height: 10.0),

          TeamsItems(
            title: 'All Teams',
            teams: Teams.getSampleTeams(),
          )
        ],
      ),
    );
  }
}

// Placeholder pages until you implement the actual admin pages
class NotificationPagePlaceholder extends StatelessWidget {
  const NotificationPagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Notifications Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'This page will contain notification management',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class UsersPagePlaceholder extends StatelessWidget {
  const UsersPagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Users Management Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'This page will contain user management functionality',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class ChangePasswordPagePlaceholder extends StatelessWidget {
  const ChangePasswordPagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Change Password Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'This page will contain password change functionality',
            style: TextStyle(color: Colors.grey),
          ),
        ],
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(team.logoUrl),
        ),
        title: Text(team.name),
        subtitle: Text('${team.region} | Score: ${team.totalScore.toStringAsFixed(1)}'),
        trailing: Text('#${team.tablePosition}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeamDetailsPage(team: team),
            ),
          );
        },
      ),
    );
  }
}