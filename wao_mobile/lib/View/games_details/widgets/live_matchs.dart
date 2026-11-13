import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<MatchViewModel, TeamViewModel>(
      builder: (context, matchViewModel, teamViewModel, _) {
        return StreamBuilder<List<WaoMatch>>(
          stream: matchViewModel.getLiveMatches(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();

            final liveMatches = snapshot.data!;
            final followedIds = teamViewModel.followedTeamIds;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header with pulsing red accent
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.waoRed,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Live Now',
                        style: GoogleFonts.oswald(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.waoNavy,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.waoRed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${liveMatches.length}',
                          style: GoogleFonts.oswald(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final m = liveMatches[i];
                    return MatchCard(
                      match: m,
                      isTeamAFollowed: followedIds.contains(m.teamAId),
                      isTeamBFollowed: followedIds.contains(m.teamBId),
                      onFavoriteTap: () =>
                          matchViewModel.toggleMatchFavorite(m.id, m.isFavorite),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }
}
