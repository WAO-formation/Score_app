import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/system_admin/presentation/Teams/view/widgets/team_classes.dart';

import '../../../../shared/custom_text.dart';
import '../../../../shared/theme_data.dart';
import '../../score_board/model/live_score.dart';


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
          const SliverToBoxAdapter(
            child: TeamSectionHeader(title: 'Scoring Overview'),
          ),
          SliverToBoxAdapter(
            child: TeamScoringOverview(
              totalScore: widget.team.totalScore,
              kingdom: widget.team.kingdom,
              workout: widget.team.workout,
              goalpost: widget.team.goalpost,
              judges: widget.team.judges,
            ),
          ),

          // Player Roster Section
          const SliverToBoxAdapter(
            child: TeamSectionHeader(title: 'Player Roster'),
          ),
          SliverToBoxAdapter(
            child: _buildPlayerRoster(),
          ),

          // Match History Section
          const SliverToBoxAdapter(
            child: TeamSectionHeader(title: 'Recent Match History'),
          ),
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

          // Team Stats Row - Using reusable TeamStatCard
          Row(
            children: [
              Expanded(
                child: TeamStatCard(
                  label: 'Position',
                  value: '#${widget.team.tablePosition}',
                  icon: Icons.leaderboard,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TeamStatCard(
                  label: 'Games',
                  value: '${widget.team.totalGames}',
                  icon: Icons.sports_basketball,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TeamStatCard(
                  label: 'Status',
                  value: widget.team.status,
                  icon: Icons.info_outline,
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

          return PlayerRosterItem(
            player: player,
            isLast: isLast,
          );
        }).toList(),
      ),
    );
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

          return MatchHistoryItem(
            match: match,
            isLast: isLast,
            onViewSummary: () {
              // You can customize this action for each team
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('View Summary for ${match.opponent} match')),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}