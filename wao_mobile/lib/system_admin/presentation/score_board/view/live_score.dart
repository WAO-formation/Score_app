// live_scores_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import 'package:wao_mobile/system_admin/presentation/score_board/view/score_board.dart';
import '../model/live_score.dart';
import '../../Teams/model/state_management.dart';
import '../../Teams/model/team_model.dart';


class LiveScoresPage extends StatefulWidget {
  const LiveScoresPage({super.key});

  @override
  State<LiveScoresPage> createState() => _LiveScoresPageState();
}

class _LiveScoresPageState extends State<LiveScoresPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveScoreProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Live Scores',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            backgroundColor: lightColorScheme.secondary,
            elevation: 0,

            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(
                  text: 'Live Matches',
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sports_soccer),
                      if (provider.hasLiveMatches) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${provider.ongoingMatches.length}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Tab(
                  text: 'Completed',
                  icon: Icon(Icons.history),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildLiveMatchesTab(provider),
              _buildCompletedMatchesTab(provider),
            ],
          ),
          floatingActionButton: provider.isAdmin
              ? FloatingActionButton(
            onPressed: () => _createNewMatch(context),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add, color: Colors.white),
          )
              : null,
        );
      },
    );
  }

  Widget _buildLiveMatchesTab(LiveScoreProvider provider) {
    final liveMatches = provider.ongoingMatches;

    if (liveMatches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.sports_soccer,
        title: 'No Live Matches',
        subtitle: 'Check back later for ongoing WAO! games',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh - in real app, fetch from API
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: liveMatches.length,
        itemBuilder: (context, index) {
          return LiveMatchCard(
            match: liveMatches[index],
            onTap: () => _viewMatchDetails(context, liveMatches[index]),
            onAdminTap: provider.isAdmin
                ? () => _openAdminControl(context, liveMatches[index])
                : null,
          );
        },
      ),
    );
  }

  Widget _buildCompletedMatchesTab(LiveScoreProvider provider) {
    final endedMatches = provider.endedMatches;

    if (endedMatches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No Completed Matches',
        subtitle: 'Finished games will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: endedMatches.length,
      itemBuilder: (context, index) {
        return CompletedMatchCard(
          match: endedMatches[index],
          onTap: () => _viewMatchDetails(context, endedMatches[index]),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _viewMatchDetails(BuildContext context, LiveMatch match) {
     Navigator.push(
       context,
       MaterialPageRoute(
    builder: (context) => ScoreBoard(matchId: match.id),
      ),
    );
  }

  void _openAdminControl(BuildContext context, LiveMatch match) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AdminScoreController(matchId: match.id),
    //   ),
    // );
  }

  void _toggleAdminMode(BuildContext context, LiveScoreProvider provider) {
    if (!provider.isAdmin) {
      _showAdminLogin(context, provider);
    } else {
      provider.setAdminMode(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Admin mode disabled'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showAdminLogin(BuildContext context, LiveScoreProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Access'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Admin Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // In real app, validate password
              provider.setAdminMode(true);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Admin mode enabled'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  void _showAdminPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const AdminPanel(),
    );
  }

  void _createNewMatch(BuildContext context) {
    // Implementation for creating new match
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create new match feature coming soon!'),
      ),
    );
  }
}

class LiveMatchCard extends StatelessWidget {
  final LiveMatch match;
  final VoidCallback onTap;
  final VoidCallback? onAdminTap;

  const LiveMatchCard({
    super.key,
    required this.match,
    required this.onTap,
    this.onAdminTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Match header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusIndicator(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      match.displayTitle,
                      style:  TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: lightColorScheme.secondary
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Time and quarter info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: match.isLive ? Colors.red : Colors.orange,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${match.quarterDisplayString} - ${match.timeDisplayString}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Teams and scores
              Row(
                children: [
                  Expanded(
                    child: _buildTeamScore(
                      team: match.teamA,
                      score: match.teamAScore,
                      isLeft: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTeamScore(
                      team: match.teamB,
                      score: match.teamBScore,
                      isLeft: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    String text;

    switch (match.status) {
      case MatchStatus.live:
        color = Colors.red;
        text = 'LIVE';
        break;
      case MatchStatus.paused:
        color = Colors.orange;
        text = 'PAUSED';
        break;
      default:
        color = Colors.grey;
        text = 'ENDED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTeamScore({
    required Teams team,
    required LiveScore score,
    required bool isLeft,
  }) {
    return Column(
      crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          team.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: isLeft ? TextAlign.left : TextAlign.right,
        ),
        const SizedBox(height: 10),
        Text(
          score.totalScore.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: lightColorScheme.secondary,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildScoreChip('K', score.kingdom, Colors.purple),
                const SizedBox(width: 4),
                _buildScoreChip('W', score.workout, Colors.orange),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildScoreChip('G', score.goalpost, Colors.green),
                const SizedBox(width: 8),
                _buildScoreChip('J', score.judges, Colors.blue),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreChip(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label:${value.toStringAsFixed(0)}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}


class CompletedMatchCard extends StatelessWidget {
  final LiveMatch match;
  final VoidCallback onTap;

  const CompletedMatchCard({
    super.key,
    required this.match,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final winner = match.teamAScore.totalScore > match.teamBScore.totalScore
        ? match.teamA : match.teamB;
    final isDrawn = match.teamAScore.totalScore == match.teamBScore.totalScore;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      match.displayTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'ENDED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (!isDrawn)
                Text(
                  'Winner: ${winner.name}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                )
              else
                Text(
                  'Match Drawn',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700],
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${match.teamA.name}: ${match.teamAScore.totalScore.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '${match.teamB.name}: ${match.teamBScore.totalScore.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Admin Panel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Create New Match'),
            onTap: () {
              Navigator.pop(context);
              // Implement create match functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Match Settings'),
            onTap: () {
              Navigator.pop(context);
              // Implement settings functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Match History'),
            onTap: () {
              Navigator.pop(context);
              // Implement history functionality
            },
          ),
        ],
      ),
    );
  }
}