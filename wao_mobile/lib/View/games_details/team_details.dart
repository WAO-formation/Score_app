import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'package:wao_mobile/core/widgets/wao_toast.dart';
import '../../Model/teams_games/team/wao_player.dart';
import '../../Model/teams_games/team/team_stat.dart';
import '../../ViewModel/teams_games/player_viewmodel.dart';
import '../../ViewModel/teams_games/team_viewmodel.dart';
import '../dashboard/widgets/folow_button.dart';

class TeamDetails extends StatefulWidget {
  const TeamDetails({super.key, required this.team});
  final WaoTeam team;

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _isFollowing = false;
  bool _loadingFollow = false;
  TeamStatistics? _stats;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<TeamViewModel>(context, listen: false);
      setState(() => _isFollowing = vm.isFollowingTeam(widget.team.id));
      vm.getTeamStatistics(widget.team.id).listen((s) {
        if (mounted) setState(() => _stats = s);
      });
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _toggleFollow() async {
    if (_loadingFollow) return;
    setState(() => _loadingFollow = true);
    try {
      final vm = Provider.of<TeamViewModel>(context, listen: false);
      await vm.toggleFollowTeam(widget.team.id);
      setState(() => _isFollowing = !_isFollowing);
      if (mounted) {
        _isFollowing
            ? WaoToast.success(context, 'Following ${widget.team.name}')
            : WaoToast.info(context, 'Unfollowed ${widget.team.name}');
      }
    } catch (_) {
      if (mounted) WaoToast.error(context, 'Failed to update follow status');
    } finally {
      if (mounted) setState(() => _loadingFollow = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final top = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        children: [
          // ── Hero header ────────────────────────────────────────────────
          _HeroHeader(
            team: widget.team,
            top: top,
            isDark: isDark,
            isFollowing: _isFollowing,
            loadingFollow: _loadingFollow,
            onBack: () => Navigator.pop(context),
            onFollow: _toggleFollow,
          ),

          // ── Tab bar ────────────────────────────────────────────────────
          _TabBar(tab: _tab, isDark: isDark),

          // ── Tab content ────────────────────────────────────────────────
          Expanded(
            child: _tab.index == 0
                ? _RosterTab(
                    team: widget.team,
                    stats: _stats,
                    isDark: isDark,
                    bottomInset: bottomInset,
                  )
                : _StatsTab(
                    stats: _stats,
                    isDark: isDark,
                    bottomInset: bottomInset,
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Hero header ───────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.team,
    required this.top,
    required this.isDark,
    required this.isFollowing,
    required this.loadingFollow,
    required this.onBack,
    required this.onFollow,
  });
  final WaoTeam team;
  final double top;
  final bool isDark, isFollowing, loadingFollow;
  final VoidCallback onBack, onFollow;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.waoNavy,
      padding: EdgeInsets.fromLTRB(20, top + 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + team name row
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 16, color: Colors.white),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  team.name,
                  style: GoogleFonts.oswald(
                    fontSize: 20, fontWeight: FontWeight.w700,
                    color: Colors.white, letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.waoRed,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  team.category.name.toUpperCase(),
                  style: GoogleFonts.oswald(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    color: Colors.white, letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Avatar + info + follow
          Row(
            children: [
              // Team avatar
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                ),
                child: Center(
                  child: Text(
                    team.name.isNotEmpty ? team.name[0].toUpperCase() : 'T',
                    style: GoogleFonts.oswald(
                      fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(icon: Icons.sports_rounded,
                        label: 'Coach: ${team.coach}'),
                    const SizedBox(height: 5),
                    _InfoRow(icon: Icons.manage_accounts_rounded,
                        label: 'Director: ${team.director}'),
                    const SizedBox(height: 5),
                    _InfoRow(icon: Icons.people_rounded,
                        label: '${team.roster.totalPlayers} players'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              loadingFollow
                  ? const SizedBox(
                      width: 24, height: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : FollowButton(isFollowing: isFollowing, onToggle: onFollow),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.white54),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.white70),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Tab bar ───────────────────────────────────────────────────────────────────

class _TabBar extends StatelessWidget {
  const _TabBar({required this.tab, required this.isDark});
  final TabController tab;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? AppColors.darkSurface : Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: TabBar(
        controller: tab,
        indicator: BoxDecoration(
          color: AppColors.waoRed,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor:
            isDark ? Colors.white54 : AppColors.waoNavy.withOpacity(0.5),
        labelStyle: GoogleFonts.oswald(
            fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3),
        unselectedLabelStyle: GoogleFonts.oswald(
            fontSize: 14, fontWeight: FontWeight.w500),
        tabs: const [Tab(text: 'Roster'), Tab(text: 'Statistics')],
      ),
    );
  }
}

// ── Roster tab ────────────────────────────────────────────────────────────────

class _RosterTab extends StatelessWidget {
  const _RosterTab({
    required this.team,
    required this.stats,
    required this.isDark,
    required this.bottomInset,
  });
  final WaoTeam team;
  final TeamStatistics? stats;
  final bool isDark;
  final double bottomInset;

  static const _roles = [
    ('Kings',      'kingIds'),
    ('Warriors',   'warriorIds'),
    ('Workers',    'workerIds'),
    ('Protagues',  'protagueIds'),
    ('Antagues',   'antagueIds'),
    ('Sacrificers','sacrificerIds'),
    ('Servitors',  'servitorIds'),
    ('Substitutes','substituteIds'),
  ];

  List<String> _ids(String key) {
    switch (key) {
      case 'kingIds':       return team.roster.kingIds;
      case 'warriorIds':    return team.roster.warriorIds;
      case 'workerIds':     return team.roster.workerIds;
      case 'protagueIds':   return team.roster.protagueIds;
      case 'antagueIds':    return team.roster.antagueIds;
      case 'sacrificerIds': return team.roster.sacrificerIds;
      case 'servitorIds':   return team.roster.servitorIds;
      case 'substituteIds': return team.roster.substituteIds;
      default:              return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WaoPlayer>>(
      future: _fetchPlayers(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final players = snap.data ?? [];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 84),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coach card
              _SectionLabel(label: 'Head Coach', isDark: isDark),
              const SizedBox(height: 8),
              _CoachCard(name: team.coach, isDark: isDark),
              const SizedBox(height: 20),

              // Role sections
              for (final (label, key) in _roles) ...[
                Builder(builder: (_) {
                  final ids = _ids(key);
                  final rolePlayers =
                      players.where((p) => ids.contains(p.id)).toList();
                  if (rolePlayers.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(
                          label: label,
                          count: rolePlayers.length,
                          isDark: isDark),
                      const SizedBox(height: 8),
                      ...rolePlayers.map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _PlayerCard(player: p, isDark: isDark),
                          )),
                      const SizedBox(height: 12),
                    ],
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<List<WaoPlayer>> _fetchPlayers() async {
    final svc = PlayerService();
    final ids = team.roster.getAllPlayerIds();
    final List<WaoPlayer> out = [];
    for (final id in ids) {
      final p = await svc.getPlayerById(id);
      if (p != null) out.add(p);
    }
    return out;
  }
}

// ── Stats tab ─────────────────────────────────────────────────────────────────

class _StatsTab extends StatelessWidget {
  const _StatsTab({
    required this.stats,
    required this.isDark,
    required this.bottomInset,
  });
  final TeamStatistics? stats;
  final bool isDark;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final s = stats;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 84),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // W / D / L row
          Row(
            children: [
              _BigStat(label: 'Won',   value: '${s?.wins ?? 0}',
                  color: const Color(0xFF1A7A4A), isDark: isDark),
              const SizedBox(width: 10),
              _BigStat(label: 'Drawn', value: '${s?.draws ?? 0}',
                  color: AppColors.waoNavy, isDark: isDark),
              const SizedBox(width: 10),
              _BigStat(label: 'Lost',  value: '${s?.losses ?? 0}',
                  color: AppColors.waoRed, isDark: isDark),
            ],
          ),

          const SizedBox(height: 16),

          // Detail grid
          _SectionLabel(label: 'Performance', isDark: isDark),
          const SizedBox(height: 10),
          _StatGrid(isDark: isDark, items: [
            ('Games Played',  '${s?.totalGamesPlayed ?? 0}', Icons.sports_rounded),
            ('Points',        '${s?.points ?? 0}',           Icons.emoji_events_rounded),
            ('Goals Scored',  '${s?.goalsScored ?? 0}',      Icons.sports_score_rounded),
            ('Goals Conceded','${s?.goalsConceded ?? 0}',     Icons.shield_rounded),
            ('Goal Diff',     '${s?.goalDifference ?? 0}',   Icons.swap_vert_rounded),
            ('Win %',         '${(s?.winPercentage ?? 0).toStringAsFixed(0)}%',
                              Icons.percent_rounded),
          ]),

          const SizedBox(height: 20),

          _SectionLabel(label: 'Squad', isDark: isDark),
          const SizedBox(height: 10),
          _StatGrid(isDark: isDark, items: [
            ('Active Players',   '${s?.activePlayers ?? 0}',   Icons.person_rounded),
            ('Inactive Players', '${s?.inactivePlayers ?? 0}', Icons.person_off_rounded),
            ('Total Followers',  '${s?.totalFollowers ?? 0}',  Icons.favorite_rounded),
          ]),

          // Recent games
          if (s != null && s.recentGames.isNotEmpty) ...[
            const SizedBox(height: 20),
            _SectionLabel(label: 'Recent Games', isDark: isDark),
            const SizedBox(height: 10),
            ...s.recentGames.take(5).map((g) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ResultRow(game: g, isDark: isDark),
                )),
          ],
        ],
      ),
    );
  }
}

// ── Shared section label ──────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.isDark, this.count});
  final String label;
  final bool isDark;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3, height: 18,
          decoration: BoxDecoration(
            color: AppColors.waoRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.oswald(
              fontSize: 15, fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.waoNavy,
              letterSpacing: 0.3,
            )),
        if (count != null) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.waoRed.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$count',
                style: GoogleFonts.oswald(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppColors.waoRed,
                )),
          ),
        ],
      ],
    );
  }
}

// ── Coach card ────────────────────────────────────────────────────────────────

class _CoachCard extends StatelessWidget {
  const _CoachCard({required this.name, required this.isDark});
  final String name;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecor(isDark),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.waoNavy,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sports_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.oswald(
                      fontSize: 15, fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                    )),
                Text('Head Coach',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.black45,
                    )),
              ],
            ),
          ),
          const Icon(Icons.verified_rounded,
              size: 20, color: AppColors.waoYellow),
        ],
      ),
    );
  }
}

