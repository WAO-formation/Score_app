import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/theme_data.dart';
import '../../../score_board/model/live_score.dart';


/// Reusable stat card for team details
class TeamStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const TeamStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
}

/// Reusable section header for team pages
class TeamSectionHeader extends StatelessWidget {
  final String title;

  const TeamSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

/// Reusable score row for team scoring overview
class TeamScoreRow extends StatelessWidget {
  final String title;
  final double score;
  final IconData icon;
  final bool isBest;
  final bool isWorst;

  const TeamScoreRow({
    super.key,
    required this.title,
    required this.score,
    required this.icon,
    this.isBest = false,
    this.isWorst = false,
  });

  @override
  Widget build(BuildContext context) {
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
}

/// Reusable role chip for players
class PlayerRoleChip extends StatelessWidget {
  final String role;

  const PlayerRoleChip({
    super.key,
    required this.role,
  });

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

  @override
  Widget build(BuildContext context) {
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
}

/// Reusable status chip for players
class PlayerStatusChip extends StatelessWidget {
  final String status;

  const PlayerStatusChip({
    super.key,
    required this.status,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'injured':
        return Colors.orange;
      case 'suspended':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Reusable result chip for matches
class MatchResultChip extends StatelessWidget {
  final String result;

  const MatchResultChip({
    super.key,
    required this.result,
  });

  Color _getResultColor(String result) {
    switch (result.toLowerCase()) {
      case 'won':
        return Colors.green;
      case 'lost':
        return Colors.red;
      case 'draw':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = _getResultColor(result);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        result,
        style: TextStyle(
          color: color, // Fixed: Now uses dynamic color instead of hardcoded green
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Reusable mini score card for match breakdowns
class MiniScoreCard extends StatelessWidget {
  final String label;
  final double score;

  const MiniScoreCard({
    super.key,
    required this.label,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
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

/// Reusable player roster item
class PlayerRosterItem extends StatelessWidget {
  final Player player;
  final bool isLast;

  const PlayerRosterItem({
    super.key,
    required this.player,
    this.isLast = false,
  });

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

  @override
  Widget build(BuildContext context) {
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
                    PlayerStatusChip(status: player.status),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    PlayerRoleChip(role: player.role),
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
              player.performanceScore.toStringAsFixed(1),
              style: TextStyle(
                color: lightColorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable match history item
class MatchHistoryItem extends StatelessWidget {
  final MatchRecord match;
  final bool isLast;
  final VoidCallback? onViewSummary;

  const MatchHistoryItem({
    super.key,
    required this.match,
    this.isLast = false,
    this.onViewSummary,
  });

  @override
  Widget build(BuildContext context) {
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
              MatchResultChip(result: match.result),
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
                child: MiniScoreCard(label: 'K', score: match.kingdom),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: MiniScoreCard(label: 'W', score: match.workout),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: MiniScoreCard(label: 'G', score: match.goalpost),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: MiniScoreCard(label: 'J', score: match.judges),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: onViewSummary ?? () {
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
  }
}

/// Reusable scoring overview container
class TeamScoringOverview extends StatelessWidget {
  final double totalScore;
  final double kingdom;
  final double workout;
  final double goalpost;
  final double judges;

  const TeamScoringOverview({
    super.key,
    required this.totalScore,
    required this.kingdom,
    required this.workout,
    required this.goalpost,
    required this.judges,
  });

  @override
  Widget build(BuildContext context) {
    // Find best and worst categories
    Map<String, double> scores = {
      'Kingdom': kingdom,
      'Workout': workout,
      'Goalpost': goalpost,
      'Judges': judges,
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
                  '${totalScore.toStringAsFixed(1)}%',
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
          TeamScoreRow(
            title: 'Kingdom Score',
            score: kingdom,
            icon: Icons.castle,
            isBest: bestCategory == 'Kingdom',
            isWorst: worstCategory == 'Kingdom',
          ),
          TeamScoreRow(
            title: 'Workout Score',
            score: workout,
            icon: Icons.fitness_center,
            isBest: bestCategory == 'Workout',
            isWorst: worstCategory == 'Workout',
          ),
          TeamScoreRow(
            title: 'Goalpost Score',
            score: goalpost,
            icon: Icons.sports_soccer,
            isBest: bestCategory == 'Goalpost',
            isWorst: worstCategory == 'Goalpost',
          ),
          TeamScoreRow(
            title: 'Judges Score',
            score: judges,
            icon: Icons.people,
            isBest: bestCategory == 'Judges',
            isWorst: worstCategory == 'Judges',
          ),

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
}