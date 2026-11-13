import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';
import 'package:wao_mobile/View/games_details/past_match_details.dart';
import 'package:wao_mobile/ViewModel/teams_games/match_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

/// A team's finished-match history. Deliberately not gated to any one role
/// — match results are already public data any signed-in user can read
/// (see firestore.rules' `matches` read rule) — so this is reusable from a
/// player profile, a team's own activities tab, or anywhere else someone
/// should be able to see "what has this team actually played."
class MatchHistoryList extends StatelessWidget {
  const MatchHistoryList({
    super.key,
    required this.teamId,
    required this.isDark,
    this.emptyLabel,
  });

  final String teamId;
  final bool isDark;
  final String? emptyLabel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WaoMatch>>(
      stream: context.read<MatchViewModel>().getTeamMatches(teamId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final finished = (snapshot.data ?? [])
            .where((m) => m.status == MatchStatus.finished)
            .toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));

        if (finished.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: _cardDecor(isDark),
            child: Center(
              child: Text(
                emptyLabel ?? 'No past games yet',
                textAlign: TextAlign.center,
                style: GoogleFonts.oswald(
                  fontSize: 14,
                  color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
                ),
              ),
            ),
          );
        }

        return Column(
          children: finished
              .map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _MatchHistoryTile(match: m, ourTeamId: teamId, isDark: isDark),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _MatchHistoryTile extends StatelessWidget {
  const _MatchHistoryTile({required this.match, required this.ourTeamId, required this.isDark});
  final WaoMatch match;
  final String ourTeamId;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final opponent = match.teamAId == ourTeamId ? match.teamBName : match.teamAName;
    final ourScore = match.teamAId == ourTeamId ? match.scoreA : match.scoreB;
    final theirScore = match.teamAId == ourTeamId ? match.scoreB : match.scoreA;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PastMatchDetails(match: match)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecor(isDark),
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
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: isDark ? Colors.white.withOpacity(0.08) : AppColors.waoNavy.withOpacity(0.08),
            ),
            Expanded(
              child: Text(
                'vs $opponent',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.oswald(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                ),
              ),
            ),
            Text(
              '$ourScore - $theirScore',
              style: GoogleFonts.oswald(
                fontSize: 15,
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

BoxDecoration _cardDecor(bool isDark) => BoxDecoration(
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
    );
