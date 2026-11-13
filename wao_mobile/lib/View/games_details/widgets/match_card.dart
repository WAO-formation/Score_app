import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isLive = match.status == MatchStatus.live;
    final isFinished = match.status == MatchStatus.finished;
    final isCancelled = match.status == MatchStatus.cancelled;
    final isPostponed = match.status == MatchStatus.postponed;
    final isSuspended = match.status == MatchStatus.suspended;

    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => isLive
                ? LiveGamesDetails(match: match)
                : UpcomingGameDetails(match: match),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isLive
                ? AppColors.waoRed.withOpacity(0.4)
                : isDark
                    ? Colors.white.withOpacity(0.07)
                    : AppColors.waoNavy.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Status column
            SizedBox(
              width: 52,
              child: _StatusBadge(
                isLive: isLive,
                isFinished: isFinished,
                isCancelled: isCancelled,
                isPostponed: isPostponed,
                isSuspended: isSuspended,
                startTime: match.startTime,
                isDark: isDark,
              ),
            ),

            // Divider
            Container(
              width: 1,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : AppColors.waoNavy.withOpacity(0.08),
            ),

            // Teams
            Expanded(
              child: Column(
                children: [
                  _TeamRow(
                    name: match.teamAName,
                    score: match.scoreA,
                    isDark: isDark,
                    isFollowed: isTeamAFollowed,
                    showScore: isLive || isFinished,
                  ),
                  const SizedBox(height: 10),
                  _TeamRow(
                    name: match.teamBName,
                    score: match.scoreB,
                    isDark: isDark,
                    isFollowed: isTeamBFollowed,
                    showScore: isLive || isFinished,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // Favourite
            GestureDetector(
              onTap: onFavoriteTap,
              child: Icon(
                match.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                size: 22,
                color: match.isFavorite
                    ? AppColors.waoYellow
                    : isDark
                        ? Colors.white24
                        : AppColors.waoNavy.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.isLive,
    required this.isFinished,
    required this.isCancelled,
    required this.isPostponed,
    required this.isSuspended,
    required this.startTime,
    required this.isDark,
  });

  final bool isLive, isFinished, isCancelled, isPostponed, isSuspended;
  final DateTime startTime;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (isLive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.waoRed,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'LIVE',
          textAlign: TextAlign.center,
          style: GoogleFonts.oswald(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    String label;
    Color color;

    if (isFinished) {
      label = 'FT';
      color = isDark ? Colors.white54 : AppColors.waoNavy.withOpacity(0.5);
    } else if (isCancelled) {
      label = 'CANC';
      color = AppColors.waoRed;
    } else if (isPostponed) {
      label = 'PPD';
      color = isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4);
    } else if (isSuspended) {
      label = 'SUSP';
      color = isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4);
    } else {
      label = DateFormat('HH:mm').format(startTime);
      color = isDark ? Colors.white : AppColors.waoNavy;
    }

    return Text(
      label,
      textAlign: TextAlign.center,
      style: GoogleFonts.oswald(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

// ── Team row ──────────────────────────────────────────────────────────────────

class _TeamRow extends StatelessWidget {
  const _TeamRow({
    required this.name,
    required this.score,
    required this.isDark,
    required this.isFollowed,
    required this.showScore,
  });

  final String name;
  final int score;
  final bool isDark, isFollowed, showScore;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Solid initial avatar
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.waoNavy,
          ),
          child: Center(
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'T',
              style: GoogleFonts.oswald(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.oswald(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : AppColors.waoNavy,
            ),
          ),
        ),
        if (isFollowed) ...[
          const SizedBox(width: 4),
          const Icon(Icons.star_rounded, size: 14, color: AppColors.waoYellow),
        ],
        if (showScore) ...[
          const SizedBox(width: 8),
          Text(
            '$score',
            style: GoogleFonts.oswald(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.waoNavy,
            ),
          ),
        ],
      ],
    );
  }
}
