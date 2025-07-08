import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import the corrected Teams model
import '../../score_board/model/live_score.dart';
import '../../Teams/model/team_model.dart';


class TeamListItem extends StatelessWidget {
  final Teams team;
  final VoidCallback? onTap;

  const TeamListItem({
    super.key,
    required this.team,
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
                child: _buildTeamLogo(),
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
                            team.name,
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
                      team.region,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildStatChip('Games: ${team.totalGames}'),
                        const SizedBox(width: 8),
                        _buildStatChip('Players: ${team.players.length}'),
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
                    team.totalScore.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last Match',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd').format(team.lastMatchDate),
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

  Widget _buildTeamLogo() {
    if (team.logoUrl.isNotEmpty && team.logoUrl.startsWith('http')) {
      // Handle network images
      return ClipOval(
        child: Image.network(
          team.logoUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultLogo();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildDefaultLogo();
          },
        ),
      );
    } else if (team.logoUrl.isNotEmpty) {
      // Handle local assets
      return ClipOval(
        child: Image.asset(
          team.logoUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultLogo();
          },
        ),
      );
    } else {
      return _buildDefaultLogo();
    }
  }

  Widget _buildDefaultLogo() {
    return Icon(
      Icons.sports,
      size: 30,
      color: Colors.grey[600],
    );
  }

  Widget _buildPositionBadge() {
    // Only show position badge if position is greater than 0
    if (team.tablePosition > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getPositionColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '#${team.tablePosition}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
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
    // Capitalize first letter and handle the status from our model
    String displayStatus = team.status.toLowerCase() == 'active' ? 'Active' : 'Inactive';
    Color color = team.status.toLowerCase() == 'active' ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayStatus,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getPositionColor() {
    if (team.tablePosition <= 3) {
      return Colors.amber; // Gold color for top 3
    } else if (team.tablePosition <= 5) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }
}

// Example usage widget to demonstrate the corrected TeamListItem
class TeamListExample extends StatelessWidget {
  const TeamListExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Get sample teams using the corrected model
    List<Teams> sampleTeams = Teams.getSampleTeams();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team List'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: sampleTeams.length,
        itemBuilder: (context, index) {
          return TeamListItem(
            team: sampleTeams[index],
            onTap: () {
              // Handle team selection
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selected: ${sampleTeams[index].name}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}