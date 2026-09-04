import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/team/wao_player.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/ViewModel/teams_games/player_viewmodel.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

// ── Back button ───────────────────────────────────────────────────────────────

class DetailBackButton extends StatelessWidget {
  const DetailBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
      ),
    );
  }
}

// ── Match type badge ──────────────────────────────────────────────────────────

class MatchTypeBadge extends StatelessWidget {
  const MatchTypeBadge({super.key, required this.type});
  final MatchType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: GoogleFonts.oswald(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ── Team column (logo + name) used in hero card ───────────────────────────────

class HeroTeamColumn extends StatelessWidget {
  const HeroTeamColumn({
    super.key,
    required this.name,
    this.showTrophy = false,
  });
  final String name;
  final bool showTrophy;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'T',
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.oswald(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          if (showTrophy) ...[
            const SizedBox(height: 4),
            const Icon(Icons.emoji_events_rounded, color: AppColors.waoYellow, size: 16),
          ],
        ],
      ),
    );
  }
}

// ── Styled tab bar ────────────────────────────────────────────────────────────

class DetailTabBar extends StatelessWidget {
  const DetailTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    required this.isDark,
  });
  final TabController controller;
  final List<String> tabs;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.06) : AppColors.waoNavy.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppColors.waoNavy.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.waoRed,
          borderRadius: BorderRadius.circular(9),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? Colors.white54 : AppColors.waoNavy.withOpacity(0.5),
        labelStyle: GoogleFonts.oswald(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.oswald(fontSize: 13, fontWeight: FontWeight.w500),
        tabs: tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}

// ── Team selector chips (for players tab) ─────────────────────────────────────

class TeamSelectorChips extends StatelessWidget {
  const TeamSelectorChips({
    super.key,
    required this.teamAName,
    required this.teamBName,
    required this.selectedIndex,
    required this.onSelect,
    required this.isDark,
  });
  final String teamAName, teamBName;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _chip(0, teamAName),
          const SizedBox(width: 10),
          _chip(1, teamBName),
        ],
      ),
    );
  }

  Widget _chip(int index, String label) {
    final selected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onSelect(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.waoRed : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.waoRed : (isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.2)),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.oswald(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : (isDark ? Colors.white54 : AppColors.waoNavy.withOpacity(0.6)),
          ),
        ),
      ),
    );
  }
}

// ── Stat bar row ──────────────────────────────────────────────────────────────

