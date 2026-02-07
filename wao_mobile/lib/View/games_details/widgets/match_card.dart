import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';
import 'package:wao_mobile/View/games_details/upcoming_game_details.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

import '../live_game_details.dart';

class MatchCard extends StatelessWidget {
  final WaoMatch match;
  final bool isTeamAFollowed;
  final bool isTeamBFollowed;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const MatchCard({
    super.key,
    required this.match,
    this.isTeamAFollowed = false,
    this.isTeamBFollowed = false,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isLive = match.status == MatchStatus.live;
    final isFinished = match.status == MatchStatus.finished;

    return GestureDetector(
      onTap: onTap ?? () {
       if(isLive){
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => LiveGamesDetails(match: match),
           ),
         );
       }else{
         Navigator.push(
           context,
           MaterialPageRoute(
             builder: (context) => UpcomingGameDetails(match: match),
           ),
         );
       }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.white.withOpacity(0.05)
              : Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isLive
                ? Colors.red.withOpacity(0.3)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Time or Status
            _buildTimeColumn(isDarkMode, isLive, isFinished),
            const SizedBox(width: 12),
            // Teams and Scores
            Expanded(
              child: Column(
                children: [
                  _TeamRow(
                    teamName: match.teamAName,
                    score: match.scoreA,
                    isDarkMode: isDarkMode,
                    isFollowed: isTeamAFollowed,
                    showScore: isLive || isFinished,
                  ),
                  const SizedBox(height: 12),
                  _TeamRow(
                    teamName: match.teamBName,
                    score: match.scoreB,
                    isDarkMode: isDarkMode,
                    isFollowed: isTeamBFollowed,
                    showScore: isLive || isFinished,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Notifications and Favorite
            _buildActionColumn(isDarkMode, isTeamAFollowed, isTeamBFollowed),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn(bool isDarkMode, bool isLive, bool isFinished) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          if (isLive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (isFinished)
            Text(
              'FT',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            )
          else
            Text(
              DateFormat('HH:mm').format(match.startTime),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionColumn(bool isDarkMode, bool isTeamAFollowed, bool isTeamBFollowed) {
    return Column(
      children: [
        Icon(
          Icons.notifications_outlined,
          size: 20,
          color: isDarkMode ? Colors.white30 : Colors.black26,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onFavoriteTap, // UPDATED
          child: Icon(
            match.isFavorite ? Icons.star : Icons.star_border, // UPDATED
            size: 20,
            color: match.isFavorite // UPDATED
                ? AppColors.waoYellow
                : isDarkMode
                ? Colors.white30
                : Colors.black26,
          ),
        ),
      ],
    );
  }
}

class _TeamRow extends StatelessWidget {
  final String teamName;
  final int score;
  final bool isDarkMode;
  final bool isFollowed;
  final bool showScore;

  const _TeamRow({
    required this.teamName,
    required this.score,
    required this.isDarkMode,
    this.isFollowed = false,
    this.showScore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Team Logo (placeholder)
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              teamName.isNotEmpty ? teamName[0].toUpperCase() : 'T',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Team Name
        Expanded(
          child: Text(
            teamName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Star if followed
        if (isFollowed) ...[
          const SizedBox(width: 8),
          const Icon(
            Icons.star,
            size: 16,
            color: AppColors.waoYellow,
          ),
        ],
        // Score
        if (showScore) ...[
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              score.toString(),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ],
    );
  }
}