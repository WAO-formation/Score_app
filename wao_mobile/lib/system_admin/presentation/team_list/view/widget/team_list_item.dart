import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../presentation/user/teams/models/teams_models.dart';
import '../../../score_board/model/live_score.dart';
import '../../../Teams/model/team_model.dart';
import '../../../match_sheduling/models/match_models.dart';

class TeamListItem extends StatelessWidget {
  final Teams teams;
  final VoidCallback? onTap;

  const TeamListItem({
    super.key,
    required this.teams,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Team Logo
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
                child: teams.logoUrl.isNotEmpty
                    ? (teams.logoUrl.startsWith('http')
                    ? ClipOval(
                  child: Image.network(
                    teams.logoUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.sports,
                        size: 30,
                        color: Colors.grey[600],
                      );
                    },
                  ),
                )
                    : ClipOval(
                  child: Image.asset(
                    teams.logoUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.sports,
                        size: 30,
                        color: Colors.grey[600],
                      );
                    },
                  ),
                ))
                    : Icon(
                  Icons.sports,
                  size: 30,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),

              // Team Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            teams.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _buildPositionBadge(),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      teams.region,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatChip('Games: ${teams.totalGames}'),
                        const SizedBox(width: 8),
                        _buildStatusChip(),
                      ],
                    ),
                  ],
                ),
              ),

              // Score and Arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${teams.totalScore.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd').format(teams.lastMatchDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPositionColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '#${teams.tablePosition}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color color = teams.status == 'Active' ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        teams.status,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPositionColor() {
    if (teams.tablePosition <= 3) {
      return Colors.amber; // Changed from Colors.gold (which doesn't exist)
    } else if (teams.tablePosition <= 5) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }
}