// ── Player card ───────────────────────────────────────────────────────────────

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({required this.player, required this.isDark});
  final WaoPlayer player;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(player.status);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecor(isDark),
      child: Row(
        children: [
          // Avatar with jersey number
          Stack(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  color: AppColors.waoNavy,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    player.name.isNotEmpty ? player.name[0].toUpperCase() : 'P',
                    style: GoogleFonts.oswald(
                      fontSize: 18, fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (player.jerseyNumber != null)
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.waoRed,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '${player.jerseyNumber}',
                        style: const TextStyle(
                          fontSize: 9, fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name,
                    style: GoogleFonts.oswald(
                      fontSize: 14, fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                    )),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                          color: statusColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    Text(_statusLabel(player.status),
                        style: TextStyle(fontSize: 11, color: statusColor)),
                    if (player.age != null) ...[
                      const SizedBox(width: 8),
                      Text('Age ${player.age}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : Colors.black38,
                          )),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Stats
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _MiniStat(label: 'GP', value: '${player.gamesPlayed}', isDark: isDark),
              const SizedBox(height: 4),
              _MiniStat(label: 'G', value: '${player.goalsScored}', isDark: isDark),
            ],
          ),
          const SizedBox(width: 10),

          // Role icon
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : AppColors.waoNavy.withOpacity(0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_roleIcon(player.role), size: 16,
                color: isDark ? Colors.white54 : AppColors.waoNavy.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(PlayerStatus s) {
    switch (s) {
      case PlayerStatus.active:    return const Color(0xFF1A7A4A);
      case PlayerStatus.inactive:  return Colors.orange;
      case PlayerStatus.suspended: return AppColors.waoRed;
    }
  }

  String _statusLabel(PlayerStatus s) {
    switch (s) {
      case PlayerStatus.active:    return 'Active';
      case PlayerStatus.inactive:  return 'Inactive';
      case PlayerStatus.suspended: return 'Suspended';
    }
  }

  IconData _roleIcon(PlayerRole r) {
    switch (r) {
      case PlayerRole.king:       return Icons.emoji_events_rounded;
      case PlayerRole.worker:     return Icons.construction_rounded;
      case PlayerRole.protague:   return Icons.shield_rounded;
      case PlayerRole.antague:    return Icons.security_rounded;
      case PlayerRole.warrior:    return Icons.sports_martial_arts_rounded;
      case PlayerRole.sacrificer: return Icons.favorite_rounded;
      case PlayerRole.servitor:   return Icons.support_agent_rounded;
      case PlayerRole.substitute: return Icons.swap_horiz_rounded;
    }
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.isDark});
  final String label, value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.white38 : Colors.black38,
            )),
        const SizedBox(width: 3),
        Text(value,
            style: GoogleFonts.oswald(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.waoNavy,
            )),
      ],
    );
  }
}

