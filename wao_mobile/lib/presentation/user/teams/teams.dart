import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/custom_appbar.dart';
import '../../../shared/theme_data.dart';
import 'models/teams_models.dart';
import 'models/teams_provider.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  bool isLoading = true;
  late TeamProvider _teamProvider;

  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _teamProvider = Provider.of<TeamProvider>(context, listen: false);


    if (isLoading) {
      _loadTeams();
    }
  }

  Future<void> _loadTeams() async {
    try {
      await _teamProvider.fetchTeams();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading teams: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Teams',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),


      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<TeamProvider>(
        builder: (context, teamProvider, child) {
          final teams = teamProvider.teams;
          final primaryTeam = teamProvider.primaryTeam;

          return CustomScrollView(
            slivers: [
              if (primaryTeam != null)
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              decoration: BoxDecoration(
                                color: lightColorScheme.secondary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Your Primary Team',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildTeamCard(
                        team: primaryTeam,
                        isPrimaryTeam: true,
                        isFollowing: true,
                        teamProvider: teamProvider,
                      ),
                      const Divider(thickness: 1, height: 32),
                    ],
                  ),
                ),

              // Header for all teams
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: lightColorScheme.secondary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'All Teams',
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // List all teams
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final team = teams[index];
                      if (primaryTeam != null && team.id == primaryTeam.id) {
                        return const SizedBox.shrink();
                      }

                      return _buildTeamCard(
                        team: team,
                        isPrimaryTeam: false,
                        isFollowing: teamProvider.isFollowingTeam(team.id),
                        teamProvider: teamProvider,
                      );
                    },
                    childCount: teams.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTeamCard({
    required Team team,
    required bool isPrimaryTeam,
    required bool isFollowing,
    required TeamProvider teamProvider,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Team Logo
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: team.logoUrl != null && team.logoUrl!.isNotEmpty
                  ? NetworkImage(team.logoUrl!)
                  : const AssetImage('assets/images/WAO_LOGO.jpg') as ImageProvider,
            ),
            const SizedBox(width: 16),

            // Team Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        team.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: lightColorScheme.secondary,
                        ),
                      ),
                      if (isPrimaryTeam)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: lightColorScheme.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Primary',
                            style: TextStyle(
                              color: lightColorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    team.description ?? 'No description available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Follow/Unfollow Button
            if (!isPrimaryTeam)
              ElevatedButton(
                onPressed: () {
                  if (isFollowing) {
                    teamProvider.unfollowTeam(team.id);
                  } else {
                    teamProvider.followTeam(team.id);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFollowing ? Colors.grey[200] : lightColorScheme.primary,
                  foregroundColor: isFollowing ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  isFollowing ? 'Unfollow' : 'Follow',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}