class StatBarRow extends StatelessWidget {
  const StatBarRow({
    super.key,
    required this.label,
    required this.teamAVal,
    required this.teamBVal,
    required this.teamAName,
    required this.teamBName,
    required this.isDark,
  });
  final String label, teamAName, teamBName;
  final int teamAVal, teamBVal;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final aWins = teamAVal > teamBVal;
    final bWins = teamBVal > teamAVal;
    final aFlex = teamAVal == 0 ? 1 : teamAVal;
    final bFlex = teamBVal == 0 ? 1 : teamBVal;

    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.oswald(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : AppColors.waoNavy.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(
                '$teamAVal%',
                textAlign: TextAlign.right,
                style: GoogleFonts.oswald(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: aWins ? AppColors.waoRed : (isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: aFlex,
                    child: Container(
                      height: 7,
                      decoration: BoxDecoration(
                        color: aWins ? AppColors.waoRed : (isDark ? Colors.white12 : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    flex: bFlex,
                    child: Container(
                      height: 7,
                      decoration: BoxDecoration(
                        color: bWins ? AppColors.waoRed : (isDark ? Colors.white12 : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 36,
              child: Text(
                '$teamBVal%',
                textAlign: TextAlign.left,
                style: GoogleFonts.oswald(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: bWins ? AppColors.waoRed : (isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(teamAName, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: GoogleFonts.oswald(fontSize: 10, color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4)),
              ),
            ),
            Expanded(
              child: Text(teamBName, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.right,
                style: GoogleFonts.oswald(fontSize: 10, color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Roster panel ──────────────────────────────────────────────────────────────

class TeamRosterPanel extends StatelessWidget {
  const TeamRosterPanel({super.key, required this.teamId, required this.isDark});
  final String teamId;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WaoTeam?>(
      future: Provider.of<TeamViewModel>(context, listen: false).getTeamById(teamId),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snap.hasData || snap.data == null) {
          return _empty('Team not found', isDark);
        }
        return _PlayersPanel(team: snap.data!, isDark: isDark);
      },
    );
  }

  Widget _empty(String msg, bool isDark) => Padding(
    padding: const EdgeInsets.all(32),
    child: Center(
      child: Text(msg, style: GoogleFonts.oswald(
        fontSize: 14, color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
      )),
    ),
  );
}

class _PlayersPanel extends StatelessWidget {
  const _PlayersPanel({required this.team, required this.isDark});
  final WaoTeam team;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WaoPlayer>>(
      future: _fetchPlayers(team.roster),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final players = snap.data ?? [];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Team header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.waoNavy,
                        border: Border.all(color: AppColors.waoNavy.withOpacity(0.3), width: 2),
                      ),
                      child: Center(
                        child: Text(
                          team.name.isNotEmpty ? team.name[0].toUpperCase() : 'T',
                          style: GoogleFonts.oswald(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(team.name, style: GoogleFonts.oswald(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                    )),
                    const SizedBox(height: 2),
                    Text('Coach: ${team.coach}', style: GoogleFonts.oswald(
                      fontSize: 12, color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.45),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _RoleSection(role: 'Coach', players: [team.coach], isDark: isDark, isCoach: true),
              _RoleSection(role: 'Kings', players: _byRole(players, team.roster.kingIds), isDark: isDark),
              _RoleSection(role: 'Workers', players: _byRole(players, team.roster.workerIds), isDark: isDark),
              _RoleSection(role: 'Protagues', players: _byRole(players, team.roster.protagueIds), isDark: isDark),
              _RoleSection(role: 'Antagues', players: _byRole(players, team.roster.antagueIds), isDark: isDark),
              _RoleSection(role: 'Warriors', players: _byRole(players, team.roster.warriorIds), isDark: isDark),
              _RoleSection(role: 'Sacrificers', players: _byRole(players, team.roster.sacrificerIds), isDark: isDark),
            ],
          ),
        );
      },
    );
  }

  List<WaoPlayer> _byRole(List<WaoPlayer> all, List<String> ids) =>
      all.where((p) => ids.contains(p.id)).toList();

  Future<List<WaoPlayer>> _fetchPlayers(TeamRoster roster) async {
    final svc = PlayerService();
    final result = <WaoPlayer>[];
    for (final id in roster.getAllPlayerIds()) {
      final p = await svc.getPlayerById(id);
      if (p != null) result.add(p);
    }
    return result;
  }
}

class _RoleSection extends StatelessWidget {
  const _RoleSection({required this.role, required this.players, required this.isDark, this.isCoach = false});
  final String role;
  final List<dynamic> players;
  final bool isDark, isCoach;

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              width: 3, height: 16,
              decoration: BoxDecoration(color: AppColors.waoRed, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(width: 8),
            Text(role, style: GoogleFonts.oswald(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.waoNavy, letterSpacing: 0.3,
            )),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.waoRed.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text('${players.length}', style: GoogleFonts.oswald(
                fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.waoRed,
              )),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...players.map((p) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: isCoach ? _CoachCard(name: p as String, isDark: isDark) : _PlayerCard(player: p as WaoPlayer, isDark: isDark),
        )),
      ],
    );
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard({required this.name, required this.isDark});
  final String name;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _PersonCard(
      initial: name.isNotEmpty ? name[0].toUpperCase() : 'C',
      title: name,
      subtitle: 'Head Coach',
      isDark: isDark,
      trailing: const Icon(Icons.verified_rounded, size: 18, color: AppColors.waoYellow),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({required this.player, required this.isDark});
  final WaoPlayer player;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return _PersonCard(
      initial: player.name.isNotEmpty ? player.name[0].toUpperCase() : 'P',
      title: player.name,
      isDark: isDark,
      trailing: Icon(_roleIcon(player.role), size: 16,
        color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.25)),
    );
  }

  IconData _roleIcon(PlayerRole r) {
    switch (r) {
      case PlayerRole.king:       return Icons.emoji_events_rounded;
      case PlayerRole.worker:     return Icons.build_rounded;
      case PlayerRole.protague:   return Icons.shield_rounded;
      case PlayerRole.antague:    return Icons.security_rounded;
      case PlayerRole.warrior:    return Icons.sports_martial_arts_rounded;
      case PlayerRole.sacrificer: return Icons.favorite_rounded;
      case PlayerRole.servitor:   return Icons.support_agent_rounded;
      case PlayerRole.substitute: return Icons.swap_horiz_rounded;
    }
  }
}

class _PersonCard extends StatelessWidget {
  const _PersonCard({
    required this.initial,
    required this.title,
    this.subtitle,
    required this.isDark,
    required this.trailing,
  });
  final String initial, title;
  final String? subtitle;
  final bool isDark;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.07) : AppColors.waoNavy.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.waoNavy),
            child: Center(child: Text(initial, style: GoogleFonts.oswald(
              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
            ))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.oswald(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                )),
                if (subtitle != null)
                  Text(subtitle!, style: GoogleFonts.oswald(
                    fontSize: 11, color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.45),
                  )),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

// ── Pulsing dot ───────────────────────────────────────────────────────────────

class PulsingDot extends StatefulWidget {
  const PulsingDot({super.key, this.color = AppColors.waoRed});
  final Color color;

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    duration: const Duration(milliseconds: 900), vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _anim = Tween(begin: 0.3, end: 1.0).animate(
    CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
  );

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _anim,
    child: Container(width: 6, height: 6,
      decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
  );
}
