import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/team/wao_player.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/Model/teams_games/team/team_stat.dart';
import 'package:wao_mobile/Model/user_model.dart';
import 'package:wao_mobile/Model/user_provider.dart';
import 'package:wao_mobile/View/games_details/player_profile_page.dart';
import 'package:wao_mobile/View/games_details/live_game_details.dart';
import 'package:wao_mobile/View/games_details/past_match_details.dart';
import 'package:wao_mobile/View/games_details/upcoming_game_details.dart';
import 'package:wao_mobile/View/games_details/widgets/game_detail_shared.dart';
import 'package:wao_mobile/ViewModel/teams_games/match_viewmodel.dart';
import 'package:wao_mobile/ViewModel/teams_games/player_viewmodel.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'package:wao_mobile/core/widgets/wao_toast.dart';

/// The players' tab (replaces "Rules" in the bottom nav for a player-role
/// account — see BottomNavBar). "Their team" is UserProfile.teamId, an
/// admin-assigned roster link — distinct from favoriteTeamIds, which is the
/// self-service "follow a team" field fans use. A player doesn't declare
/// their own team; a moderator/admin sets it (see
/// wao-web/scripts/linkPlayerToTeam.js for how that write is made).
class TeamActivitiesPage extends StatelessWidget {
  const TeamActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<UserProvider>().userProfile;
    final teamId = user?.teamId;
    final isCoach = user?.accountRole == AccountRole.coach;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                isCoach ? 'My Team' : 'Team Activities',
                style: GoogleFonts.oswald(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: user == null
                  ? const Center(child: CircularProgressIndicator())
                  : (teamId == null || teamId.isEmpty)
                      ? _NoTeamState(isDark: isDark)
                      : _TeamActivitiesBody(teamId: teamId, isDark: isDark, isCoach: isCoach),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state: not yet assigned to a team ───────────────────────────────────
class _NoTeamState extends StatelessWidget {
  const _NoTeamState({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 56,
              color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'Not on a team yet',
              style: GoogleFonts.oswald(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white60 : AppColors.waoNavy.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'A club admin needs to add you to a roster before your\nlineup, fixtures and results show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Main body once the player is on a team ────────────────────────────────────
class _TeamActivitiesBody extends StatelessWidget {
  const _TeamActivitiesBody({required this.teamId, required this.isDark, required this.isCoach});

  final String teamId;
  final bool isDark;
  final bool isCoach;

  @override
  Widget build(BuildContext context) {
    final email = context.watch<UserProvider>().userProfile?.email;

    return FutureBuilder<WaoTeam?>(
      future: context.read<TeamViewModel>().getTeamById(teamId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final team = snapshot.data;
        if (team == null) {
          return _NoTeamState(isDark: isDark);
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  team.name,
                  style: GoogleFonts.oswald(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white70 : AppColors.waoNavy.withOpacity(0.7),
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Team-wide stats (W-D-L, points, goal diff) matter to a coach
              // and a player alike — only the personal "My Stats" card below
              // is coach-irrelevant, since a coach isn't a rostered player.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _TeamStatsCard(teamId: team.id, isDark: isDark),
              ),
              const SizedBox(height: 24),
              if (!isCoach && email != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _MyStatsCard(email: email, isDark: isDark),
                ),
                const SizedBox(height: 24),
              ],
              _TeamMatchesSection(team: team, isDark: isDark),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionHeading(
                  title: isCoach ? 'Manage Roster' : 'Team Lineup',
                  isDark: isDark,
                ),
              ),
              const SizedBox(height: 12),
              if (isCoach)
                _RosterManagementSection(team: team, isDark: isDark)
              else
                TeamRosterPanel(teamId: team.id, isDark: isDark),
            ],
          ),
        );
      },
    );
  }
}

// ── "My Stats" card ────────────────────────────────────────────────────────
class _MyStatsCard extends StatelessWidget {
  const _MyStatsCard({required this.email, required this.isDark});
  final String email;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WaoPlayer?>(
      future: context.read<PlayerViewModel>().getPlayerByEmail(email),
      builder: (context, snapshot) {
        final player = snapshot.data;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: _cardDecor(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeading(title: 'My Stats', isDark: isDark),
              const SizedBox(height: 14),
              Row(
                children: [
                  _StatBlock(
                    label: 'Games Played',
                    value: '${player?.gamesPlayed ?? 0}',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 24),
                  _StatBlock(
                    label: 'Role',
                    value: player != null ? _roleLabel(player.role) : '—',
                    isDark: isDark,
                  ),
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
      },
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

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.label, required this.value, required this.isDark});
  final String label;
  final String value;
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

// ── "Season Stats" card (coach view) ──────────────────────────────────────────
class _TeamStatsCard extends StatelessWidget {
  const _TeamStatsCard({required this.teamId, required this.isDark});
  final String teamId;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TeamStatistics?>(
      stream: context.read<TeamViewModel>().getTeamStatistics(teamId),
      builder: (context, snapshot) {
        final stats = snapshot.data;
        final diff = stats?.goalDifference ?? 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: _cardDecor(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeading(title: 'Season Stats', isDark: isDark),
              const SizedBox(height: 14),
              Row(
                children: [
                  _StatBlock(label: 'Played', value: '${stats?.totalGamesPlayed ?? 0}', isDark: isDark),
                  const SizedBox(width: 20),
                  _StatBlock(
                    label: 'W-D-L',
                    value: '${stats?.wins ?? 0}-${stats?.draws ?? 0}-${stats?.losses ?? 0}',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 20),
                  _StatBlock(label: 'Points', value: '${stats?.points ?? 0}', isDark: isDark),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _StatBlock(
                    label: 'Goal Diff',
                    value: '${diff >= 0 ? '+' : ''}$diff',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 20),
                  _StatBlock(
                    label: 'Win %',
                    value: '${(stats?.winPercentage ?? 0).toStringAsFixed(0)}%',
                    isDark: isDark,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Roster management (coach view) ────────────────────────────────────────────
class _RosterManagementSection extends StatelessWidget {
  const _RosterManagementSection({required this.team, required this.isDark});
  final WaoTeam team;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => _AddPlayerSheet(team: team, isDark: isDark),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                decoration: BoxDecoration(
                  color: AppColors.waoRed,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Add Player',
                      style: GoogleFonts.oswald(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          StreamBuilder<List<WaoPlayer>>(
            stream: context.read<PlayerViewModel>().getPlayersByTeam(team.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final players = snapshot.data ?? [];
              if (players.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: _cardDecor(isDark),
                  child: Center(
                    child: Text(
                      'No players on the roster yet',
                      style: GoogleFonts.oswald(
                        fontSize: 14,
                        color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: players
                    .map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _ManagedPlayerTile(player: p, team: team, isDark: isDark),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ManagedPlayerTile extends StatelessWidget {
  const _ManagedPlayerTile({required this.player, required this.team, required this.isDark});
  final WaoPlayer player;
  final WaoTeam team;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PlayerProfilePage(player: player)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: _cardDecor(isDark),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.waoNavy),
              child: Center(
                child: Text(
                  player.name.isNotEmpty ? player.name[0].toUpperCase() : 'P',
                  style: GoogleFonts.oswald(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                    ),
                  ),
                  Text(
                    _roleLabel(player.role),
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _confirmRemove(context),
              child: Icon(
                Icons.remove_circle_outline_rounded,
                size: 20,
                color: AppColors.waoRed.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmRemove(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Remove player?',
            style: GoogleFonts.oswald(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.waoNavy,
            )),
        content: Text(
          '${player.name} will be removed from ${team.name}\'s roster.',
          style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white54 : Colors.black45)),
          ),
          TextButton(
            onPressed: () async {
              final teamViewModel = context.read<TeamViewModel>();
              Navigator.pop(dialogContext);
              try {
                await teamViewModel.removePlayerFromTeam(teamId: team.id, playerId: player.id);
                if (context.mounted) WaoToast.success(context, '${player.name} removed from roster');
              } catch (_) {
                if (context.mounted) WaoToast.error(context, 'Failed to remove player');
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: AppColors.waoRed.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Remove',
                style: GoogleFonts.oswald(fontWeight: FontWeight.w600, color: AppColors.waoRed)),
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

// ── "Add Player" bottom sheet ─────────────────────────────────────────────────
class _AddPlayerSheet extends StatefulWidget {
  const _AddPlayerSheet({required this.team, required this.isDark});
  final WaoTeam team;
  final bool isDark;

  @override
  State<_AddPlayerSheet> createState() => _AddPlayerSheetState();
}

class _AddPlayerSheetState extends State<_AddPlayerSheet> {
  PlayerRole _selectedRole = PlayerRole.worker;
  // Guards against a double/triple-tap firing addPlayerToTeam more than
  // once for the same player before the sheet closes — each extra call
  // would otherwise fail with "Player is not available or already in a
  // team" since the first call already claimed them.
  bool _isSubmitting = false;

  // Fetched once when the sheet opens, not on every rebuild — _isSubmitting
  // toggling would otherwise hand StreamBuilder a brand new stream (and a
  // fresh Firestore listener) on every tap.
  late final Stream<List<WaoPlayer>> _availablePlayersStream =
      context.read<PlayerViewModel>().getAvailablePlayers();

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add Player to ${widget.team.name}',
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Role to assign',
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PlayerRole.values.map((r) {
                  final selected = r == _selectedRole;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRole = r),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.waoRed
                            : isDark
                                ? Colors.white.withOpacity(0.06)
                                : AppColors.waoNavy.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _roleLabel(r),
                        style: GoogleFonts.oswald(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : isDark
                                  ? Colors.white60
                                  : AppColors.waoNavy.withOpacity(0.7),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<List<WaoPlayer>>(
                  stream: _availablePlayersStream,
                  builder: (context, snapshot) {
                    final players = snapshot.data ?? [];
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (players.isEmpty) {
                      return Center(
                        child: Text(
                          'No available players to add',
                          style: GoogleFonts.oswald(
                            fontSize: 14,
                            color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: scrollController,
                      itemCount: players.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final p = players[i];
                        return GestureDetector(
                          onTap: _isSubmitting
                              ? null
                              : () async {
                                  setState(() => _isSubmitting = true);
                                  try {
                                    await context.read<TeamViewModel>().addPlayerToTeam(
                                      teamId: widget.team.id,
                                      playerId: p.id,
                                      role: _selectedRole,
                                    );
                                    if (context.mounted) {
                                      // Toast first, then pop: the sheet's
                                      // context is still fully attached
                                      // here, so ScaffoldMessenger.of finds
                                      // the underlying page and the toast
                                      // survives the sheet closing. Popping
                                      // first (the previous order) tried to
                                      // look up a messenger on a context
                                      // whose route was already being torn
                                      // down, and the toast never appeared.
                                      WaoToast.success(context, '${p.name} added to ${widget.team.name}');
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    if (mounted) setState(() => _isSubmitting = false);
                                    if (context.mounted) WaoToast.error(context, 'Failed to add player: $e');
                                  }
                                },
                          child: Opacity(
                            opacity: _isSubmitting ? 0.5 : 1,
                            child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: _cardDecor(isDark),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.waoNavy),
                                  child: Center(
                                    child: Text(
                                      p.name.isNotEmpty ? p.name[0].toUpperCase() : 'P',
                                      style: GoogleFonts.oswald(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    p.name,
                                    style: GoogleFonts.oswald(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? Colors.white : AppColors.waoNavy,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.add_circle_outline_rounded, size: 20, color: AppColors.waoRed),
                              ],
                            ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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

// ── Matches section: next up + remaining fixtures + last result ──────────────
class _TeamMatchesSection extends StatelessWidget {
  const _TeamMatchesSection({required this.team, required this.isDark});
  final WaoTeam team;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WaoMatch>>(
      stream: context.read<MatchViewModel>().getTeamMatches(team.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final matches = snapshot.data ?? [];
        final upcoming = matches
            .where((m) => m.status == MatchStatus.upcoming || m.status == MatchStatus.live)
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        final finished = matches.where((m) => m.status == MatchStatus.finished).toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));

        if (matches.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: _cardDecor(isDark),
              child: Center(
                child: Text(
                  'No games scheduled for ${team.name} yet',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(
                    fontSize: 14,
                    color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          );
        }

        final next = upcoming.isNotEmpty ? upcoming.first : null;
        final rest = upcoming.length > 1 ? upcoming.sublist(1) : const <WaoMatch>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (next != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionHeading(title: 'Next Up', isDark: isDark),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _NextMatchCard(match: next, ourTeamId: team.id),
              ),
              const SizedBox(height: 24),
            ],
            if (rest.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionHeading(title: 'Upcoming Fixtures', isDark: isDark),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: rest
                      .map((m) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _FixtureTile(match: m, ourTeamId: team.id, isDark: isDark),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 4),
            ],
            if (finished.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionHeading(title: 'Past Games', isDark: isDark),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: finished
                      .map((m) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _FixtureTile(match: m, ourTeamId: team.id, isDark: isDark),
                          ))
                      .toList(),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

// ── "Next Up" hero-ish card ───────────────────────────────────────────────────
class _NextMatchCard extends StatelessWidget {
  const _NextMatchCard({required this.match, required this.ourTeamId});
  final WaoMatch match;
  final String ourTeamId;

  bool get _isLive => match.status == MatchStatus.live;

  String get _opponentName =>
      match.teamAId == ourTeamId ? match.teamBName : match.teamAName;

  String _formatStart(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);
    if (diff.inDays == 0) return 'Today ${DateFormat('HH:mm').format(date)}';
    if (diff.inDays == 1) return 'Tomorrow ${DateFormat('HH:mm').format(date)}';
    if (diff.inDays > 1 && diff.inDays < 7) return 'In ${diff.inDays} days';
    return DateFormat('MMM d, HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final date = match.scheduledDate ?? match.startTime;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _isLive
              ? LiveGamesDetails(match: match)
              : UpcomingGameDetails(match: match),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isLive
                ? [AppColors.waoRed, const Color(0xFFB01030)]
                : [AppColors.waoNavy, const Color(0xFF02264D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLive) ...[
                        const PulsingDot(color: Colors.white),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        _isLive ? 'LIVE NOW' : 'UPCOMING',
                        style: GoogleFonts.oswald(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white54, size: 14),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'vs $_opponentName',
              style: GoogleFonts.oswald(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule_rounded, color: Colors.white70, size: 14),
                const SizedBox(width: 6),
                Text(
                  _isLive ? 'In progress' : _formatStart(date),
                  style: GoogleFonts.oswald(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, color: Colors.white54, size: 14),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    match.venue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.oswald(fontSize: 13, color: Colors.white54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Compact fixture / result row ──────────────────────────────────────────────
class _FixtureTile extends StatelessWidget {
  const _FixtureTile({required this.match, required this.ourTeamId, required this.isDark});
  final WaoMatch match;
  final String ourTeamId;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final opponent = match.teamAId == ourTeamId ? match.teamBName : match.teamAName;
    final isFinished = match.status == MatchStatus.finished;
    final isLive = match.status == MatchStatus.live;
    final ourScore = match.teamAId == ourTeamId ? match.scoreA : match.scoreB;
    final theirScore = match.teamAId == ourTeamId ? match.scoreB : match.scoreA;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => isLive
              ? LiveGamesDetails(match: match)
              : isFinished
                  ? PastMatchDetails(match: match)
                  : UpcomingGameDetails(match: match),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecor(isDark),
        child: Row(
          children: [
            SizedBox(
              width: 46,
              child: Text(
                isLive ? 'LIVE' : isFinished ? 'FT' : DateFormat('MMM d').format(match.startTime),
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isLive
                      ? AppColors.waoRed
                      : isDark
                          ? Colors.white70
                          : AppColors.waoNavy.withOpacity(0.7),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: isDark ? Colors.white.withOpacity(0.08) : AppColors.waoNavy.withOpacity(0.08),
            ),
            Expanded(
              child: Text(
                'vs $opponent',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.oswald(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                ),
              ),
            ),
            if (isFinished || isLive)
              Text(
                '$ourScore - $theirScore',
                style: GoogleFonts.oswald(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Shared bits ───────────────────────────────────────────────────────────────
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
          decoration: BoxDecoration(
            color: AppColors.waoRed,
            borderRadius: BorderRadius.circular(2),
          ),
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
