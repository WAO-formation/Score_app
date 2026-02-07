import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

import '../../Model/teams_games/team/wao_player.dart';
import '../../Model/teams_games/wao_match.dart';
import '../../Model/teams_games/wao_team.dart';
import '../../ViewModel/teams_games/player_viewmodel.dart';
import '../../ViewModel/teams_games/team_viewmodel.dart';
import '../../core/theme/app_typography.dart';


class UpcomingGameDetails extends StatefulWidget {
  final WaoMatch match;

  const UpcomingGameDetails({super.key, required this.match});

  @override
  State<UpcomingGameDetails> createState() => _UpcomingGameDetailsState();
}

class _UpcomingGameDetailsState extends State<UpcomingGameDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'TBA';
    try {
      return DateFormat('MMM d, yyyy').format(dateTime);
    } catch (e) {
      return 'TBA';
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'TBA';
    try {
      return DateFormat('h:mm a').format(dateTime);
    } catch (e) {
      return 'TBA';
    }
  }

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
                    height: 280,
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
                    ),
                  ),
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
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.3)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
                      ],
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 15,
                    right: 15,
                    child: _buildUpcomingMatch(
                        widget.match, isDarkMode, true, context),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFD30336),
                          Color(0xFFFF6B35),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor:
                    isDarkMode ? Colors.white60 : Colors.black54,
                    labelStyle: const TextStyle(
                      fontSize: AppTypography.bodyLg,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: AppTypography.bodyLg,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: [
                      Tab(text: widget.match.teamAName),
                      Tab(text: widget.match.teamBName),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_tabController.index == 0)
                _buildTeamRosterFromDatabase(
                    widget.match.teamAId, widget.match.teamAName, isDarkMode)
              else
                _buildTeamRosterFromDatabase(
                    widget.match.teamBId, widget.match.teamBName, isDarkMode),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamRosterFromDatabase(
      String teamId, String teamName, bool isDarkMode) {
    return FutureBuilder<WaoTeam?>(
      future: Provider.of<TeamViewModel>(context, listen: false)
          .getTeamById(teamId),
      builder: (context, teamSnapshot) {
        if (teamSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: CircularProgressIndicator(
                color: isDarkMode
                    ? const Color(0xFFFFC600)
                    : const Color(0xFF011B3B),
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
                color: isDarkMode
                    ? const Color(0xFFFFC600)
                    : const Color(0xFF011B3B),
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
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                          color:
                          isDarkMode ? Colors.white70 : AppColors.darkBackground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildRoleSectionWithPlayers(
                  role: 'Coach',
                  players: [team.coach],
                  isDarkMode: isDarkMode,
                  isCoach: true,
                ),
                const SizedBox(height: 15),
                _buildRoleSectionWithPlayers(
                  role: 'Kings',
                  players: _getPlayersByRole(players, team.roster.kingIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),
                _buildRoleSectionWithPlayers(
                  role: 'Workers',
                  players: _getPlayersByRole(players, team.roster.workerIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),
                _buildRoleSectionWithPlayers(
                  role: 'Protagues',
                  players: _getPlayersByRole(players, team.roster.protagueIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),
                _buildRoleSectionWithPlayers(
                  role: 'Antagues',
                  players: _getPlayersByRole(players, team.roster.antagueIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),
                _buildRoleSectionWithPlayers(
                  role: 'Warriors',
                  players: _getPlayersByRole(players, team.roster.warriorIds),
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 15),
                _buildRoleSectionWithPlayers(
                  role: 'Sacrificers',
                  players:
                  _getPlayersByRole(players, team.roster.sacrificerIds),
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

  Future<List<WaoPlayer>> _getTeamPlayers(TeamRoster roster) async {
    final playerService = PlayerService();
    final List<WaoPlayer> players = [];
    final allPlayerIds = roster.getAllPlayerIds();

    for (final playerId in allPlayerIds) {
      try {
        final player = await playerService.getPlayerById(playerId);
        if (player != null) {
          players.add(player);
        }
      } catch (e) {
        print('Error fetching player $playerId: $e');
      }
    }

    return players;
  }

  List<WaoPlayer> _getPlayersByRole(
      List<WaoPlayer> allPlayers, List<String> rolePlayerIds) {
    return allPlayers
        .where((player) => rolePlayerIds.contains(player.id))
        .toList();
  }

  Widget _buildTeamLogoPlaceholder(bool isDarkMode) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.withOpacity(0.2),
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
    required List<dynamic> players,
    required bool isDarkMode,
    bool isCoach = false,
  }) {
    if (players.isEmpty) {
      return const SizedBox.shrink();
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
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
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
          const Icon(
            Icons.verified,
            size: 20,
            color: Color(0xFFFFC600),
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
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
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
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.grey.withOpacity(0.2),
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

  Widget _buildUpcomingMatch(
      WaoMatch match, bool isDarkMode, bool useRedYellow, context) {
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
              Color(0xFFD30336),
              Color(0xFFFF6B35),
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
                        _buildUpcomingBatch(),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            'VS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
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
                      '${match.type.name.toUpperCase()} | ${_formatDate(match.scheduledDate ?? match.startTime)} | ${_formatTime(match.startTime)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingBatch() {
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
            "Upcoming",
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
            color: isDarkMode
                ? Colors.white10
                : Colors.black.withOpacity(0.05),
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

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
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