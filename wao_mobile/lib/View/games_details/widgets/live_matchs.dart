import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';
import 'package:wao_mobile/ViewModel/teams_games/match_viewmodel.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'match_card.dart';

class LiveMatchesSection extends StatelessWidget {
  const LiveMatchesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<MatchViewModel, TeamViewModel>(
      builder: (context, matchViewModel, teamViewModel, child) {
        return StreamBuilder<List<WaoMatch>>(
          stream: matchViewModel.getLiveMatches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox.shrink();
            }

            final liveMatches = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.circle,
                          color: Colors.red,
                          size: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Live Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${liveMatches.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: liveMatches.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final match = liveMatches[index];
                    final followedTeamIds = teamViewModel.followedTeamIds;
                    final isTeamAFollowed = followedTeamIds.contains(match.teamAId);
                    final isTeamBFollowed = followedTeamIds.contains(match.teamBId);

                    return MatchCard(
                      match: match,
                      isTeamAFollowed: isTeamAFollowed,
                      isTeamBFollowed: isTeamBFollowed,
                      onFavoriteTap: () {
                        matchViewModel.toggleMatchFavorite(match.id, match.isFavorite);
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}