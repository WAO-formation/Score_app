import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<TeamViewModel>(
      builder: (context, vm, _) {
        final followedIds = vm.followedTeamIds;

        return SizedBox(
          height: 82,
          child: StreamBuilder<List<WaoTeam>>(
            stream: vm.getAllTeams(),
            builder: (context, snapshot) {
              final allTeams = snapshot.data ?? [];
              final followed = allTeams.where((t) => followedIds.contains(t.id)).toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: followed.length + 1,
                itemBuilder: (context, index) {
                  if (index == followed.length) {
                    return _AddTeamButton(
                      isDark: isDark,
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => TeamSelectorDialog(
                          allTeams: allTeams,
                          followedTeamIds: followedIds,
                        ),
                      ),
                    );
                  }
                  final team = followed[index];
                  return _TeamAvatarItem(
                    team: team,
                    isDark: isDark,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TeamDetails(team: team)),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

// ── Team avatar item ──────────────────────────────────────────────────────────

class _TeamAvatarItem extends StatelessWidget {
  const _TeamAvatarItem({required this.team, required this.isDark, required this.onTap});
  final WaoTeam team;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = team.name.isNotEmpty ? team.name[0].toUpperCase() : 'T';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.waoNavy,
                border: Border.all(
                  color: AppColors.waoNavy.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  initial,
                  style: GoogleFonts.oswald(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              team.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.oswald(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : AppColors.waoNavy.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add team button ───────────────────────────────────────────────────────────

class _AddTeamButton extends StatelessWidget {
  const _AddTeamButton({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : AppColors.waoNavy.withOpacity(0.06),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withOpacity(0.15)
                      : AppColors.waoNavy.withOpacity(0.2),
                  width: 1.5,
                  style: BorderStyle.solid,
                ),
              ),
              child: Icon(
                Icons.add_rounded,
                size: 22,
                color: isDark ? Colors.white54 : AppColors.waoNavy.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Follow',
              style: GoogleFonts.oswald(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
