import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/View/games_details/team_details.dart';
import 'package:wao_mobile/View/games_details/widgets/teams_dialog.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class MatchesHeader extends StatelessWidget {
  const MatchesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Text(
            'Matches',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
            ),
          ),
        ),

        // Followed Teams Horizontal Scroll
        Consumer<TeamViewModel>(
          builder: (context, teamViewModel, child) {
            final followedTeamIds = teamViewModel.followedTeamIds;

            return SizedBox(
              height: 90,
              child: StreamBuilder<List<WaoTeam>>(
                stream: teamViewModel.getAllTeams(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  final allTeams = snapshot.data ?? [];
                  final followedTeams = allTeams
                      .where((team) => followedTeamIds.contains(team.id))
                      .toList();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: followedTeams.length + 1,
                    itemBuilder: (context, index) {
                      if (index == followedTeams.length) {
                        return _AddTeamButton(
                          isDarkMode: isDarkMode,
                          onTap: () => _showTeamSelector(context, allTeams, followedTeamIds),
                        );
                      }

                      final team = followedTeams[index];
                      return _TeamAvatarItem(
                        team: team,
                        isDarkMode: isDarkMode,
                        onTap: () => _handleTeamTap(context, team),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _showTeamSelector(BuildContext context, List<WaoTeam> allTeams, Set<String> followedTeamIds) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TeamSelectorDialog(
        allTeams: allTeams,
        followedTeamIds: followedTeamIds,
      ),
    );
  }

  void _handleTeamTap(BuildContext context, WaoTeam team) {
   Navigator.push(context,
   MaterialPageRoute(builder: (context) => TeamDetails(team: team)));
  }
}

class _TeamAvatarItem extends StatelessWidget {
  final WaoTeam team;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _TeamAvatarItem({
    required this.team,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Team Logo
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.waoYellow.withOpacity(0.3),
                  width: 2,
                ),
                image: team.logoUrl.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(team.logoUrl),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: team.logoUrl.isEmpty
                  ? Center(
                child: Text(
                  team.name.isNotEmpty ? team.name[0].toUpperCase() : 'T',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(height: 6),
            // Team Name
            Text(
              team.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddTeamButton extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onTap;

  const _AddTeamButton({
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add Button
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.waoYellow.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.waoYellow,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.waoYellow,
                size: 28,
              ),
            ),
            const SizedBox(height: 6),
            // Label
            Text(
              'Add Team',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}