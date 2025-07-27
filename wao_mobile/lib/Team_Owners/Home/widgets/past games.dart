import 'package:flutter/material.dart';
import '../../../system_admin/presentation/Teams/view/widgets/team_classes.dart';
import '../../../system_admin/presentation/score_board/model/live_score.dart';
import '../../../widgets/top_snackbar_styles.dart';



class MatchHistory extends StatelessWidget {
  final Teams team;

  const MatchHistory({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {

    if (team.matches.isEmpty) {
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
        child: const Column(
          children: [
            Icon(
              Icons.sports_soccer,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No match history available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white24,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.history,
                  size: 24,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Match History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                Text(
                  '${team.matches.length} matches',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(
            height: 1,
            color: Colors.grey[200],
          ),

          // Match list
          Column(
            children: team.matches.asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              MatchRecord match = entry.value;
              bool isLast = index == team.matches.length - 1;

              return MatchHistoryItem(
                match: match,
                isLast: isLast,
                onViewSummary: () => _handleViewSummary(context, match),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _handleViewSummary(BuildContext context, MatchRecord match) {
    TopSnackBarStyles.info(
      context,
      title: 'Notice',
      message: 'Please the match statistics functionality is not available at the moment',
    );
  }
}
