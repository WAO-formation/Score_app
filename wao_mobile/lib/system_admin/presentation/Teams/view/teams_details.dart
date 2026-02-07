import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/theme_data.dart';
import '../model/team_model.dart';




class TeamDetailsPage extends StatefulWidget {
  final Teams team;

  const TeamDetailsPage({
    super.key,
    required this.team,
  });

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 140 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <= 140 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: _showAppBarTitle ? 2 : 0,
        scrolledUnderElevation: 0,
        backgroundColor: _showAppBarTitle ? lightColorScheme.secondary : Colors.transparent,
        title: AnimatedOpacity(
          opacity: _showAppBarTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: Text(
            widget.team.name,
            style: AppStyles.secondaryTitle.copyWith(
              color: lightColorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: _showAppBarTitle ? lightColorScheme.onPrimary : Colors.white,
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Team Header Section
          SliverToBoxAdapter(
            child: _buildTeamHeader(),
          ),

          // Scoring Overview Section
          _buildSectionHeader('Scoring Overview'),
          SliverToBoxAdapter(
            child: _buildScoringOverview(),
          ),

          // Player Roster Section
          _buildSectionHeader('Player Roster'),
          SliverToBoxAdapter(
            child: _buildPlayerRoster(),
          ),

          // Match History Section
          _buildSectionHeader('Recent Match History'),
          SliverToBoxAdapter(
            child: _buildMatchHistory(),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 70,
        bottom: 30,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: lightColorScheme.secondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Team Logo and Name
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(widget.team.logoUrl),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.team.name,
                      style: TextStyle(
                        color: lightColorScheme.onPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.team.region,
                      style: TextStyle(
                        color: lightColorScheme.onPrimary.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Team Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Position',
                  '#${widget.team.tablePosition}',
                  Icons.leaderboard,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Games',
                  '${widget.team.totalGames}',
                  Icons.sports_basketball,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  'Status',
                  widget.team.status,
                  Icons.info_outline,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Last Match Date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  color: lightColorScheme.onPrimary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Last Match: ${DateFormat('MMM dd, yyyy').format(widget.team.lastMatchDate)}',
                  style: TextStyle(
                    color: lightColorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: lightColorScheme.onPrimary,
            size: 20,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: lightColorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: lightColorScheme.onPrimary.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 15),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: lightColorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoringOverview() {
    // Find best and worst categories
    Map<String, double> scores = {
      'Kingdom': widget.team.kingdom,
      'Workout': widget.team.workout,
      'Goalpost': widget.team.goalpost,
      'Judges': widget.team.judges,
    };

    String bestCategory = scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    String worstCategory = scores.entries.reduce((a, b) => a.value < b.value ? a : b).key;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Total Score
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: lightColorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  '${widget.team.totalScore.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Individual Scores
          _buildScoreRow('Kingdom Score', widget.team.kingdom, Icons.castle, bestCategory == 'Kingdom', worstCategory == 'Kingdom'),
          _buildScoreRow('Workout Score', widget.team.workout, Icons.fitness_center, bestCategory == 'Workout', worstCategory == 'Workout'),
          _buildScoreRow('Goalpost Score', widget.team.goalpost, Icons.sports_soccer, bestCategory == 'Goalpost', worstCategory == 'Goalpost'),
          _buildScoreRow('Judges Score', widget.team.judges, Icons.people, bestCategory == 'Judges', worstCategory == 'Judges'),

          const SizedBox(height: 15),

          // Best/Worst indicators
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.green[600], size: 16),
                      const SizedBox(width: 5),
                      Text(
                        'Best: $bestCategory',
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_down, color: Colors.red[600], size: 16),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Needs Work: $worstCategory',
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String title, double score, IconData icon, bool isBest, bool isWorst) {
    Color? bgColor;
    if (isBest) bgColor = Colors.green[50];
    if (isWorst) bgColor = Colors.red[50];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: lightColorScheme.secondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Text(
            '${score.toStringAsFixed(1)}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: lightColorScheme.secondary,
              fontSize: 16,
            ),
          ),
          if (isBest) ...[
            const SizedBox(width: 8),
            Icon(Icons.star, color: Colors.green[600], size: 16),
          ],
          if (isWorst) ...[
            const SizedBox(width: 8),
            Icon(Icons.warning_amber, color: Colors.red[600], size: 16),
          ],
        ],
      ),
    );
  }

  Widget _buildPlayerRoster() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: widget.team.players.asMap().entries.map((entry) {
          int index = entry.key;
          Player player = entry.value;
          bool isLast = index == widget.team.players.length - 1;

          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: isLast ? null : Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                // Player Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: _getRoleColor(player.role),
                  child: Text(
                    player.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // Player Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              player.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          _buildStatusChip(player.status),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          _buildRoleChip(player.role),
                          const SizedBox(width: 10),
                          Text(
                            'Games: ${player.gamesPlayed}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Fouls: ${player.fouls}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Performance Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: lightColorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${player.performanceScore.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: lightColorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _getRoleColor(role).withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: _getRoleColor(role),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = Colors.green;
        break;
      case 'injured':
        color = Colors.orange;
        break;
      case 'suspended':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: Colors.green,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'king':
        return Colors.purple;
      case 'worker':
        return Colors.blue;
      case 'defender':
        return Colors.red;
      case 'attacker':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMatchHistory() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: widget.team.matches.asMap().entries.map((entry) {
          int index = entry.key;
          MatchRecord match = entry.value;
          bool isLast = index == widget.team.matches.length - 1;

          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              border: isLast ? null : Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Column(
              children: [
                // Match Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'vs ${match.opponent}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy').format(match.date),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildResultChip(match.result),
                    const SizedBox(width: 10),
                    Text(
                      '${match.totalScore.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: lightColorScheme.secondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Score Breakdown
                Row(
                  children: [
                    Expanded(
                      child: _buildMiniScoreCard('K', match.kingdom),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildMiniScoreCard('W', match.workout),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildMiniScoreCard('G', match.goalpost),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: _buildMiniScoreCard('J', match.judges),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        // Placeholder for view summary
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('View Summary - Coming Soon')),
                        );
                      },
                      child: Text(
                        'View Summary',
                        style: TextStyle(
                          color: lightColorScheme.secondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResultChip(String result) {
    Color color;
    switch (result.toLowerCase()) {
      case 'win':
        color = Colors.green;
        break;
      case 'loss':
        color = Colors.red;
        break;
      case 'draw':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        result,
        style: TextStyle(
          color:Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildMiniScoreCard(String label, double score) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            score.toStringAsFixed(1),
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
