import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

import '../../Model/teams_games/team/wao_player.dart';
import '../../Model/teams_games/wao_match.dart';
import '../../Model/teams_games/wao_team.dart';
import '../../ViewModel/teams_games/player_viewmodel.dart';
import '../../ViewModel/teams_games/team_viewmodel.dart';
import '../../core/theme/app_typography.dart';

class LiveGamesDetails extends StatefulWidget {
  final WaoMatch match;

  const LiveGamesDetails({super.key, required this.match});

  @override
  State<LiveGamesDetails> createState() => _LiveGamesDetailsState();
}

class _LiveGamesDetailsState extends State<LiveGamesDetails> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _teamPageController = PageController();
  int _currentTeamIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _teamPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  const SizedBox(
                    width: double.infinity,
                    height: 330,
                  ),

                  const Positioned(
                    child: Image(
                      image: AssetImage("assets/images/officiate.jpg"),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 210,
                    ),
                  ),

                  Positioned(
                      child: Container(
                        width: double.infinity,
                        height: 210,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      )),

                  Positioned(
                      top: 15,
                      left: 15,
                      right: 15,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ))),

                            Text(
                              widget.match.type.name.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),

                            _buildNotificationBell(isDarkMode),
                          ])),

                  Positioned(
                    top: 85,
                    left: 15,
                    right: 15,
                    child: _buildLiveMatchCard(widget.match, true, true, context),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF011B3B),
                          Color(0xFFD30336),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: isDarkMode ? Colors.white60 : Colors.black54,
                    labelStyle: const TextStyle(
                      fontSize: AppTypography.bodyLg,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: AppTypography.bodyLg,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: 'Game Statistics'),
                      Tab(text: 'Team Players'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              if (_tabController.index == 0)
                _buildGameStatisticsTab()
              else
                _buildTeamPlayersTab(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameStatisticsTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final kingdomPercentages = widget.match.getKingdomPercentages();
    final workoutPercentages = widget.match.getWorkoutPercentages();
    final goalSettingPercentages = widget.match.getGoalSettingPercentages();
    final judgesPercentages = widget.match.getJudgesPercentages();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            _buildStatItem(
              label: 'Kingdom (30%)',
              teamAPercentage: kingdomPercentages['teamA']!.round(),
              teamBPercentage: kingdomPercentages['teamB']!.round(),
              teamAName: widget.match.teamAName,
              teamBName: widget.match.teamBName,
            ),
            const SizedBox(height: 20),
            _buildStatItem(
              label: 'Workout (30%)',
              teamAPercentage: workoutPercentages['teamA']!.round(),
              teamBPercentage: workoutPercentages['teamB']!.round(),
              teamAName: widget.match.teamAName,
              teamBName: widget.match.teamBName,
            ),
            const SizedBox(height: 20),
            _buildStatItem(
              label: 'Goal Setting (30%)',
              teamAPercentage: goalSettingPercentages['teamA']!.round(),
              teamBPercentage: goalSettingPercentages['teamB']!.round(),
              teamAName: widget.match.teamAName,
              teamBName: widget.match.teamBName,
            ),
            const SizedBox(height: 20),
            _buildStatItem(
              label: 'Judges (10%)',
              teamAPercentage: judgesPercentages['teamA']!.round(),
              teamBPercentage: judgesPercentages['teamB']!.round(),
              teamAName: widget.match.teamAName,
              teamBName: widget.match.teamBName,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required int teamAPercentage,
    required int teamBPercentage,
    required String teamAName,
    required String teamBName,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool teamAWinning = teamAPercentage > teamBPercentage;
    final bool teamBWinning = teamBPercentage > teamAPercentage;

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            SizedBox(
              width: 35,
              child: Text(
                '$teamAPercentage%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: teamAWinning ? const Color(0xFFD30336) : (isDarkMode ? Colors.white54 : Colors.black54),
                ),
                textAlign: TextAlign.right,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: teamAPercentage,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: teamAWinning
                            ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFD30336),
                            Color(0xFFFF6B35),
                          ],
                        )
                            : null,
                        color: teamAWinning ? null : (isDarkMode ? Colors.white24 : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    flex: teamBPercentage,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: teamBWinning
                            ? const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFD30336),
                            Color(0xFFFF6B35),
                          ],
                        )
                            : null,
                        color: teamBWinning ? null : (isDarkMode ? Colors.white24 : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            SizedBox(
              width: 35,
              child: Text(
                '$teamBPercentage%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: teamBWinning ? const Color(0xFFD30336) : (isDarkMode ? Colors.white54 : Colors.black54),
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                teamAName,
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                teamBName,
                style: TextStyle(
                  fontSize: 11,
                  color: isDarkMode ? Colors.white60 : Colors.black54,
                ),
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTeamPlayersTab() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTeamDot(0, widget.match.teamAName, isDarkMode),
              const SizedBox(width: 12),
              _buildTeamDot(1, widget.match.teamBName, isDarkMode),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _currentTeamIndex == 0
            ? _buildTeamRosterFromDatabase(widget.match.teamAId, widget.match.teamAName, isDarkMode)
            : _buildTeamRosterFromDatabase(widget.match.teamBId, widget.match.teamBName, isDarkMode),
      ],
    );
  }

  Widget _buildTeamDot(int index, String teamName, bool isDarkMode) {
    final isSelected = _currentTeamIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTeamIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD30336),
              Color(0xFFFF6B35),
            ],
          )
              : null,
          color: isSelected ? null : (isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          teamName,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : (isDarkMode ? Colors.white60 : Colors.black54),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamRosterFromDatabase(String teamId, String teamName, bool isDarkMode) {
    return FutureBuilder<WaoTeam?>(
      future: Provider.of<TeamViewModel>(context, listen: false).getTeamById(teamId),
      builder: (context, teamSnapshot) {
        if (teamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircularProgressIndicator(
                color: isDarkMode ? const Color(0xFFFFC600) : const Color(0xFF011B3B),
              ),
            ),
          );
        }

        if (teamSnapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error loading team',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (!teamSnapshot.hasData || teamSnapshot.data == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Team not found',
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }

        final team = teamSnapshot.data!;
        return _buildTeamRosterWithPlayers(team, isDarkMode);
      },
    );
  }

  Widget _buildTeamRosterWithPlayers(WaoTeam team, bool isDarkMode) {
    return FutureBuilder<List<WaoPlayer>>(
      future: _getTeamPlayers(team.roster),
      builder: (context, playersSnapshot) {
        if (playersSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircularProgressIndicator(
                color: isDarkMode ? const Color(0xFFFFC600) : const Color(0xFF011B3B),
              ),
            ),
          );
        }

        final players = playersSnapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Team Header
                Center(
                  child: Column(
                    children: [
                      if (team.logoUrl.isNotEmpty)
                        ClipOval(
                          child: Image.network(
                            team.logoUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildTeamLogoPlaceholder(isDarkMode);
                            },
                          ),
                        )
                      else
                        _buildTeamLogoPlaceholder(isDarkMode),
                      const SizedBox(height: 12),
                      Text(
                        team.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Coach: ${team.coach}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white : AppColors.darkBackground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Coach Section
                _buildRoleSectionWithPlayers(
                  role: 'Coach',
                  players: [team.coach],
                  isDarkMode: isDarkMode,
                  isCoach: true,
                ),
                const SizedBox(height: 15),

                // Kings
                _buildRoleSectionWithPlayers(
                  role: 'Kings',
                  players: _getPlayersByRole(players, team.roster.kingIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),

                // Workers
                _buildRoleSectionWithPlayers(
                  role: 'Workers',
                  players: _getPlayersByRole(players, team.roster.workerIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),

                // Protagues
                _buildRoleSectionWithPlayers(
                  role: 'Protagues',
                  players: _getPlayersByRole(players, team.roster.protagueIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),

                // Antagues
                _buildRoleSectionWithPlayers(
                  role: 'Antagues',
                  players: _getPlayersByRole(players, team.roster.antagueIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),

                // Warriors
                _buildRoleSectionWithPlayers(
                  role: 'Warriors',
                  players: _getPlayersByRole(players, team.roster.warriorIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),

                // Sacrificers
                _buildRoleSectionWithPlayers(
                  role: 'Sacrificers',
                  players: _getPlayersByRole(players, team.roster.sacrificerIds),
                  isDarkMode: isDarkMode,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper method to get team players
  Future<List<WaoPlayer>> _getTeamPlayers(TeamRoster roster) async {
    final playerService = PlayerService();
    final List<WaoPlayer> players = [];

    final allPlayerIds = roster.getAllPlayerIds();

    for (final playerId in allPlayerIds) {
      final player = await playerService.getPlayerById(playerId);
      if (player != null) {
        players.add(player);
      }
    }

    return players;
  }

// Helper method to filter players by role
  List<WaoPlayer> _getPlayersByRole(List<WaoPlayer> allPlayers, List<String> rolePlayerIds) {
    return allPlayers.where((player) => rolePlayerIds.contains(player.id)).toList();
  }

  Widget _buildTeamLogoPlaceholder(bool isDarkMode) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.shield,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildRoleSectionWithPlayers({
    required String role,
    required List<dynamic> players, // Can be List<WaoPlayer> or List<String> for coach
    required bool isDarkMode,
    bool isCoach = false,
  }) {
    if (players.isEmpty) {
      return const SizedBox.shrink(); // Don't show empty roles
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFD30336),
                Color(0xFFFF6B35),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                role,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${players.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        if (isCoach)
          _buildCoachCard(players[0] as String, isDarkMode)
        else
          ...players.map((player) {
            final waoPlayer = player as WaoPlayer;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _buildPlayerCardWithData(
                player: waoPlayer,
                isDarkMode: isDarkMode,
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildCoachCard(String coachName, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD30336), Color(0xFFFF6B35)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.sports,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coachName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  'Head Coach',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.verified,
            size: 20,
            color: const Color(0xFFFFC600),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCardWithData({
    required WaoPlayer player,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Player Avatar
          player.profileImageUrl != null && player.profileImageUrl!.isNotEmpty
              ? ClipOval(
            child: Image.network(
              player.profileImageUrl!,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlayerAvatar(player.name, isDarkMode);
              },
            ),
          )
              : _buildPlayerAvatar(player.name, isDarkMode),
          const SizedBox(width: 12),

          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Player role icon
          _getRoleIcon(player.role, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildPlayerAvatar(String name, bool isDarkMode) {
    String initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(PlayerStatus status) {
    switch (status) {
      case PlayerStatus.active:
        return Colors.green;
      case PlayerStatus.inactive:
        return Colors.orange;
      case PlayerStatus.suspended:
        return Colors.red;
    }
  }

  Widget _getRoleIcon(PlayerRole role, bool isDarkMode) {
    IconData iconData;

    switch (role) {
      case PlayerRole.king:
        iconData = Icons.emoji_events;
        break;
      case PlayerRole.worker:
        iconData = Icons.work;
        break;
      case PlayerRole.protague:
        iconData = Icons.shield;
        break;
      case PlayerRole.antague:
        iconData = Icons.security;
        break;
      case PlayerRole.warrior:
        iconData = Icons.sports_martial_arts;
        break;
      case PlayerRole.sacrificer:
        iconData = Icons.favorite;
        break;
    }

    return Icon(
      iconData,
      size: 20,
      color: isDarkMode ? Colors.white38 : Colors.black38,
    );
  }

  Widget _buildLiveMatchCard(WaoMatch match, bool isDarkMode, bool useRedYellow, context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF011B3B),
              Color(0xFFD30336),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              Positioned(
                bottom: -80,
                right: -80,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    "assets/images/wao-ball.png",
                    width: 230,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox();
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white70,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  match.venue,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildLiveBadge(),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/logos/default_team.png",
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.shield,
                                        color: Colors.white,
                                        size: 25,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                match.teamAName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${match.scoreA}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  ':',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '${match.scoreB}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/logos/default_team.png",
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.shield,
                                        color: Colors.white,
                                        size: 25,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                match.teamBName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      match.type.name.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '23:34',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.waoYellow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '+3:00',
                                  style: TextStyle(
                                    color: Color(0xFF011B3B),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.waoYellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '2nd Quarter',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.waoYellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC600).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFC600),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(),
          const SizedBox(width: 6),
          const Text(
            "LIVE",
            style: TextStyle(
              color: Color(0xFFFFC600),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationBell(bool isDarkMode) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFE0000),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Color(0xFFFFC600),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}