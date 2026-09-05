import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';
import 'package:wao_mobile/Model/user_provider.dart';
import 'package:wao_mobile/View/games_details/past_match_details.dart';
import 'package:wao_mobile/ViewModel/teams_games/match_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

/// A fan's "Past Games" — finished matches for the teams they follow
/// (favoriteTeamIds), or a general finished-games feed if they haven't
/// followed any team yet. Distinct from MatchHistoryList (games_details/
/// widgets), which is scoped to one specific team's page — this one spans
/// however many teams a fan follows, in a single reverse-chronological feed.
class FanMatchHistoryPage extends StatelessWidget {
  const FanMatchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteTeamIds = context.watch<UserProvider>().userProfile?.favoriteTeamIds ?? const [];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : AppColors.waoNavy.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : AppColors.waoNavy.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: isDark ? Colors.white : AppColors.waoNavy,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Past Games',
                    style: GoogleFonts.oswald(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                favoriteTeamIds.isEmpty
                    ? 'Recent finished games across WAO'
                    : 'Finished games for the teams you follow',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _PastGamesFeed(favoriteTeamIds: favoriteTeamIds, isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

class _PastGamesFeed extends StatelessWidget {
  const _PastGamesFeed({required this.favoriteTeamIds, required this.isDark});
  final List<String> favoriteTeamIds;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final matchViewModel = context.read<MatchViewModel>();
    final stream = favoriteTeamIds.isEmpty
        ? matchViewModel.getFinishedMatches()
        : matchViewModel.getMatchesForTeams(favoriteTeamIds);

    return StreamBuilder<List<WaoMatch>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final finished = (snapshot.data ?? [])
            .where((m) => m.status == MatchStatus.finished)
            .toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));

        if (finished.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 56,
                    color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.2),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No past games yet',
                    style: GoogleFonts.oswald(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white60 : AppColors.waoNavy.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    favoriteTeamIds.isEmpty
                        ? 'Finished games will show up here once played.'
                        : 'Your followed teams haven\'t finished a game yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.35),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          physics: const BouncingScrollPhysics(),
          itemCount: finished.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) => _PastGameTile(match: finished[i], isDark: isDark),
        );
      },
    );
  }
}

class _PastGameTile extends StatelessWidget {
  const _PastGameTile({required this.match, required this.isDark});
  final WaoMatch match;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PastMatchDetails(match: match)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : AppColors.waoNavy.withOpacity(0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 46,
              child: Text(
                DateFormat('MMM d').format(match.startTime),
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white70 : AppColors.waoNavy.withOpacity(0.7),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: isDark ? Colors.white.withOpacity(0.08) : AppColors.waoNavy.withOpacity(0.08),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${match.teamAName} vs ${match.teamBName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    match.venue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${match.scoreA} - ${match.scoreB}',
              style: GoogleFonts.oswald(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.waoNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
