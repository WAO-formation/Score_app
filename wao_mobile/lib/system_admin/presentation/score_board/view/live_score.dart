// Fixed LiveScoresPage with proper MatchStateManager integration
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import 'package:wao_mobile/system_admin/presentation/score_board/view/score_board.dart';
import '../model/live_score.dart';
import '../../Teams/model/team_model.dart';
import '../view_model/match-state.dart';
import '../view_model/sample_matches.dart';


class LiveScoresPage extends StatefulWidget {
  const LiveScoresPage({super.key});

  @override
  State<LiveScoresPage> createState() => _LiveScoresPageState();
}

class _LiveScoresPageState extends State<LiveScoresPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late MatchStateManager _matchManager;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _matchManager = MatchStateManager();
    _initializeMatchManager();
  }

  Future<void> _initializeMatchManager() async {
    try {
      await _matchManager.initialize();

      // Add sample matches if no matches exist
      if (_matchManager.matches.isEmpty) {
        final sampleMatches = SampleLiveMatchGenerator.createMultipleSampleMatches(3);
        for (final match in sampleMatches) {
          await _matchManager.updateMatch(match);
        }
      }

      // Listen to match updates
      _matchManager.addListener(_onMatchesUpdated);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error initializing match manager: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onMatchesUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _matchManager.removeListener(_onMatchesUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Live Scores'),
          backgroundColor: lightColorScheme.secondary,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                  if (_matchManager.liveMatches.isNotEmpty) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_matchManager.liveMatches.length}',
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
          _buildLiveMatchesTab(),
          _buildCompletedMatchesTab(),
        ],
      ),
    );
  }

  Widget _buildLiveMatchesTab() {
    final liveMatches = _matchManager.liveMatches;

    if (liveMatches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.sports_soccer,
        title: 'No Live Matches',
        subtitle: 'Create a new match or check back later for ongoing WAO! games',
        actionButton: ElevatedButton.icon(
          onPressed: () => _createNewMatch(context),
          icon: const Icon(Icons.add),
          label: const Text('Create Match'),
          style: ElevatedButton.styleFrom(
            backgroundColor: lightColorScheme.secondary,
            foregroundColor: Colors.white,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _matchManager.initialize();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: liveMatches.length,
        itemBuilder: (context, index) {
          return StreamBuilder<LiveMatch>(
            stream: _matchManager.getMatchStream(liveMatches[index].id),
            initialData: liveMatches[index],
            builder: (context, snapshot) {
              final match = snapshot.data ?? liveMatches[index];
              return LiveMatchCard(
                key: ValueKey(match.id),
                match: match,
                onTap: () => _viewMatchDetails(context, match),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCompletedMatchesTab() {
    final completedMatches = _matchManager.completedMatches;

    if (completedMatches.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No Completed Matches',
        subtitle: 'Finished games will appear here',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedMatches.length,
      itemBuilder: (context, index) {
        return CompletedMatchCard(
          match: completedMatches[index],
          onTap: () => _viewMatchDetails(context, completedMatches[index]),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? actionButton,
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
          if (actionButton != null) ...[
            const SizedBox(height: 24),
            actionButton,
          ],
        ],
      ),
    );
  }

  void _viewMatchDetails(BuildContext context, LiveMatch match) async {
    await _matchManager.setActiveMatch(match.id);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScoreBoard(matchId: match.id),
        ),
      );
    }
  }

  void _createNewMatch(BuildContext context) async {
    try {
      // Create a new sample match
      final newMatch = SampleLiveMatchGenerator.createLiveMatchScenario(
        scenario: 'just_started',
      );

      await _matchManager.updateMatch(newMatch);
      await _matchManager.setActiveMatch(newMatch.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('New match created: ${newMatch.displayTitle}'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () => _viewMatchDetails(context, newMatch),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating match: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Updated LiveMatchCard with proper integration
class LiveMatchCard extends StatefulWidget {
  final LiveMatch match;
  final VoidCallback onTap;

  const LiveMatchCard({
    super.key,
    required this.match,
    required this.onTap,
  });

  @override
  State<LiveMatchCard> createState() => _LiveMatchCardState();
}

class _LiveMatchCardState extends State<LiveMatchCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.match.isLive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(LiveMatchCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.match.isLive && !oldWidget.match.isLive) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.match.isLive && oldWidget.match.isLive) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Duration get _remainingTime {
    Duration quarterDuration = widget.match.quarterDuration;
    Duration elapsed = widget.match.currentTime;
    Duration remaining = quarterDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get _countdownDisplayString {
    Duration remaining = _remainingTime;
    int minutes = remaining.inMinutes;
    int seconds = remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Match header with unique match ID display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusIndicator(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.match.displayTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: lightColorScheme.secondary,
                          ),
                        ),
                        Text(
                          'Match ID: ${widget.match.id}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Time and quarter info with unique countdown
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: widget.match.isLive ? _pulseAnimation.value : 1.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: widget.match.isLive ? Colors.red :
                            widget.match.isPaused ? Colors.orange : Colors.grey,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.match.quarterDisplayString,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _countdownDisplayString,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                ),
                              ),
                              Text(
                                'Remaining',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Teams and scores
              Row(
                children: [
                  Expanded(
                    child: _buildTeamScore(
                      team: widget.match.teamA,
                      score: widget.match.teamAScore,
                      isLeft: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      const Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Goals: ${widget.match.teamAScore.goals + widget.match.teamBScore.goals}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTeamScore(
                      team: widget.match.teamB,
                      score: widget.match.teamBScore,
                      isLeft: false,
                    ),
                  ),
                ],
              ),

              // Event count indicator
              if (widget.match.events.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.match.events.length} events • Goals: ${widget.match.teamAScore.goals + widget.match.teamBScore.goals}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    String text;

    switch (widget.match.status) {
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

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.match.isLive ? _pulseAnimation.value : 1.0,
          child: Container(
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
          ),
        );
      },
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
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: isLeft ? TextAlign.left : TextAlign.right,
        ),
        const SizedBox(height: 8),

        // Total Score
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: lightColorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: lightColorScheme.secondary.withOpacity(0.3)),
          ),
          child: Text(
            score.totalScore.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: lightColorScheme.secondary,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Goals display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Text(
            'Goals: ${score.goals}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Individual scores breakdown
        Column(
          crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildScoreChip('Kg', score.kingdom, Colors.purple),
                const SizedBox(width: 4),
                _buildScoreChip('Wk', score.workout, Colors.orange),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildScoreChip('Gp', score.goalpost, Colors.green),
                const SizedBox(width: 4),
                _buildScoreChip('Jg', score.judges, Colors.blue),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreChip(String label, double value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        '$label:${value.toStringAsFixed(0)}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// CompletedMatchCard widget
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
              const SizedBox(height: 12),

              // Winner/Draw info
              if (!isDrawn)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Winner: ${winner.name}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Match Drawn',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[700],
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Final scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          match.teamA.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          match.teamAScore.totalScore.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lightColorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          match.teamB.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          match.teamBScore.totalScore.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lightColorScheme.secondary,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                'Final Quarter: ${match.quarterDisplayString}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}