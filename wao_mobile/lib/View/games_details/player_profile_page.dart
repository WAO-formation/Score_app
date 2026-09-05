import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wao_mobile/Model/teams_games/team/wao_player.dart';
import 'package:wao_mobile/View/games_details/widgets/match_history_list.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

/// Open to anyone who can already see the roster (any signed-in user, per
/// firestore.rules' `players` read rule) — not gated to the player
/// themselves, a coach, or any particular role.
class PlayerProfilePage extends StatelessWidget {
  const PlayerProfilePage({super.key, required this.player});
  final WaoPlayer player;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : AppColors.waoNavy.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : AppColors.waoNavy.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: isDark ? Colors.white : AppColors.waoNavy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Player Profile',
                    style: GoogleFonts.oswald(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileHeader(player: player, isDark: isDark),
                    const SizedBox(height: 24),
                    _SectionHeading(title: 'Stats', isDark: isDark),
                    const SizedBox(height: 12),
                    _StatsCard(player: player, isDark: isDark),
                    const SizedBox(height: 24),
                    if (player.currentTeamId != null) ...[
                      _SectionHeading(title: 'Match History', isDark: isDark),
                      const SizedBox(height: 12),
                      MatchHistoryList(
                        teamId: player.currentTeamId!,
                        isDark: isDark,
                        emptyLabel: '${player.currentTeamName ?? 'This team'} hasn\'t played a finished game yet',
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.player, required this.isDark});
  final WaoPlayer player;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.waoNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.waoRed),
            child: Center(
              child: Text(
                player.name.isNotEmpty ? player.name[0].toUpperCase() : 'P',
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: GoogleFonts.oswald(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  player.currentTeamName ?? 'Unassigned',
                  style: const TextStyle(fontSize: 13, color: Colors.white54),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Chip(label: _roleLabel(player.role)),
                    const SizedBox(width: 8),
                    if (player.jerseyNumber != null) _Chip(label: '#${player.jerseyNumber}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _roleLabel(PlayerRole role) {
    switch (role) {
      case PlayerRole.king: return 'King';
      case PlayerRole.worker: return 'Worker';
      case PlayerRole.protague: return 'Protague';
      case PlayerRole.antague: return 'Antague';
      case PlayerRole.warrior: return 'Warrior';
      case PlayerRole.sacrificer: return 'Sacrificer';
      case PlayerRole.servitor: return 'Servitor';
      case PlayerRole.substitute: return 'Substitute';
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.oswald(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.player, required this.isDark});
  final WaoPlayer player;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Stat(label: 'Games Played', value: '${player.gamesPlayed}', isDark: isDark),
              const SizedBox(width: 24),
              if (player.age != null) _Stat(label: 'Age', value: '${player.age}', isDark: isDark),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Individual goals/points aren\'t tracked yet — WAO scoring is '
            'logged per zone (Kingdom, Workout, Oval-Crown, Judges) for the '
            'whole team, not attributed to one player.',
            style: TextStyle(
              fontSize: 11.5,
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, required this.isDark});
  final String label, value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.oswald(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.waoNavy,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.isDark});
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(color: AppColors.waoRed, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.oswald(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.waoNavy,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

BoxDecoration _cardDecor(bool isDark) => BoxDecoration(
      color: isDark ? AppColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isDark ? Colors.white.withOpacity(0.08) : AppColors.waoNavy.withOpacity(0.08),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