// ── Big stat (W/D/L) ──────────────────────────────────────────────────────────

class _BigStat extends StatelessWidget {
  const _BigStat({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });
  final String label, value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8, offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.oswald(
                  fontSize: 28, fontWeight: FontWeight.w800, color: color,
                )),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.oswald(
                  fontSize: 12, fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white54 : Colors.black45,
                  letterSpacing: 0.3,
                )),
          ],
        ),
      ),
    );
  }
}

// ── Stat grid ─────────────────────────────────────────────────────────────────

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.isDark, required this.items});
  final bool isDark;
  final List<(String, String, IconData)> items;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: items.map((item) {
        final (label, value, icon) = item;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: _cardDecor(isDark),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.waoRed),
              const SizedBox(height: 6),
              Text(value,
                  style: GoogleFonts.oswald(
                    fontSize: 18, fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.waoNavy,
                  )),
              const SizedBox(height: 2),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white54 : Colors.black45,
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Result row ────────────────────────────────────────────────────────────────

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.game, required this.isDark});
  final GameResult game;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isWin  = game.isWin;
    final isDraw = game.isDraw;
    final resultColor = isWin
        ? const Color(0xFF1A7A4A)
        : isDraw
            ? AppColors.waoNavy
            : AppColors.waoRed;
    final resultLabel = isWin ? 'W' : isDraw ? 'D' : 'L';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: _cardDecor(isDark),
      child: Row(
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: resultColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(resultLabel,
                  style: GoogleFonts.oswald(
                    fontSize: 13, fontWeight: FontWeight.w800,
                    color: Colors.white,
                  )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'vs ${game.opponentTeamName}',
              style: GoogleFonts.oswald(
                fontSize: 14, fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : AppColors.waoNavy,
              ),
            ),
          ),
          Text(
            '${game.teamScore} – ${game.opponentScore}',
            style: GoogleFonts.oswald(
              fontSize: 15, fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.waoNavy,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared card decoration ────────────────────────────────────────────────────

BoxDecoration _cardDecor(bool isDark) => BoxDecoration(
      color: isDark ? AppColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.08)
            : AppColors.waoNavy.withOpacity(0.08),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8, offset: const Offset(0, 2),
        ),
      ],
    );
