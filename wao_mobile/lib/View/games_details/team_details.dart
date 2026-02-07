import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'package:wao_mobile/core/theme/app_typography.dart';

import '../../Model/teams_games/team/wao_player.dart';
import '../../Model/teams_games/team/team_stat.dart';
import '../../Model/news/news_model.dart';
import '../../ViewModel/news_viewmodel/news_viewmodel.dart';
import '../../ViewModel/teams_games/player_viewmodel.dart';
import '../../ViewModel/teams_games/team_viewmodel.dart';
import '../dashboard/widgets/folow_button.dart';

class TeamDetails extends StatefulWidget {
  final WaoTeam team;

  const TeamDetails({
    super.key,
    required this.team,
  });

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;
  bool _isLoadingFollow = false;
  TeamStatistics? _teamStats;
  List<NewsModel> _teamNews = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _loadFollowStatus();
    _loadTeamStatistics();
    _loadTeamNews();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadFollowStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final teamViewModel = Provider.of<TeamViewModel>(context, listen: false);
        setState(() {
          _isFollowing = teamViewModel.isFollowingTeam(widget.team.id);
        });
      }
    });
  }

  void _loadTeamStatistics() {
    final teamViewModel = Provider.of<TeamViewModel>(context, listen: false);
    teamViewModel.getTeamStatistics(widget.team.id).listen((stats) {
      if (mounted) {
        setState(() {
          _teamStats = stats;
        });
      }
    });
  }

  void _loadTeamNews() {
    final newsViewModel = Provider.of<NewsViewModel>(context, listen: false);
    // Filter news by team name or team-related content
    newsViewModel.listenToNews().listen((allNews) {
      if (mounted) {
        setState(() {
          // Filter news that contains team name in title or content
          _teamNews = allNews.where((news) {
            final teamName = widget.team.name.toLowerCase();
            final newsTitle = news.title.toLowerCase();
            return newsTitle.contains(teamName) ;
          }).take(5).toList();
        });
      }
    });
  }

  Future<void> _toggleFollow() async {
    if (_isLoadingFollow) return;

    setState(() {
      _isLoadingFollow = true;
    });

    try {
      final teamViewModel = Provider.of<TeamViewModel>(context, listen: false);
      await teamViewModel.toggleFollowTeam(widget.team.id);

      setState(() {
        _isFollowing = !_isFollowing;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFollowing
                  ? 'Following ${widget.team.name}'
                  : 'Unfollowed ${widget.team.name}',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: _isFollowing
                ? const Color(0xFFFFC600)
                : Colors.grey[700],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      print('Error toggling follow: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFollow = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(isDarkMode),
              const SizedBox(height: 25),
              _buildStatsCards(isDarkMode),
              const SizedBox(height: 25),
              _buildTabBar(isDarkMode),
              const SizedBox(height: 25),
              _buildTabContent(isDarkMode),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Stack(
      children: [
        const SizedBox(width: double.infinity, height: 280),
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
          child: _buildHeaderActions(isDarkMode),
        ),
        Positioned(
          top: 100,
          left: 15,
          right: 15,
          child: _buildTeamCard(isDarkMode),
        ),
      ],
    );
  }

  Widget _buildHeaderActions(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        Text(
          widget.team.name.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        _buildNotificationBell(isDarkMode),
      ],
    );
  }

  Widget _buildTeamCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD30336), Color(0xFFFF6B35)],
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
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildTeamLogo(),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.team.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Team Group: ${widget.team.category.name}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _isLoadingFollow
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : FollowButton(
                        isFollowing: _isFollowing,
                        onToggle: _toggleFollow,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamLogo() {
    final hasValidLogo =
        widget.team.logoUrl.isNotEmpty && widget.team.logoUrl.startsWith('http');

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: hasValidLogo
            ? Image.network(
          widget.team.logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.shield, color: Colors.white, size: 40),
        )
            : const Icon(Icons.shield, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildStatsCards(bool isDarkMode) {
    // Use real statistics if available, otherwise show defaults
    final wins = _teamStats?.wins ?? 0;
    final losses = _teamStats?.losses ?? 0;
    final draws = _teamStats?.draws ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              title: 'Games Won',
              value: wins.toString(),
              isDarkMode: isDarkMode,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              title: 'Games Lost',
              value: losses.toString(),
              isDarkMode: isDarkMode,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatCard(
              title: 'Games Drawn',
              value: draws.toString(),
              isDarkMode: isDarkMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.darkBackground,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDarkMode ? Colors.white : AppColors.darkBackground,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
              colors: [Color(0xFFD30336), Color(0xFFFF6B35)],
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
            Tab(text: 'Team Members'),
            Tab(text: 'Team News'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(bool isDarkMode) {
    return _tabController.index == 0
        ? _buildTeamMembers(isDarkMode)
        : _buildTeamNews(isDarkMode);
  }

  Widget _buildTeamMembers(bool isDarkMode) {
    return FutureBuilder<List<WaoPlayer>>(
      future: _getTeamPlayers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Error loading players',
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

        final players = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
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
                  child: Text(
                    'Team Roster',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : AppColors.darkBackground,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildRosterSections(players, isDarkMode),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<WaoPlayer>> _getTeamPlayers() async {
    final playerService = PlayerService();
    final allPlayerIds = widget.team.roster.getAllPlayerIds();
    final List<WaoPlayer> players = [];

    for (final playerId in allPlayerIds) {
      final player = await playerService.getPlayerById(playerId);
      if (player != null) {
        players.add(player);
      }
    }

    return players;
  }

  Widget _buildRosterSections(List<WaoPlayer> players, bool isDarkMode) {
    return Column(
      children: [
        _buildRosterSection('Coach', [widget.team.coach], isDarkMode, isCoach: true),
        const SizedBox(height: 15),
        _buildPlayerRoleSection(
            'Kings', widget.team.roster.kingIds, players, isDarkMode),
        _buildPlayerRoleSection(
            'Workers', widget.team.roster.workerIds, players, isDarkMode),
        _buildPlayerRoleSection(
            'Protagues', widget.team.roster.protagueIds, players, isDarkMode),
        _buildPlayerRoleSection(
            'Antagues', widget.team.roster.antagueIds, players, isDarkMode),
        _buildPlayerRoleSection(
            'Warriors', widget.team.roster.warriorIds, players, isDarkMode),
        _buildPlayerRoleSection(
            'Sacrificers', widget.team.roster.sacrificerIds, players, isDarkMode),
      ],
    );
  }

  Widget _buildPlayerRoleSection(
      String role, List<String> roleIds, List<WaoPlayer> allPlayers, bool isDarkMode) {
    final rolePlayers = allPlayers.where((p) => roleIds.contains(p.id)).toList();

    if (rolePlayers.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        _buildRosterSection(role, rolePlayers, isDarkMode),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildRosterSection(
      String role, List<dynamic> items, bool isDarkMode,
      {bool isCoach = false}) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFD30336), Color(0xFFFF6B35)],
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
                  '${items.length}',
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
          _buildCoachCard(items[0] as String, isDarkMode)
        else
          ...items.map((player) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _buildPlayerCard(player as WaoPlayer, isDarkMode),
          )),
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
              child: Icon(Icons.sports, color: Colors.white, size: 20),
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
          const Icon(Icons.verified, size: 20, color: Color(0xFFFFC600)),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(WaoPlayer player, bool isDarkMode) {
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
          _buildPlayerAvatar(player, isDarkMode),
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
                const SizedBox(height: 4),
                _buildStatusBadge(player.status, isDarkMode),
              ],
            ),
          ),
          _getRoleIcon(player.role, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildPlayerAvatar(WaoPlayer player, bool isDarkMode) {
    if (player.profileImageUrl != null && player.profileImageUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          player.profileImageUrl!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildDefaultAvatar(player.name, isDarkMode),
        ),
      );
    }
    return _buildDefaultAvatar(player.name, isDarkMode);
  }

  Widget _buildDefaultAvatar(String name, bool isDarkMode) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';
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

  Widget _buildStatusBadge(PlayerStatus status, bool isDarkMode) {
    final statusConfig = _getStatusConfig(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: statusConfig['color'].withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: statusConfig['color'], width: 0.5),
      ),
      child: Text(
        statusConfig['label'],
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: statusConfig['color'],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusConfig(PlayerStatus status) {
    switch (status) {
      case PlayerStatus.active:
        return {'label': 'Active', 'color': Colors.green};
      case PlayerStatus.inactive:
        return {'label': 'Injured', 'color': Colors.orange};
      case PlayerStatus.suspended:
        return {'label': 'Suspended', 'color': Colors.red};
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

  Widget _buildTeamNews(bool isDarkMode) {
    if (_teamNews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40.0),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.article_outlined,
                size: 60,
                color: isDarkMode ? Colors.white24 : Colors.black26,
              ),
              const SizedBox(height: 16),
              Text(
                'No news available for this team',
                style: TextStyle(
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: _teamNews
            .map((news) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildNewsCard(news, isDarkMode),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildNewsCard(NewsModel news, bool isDarkMode) {
    // Calculate time ago
    final now = DateTime.now();
    final difference = now.difference(news.publishedDate);
    String timeAgo;

    if (difference.inDays > 0) {
      timeAgo = '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      timeAgo = '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      timeAgo = '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      timeAgo = 'Just now';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD30336), Color(0xFFFF6B35)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.article, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            news.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black87,
              height: 1.4,
            ),
          ),
          if (news.category != null && news.category!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC600).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFFFC600),
                  width: 0.5,
                ),
              ),
              child: Text(
                news.category!,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFC600),
                ),
              ),
            ),
          ],
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