import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';
import 'package:wao_mobile/ViewModel/teams_games/match_viewmodel.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'match_card.dart';

class AllMatchesSection extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedFilter;

  const AllMatchesSection({
    super.key,
    required this.selectedDate,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<MatchViewModel, TeamViewModel>(
      builder: (context, matchViewModel, teamViewModel, _) {
        return StreamBuilder<List<WaoMatch>>(
          stream: matchViewModel.getMatchesByDate(selectedDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _EmptyState(
                icon: Icons.event_busy_rounded,
                label: 'No matches scheduled for this date',
                isDark: isDark,
              );
            }

            var matches = snapshot.data!
                .where((m) => m.status != MatchStatus.live)
                .toList();

            if (selectedFilter != 'All') {
              matches = matches.where((m) => _matchFilter(m, selectedFilter)).toList();
            }

            if (matches.isEmpty) {
              return _EmptyState(
                icon: Icons.filter_list_off_rounded,
                label: 'No matches for selected filter',
                isDark: isDark,
              );
            }

            final grouped = <MatchType, List<WaoMatch>>{};
            for (final m in matches) {
              grouped.putIfAbsent(m.type, () => []).add(m);
            }

            final followedIds = teamViewModel.followedTeamIds;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: grouped.entries.map((e) => _MatchTypeSection(
                type: e.key,
                matches: e.value,
                followedIds: followedIds,
                matchViewModel: matchViewModel,
                isDark: isDark,
              )).toList(),
            );
          },
        );
      },
    );
  }
}

bool _matchFilter(WaoMatch m, String filter) {
  switch (filter) {
    case 'Friendly':     return m.type == MatchType.friendly;
    case 'Championship': return m.type == MatchType.championship;
    case 'Campus':       return m.type == MatchType.campusInternal;
    default:             return true;
  }
}

// ── Match type section ────────────────────────────────────────────────────────

class _MatchTypeSection extends StatelessWidget {
  const _MatchTypeSection({
    required this.type,
    required this.matches,
    required this.followedIds,
    required this.matchViewModel,
    required this.isDark,
  });

  final MatchType type;
  final List<WaoMatch> matches;
  final Set<String> followedIds;
  final MatchViewModel matchViewModel;
  final bool isDark;

  String get _title {
    switch (type) {
      case MatchType.friendly:      return 'Friendly Matches';
      case MatchType.championship:  return 'Championship';
      case MatchType.campusInternal: return 'Campus Internal';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.waoRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _title,
                style: GoogleFonts.oswald(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.waoRed.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${matches.length}',
                  style: GoogleFonts.oswald(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.waoRed,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: matches.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final m = matches[i];
            return MatchCard(
              match: m,
              isTeamAFollowed: followedIds.contains(m.teamAId),
              isTeamBFollowed: followedIds.contains(m.teamBId),
              onFavoriteTap: () =>
                  matchViewModel.toggleMatchFavorite(m.id, m.isFavorite),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.label, required this.isDark});
  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 52,
              color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.2),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: GoogleFonts.oswald(
                fontSize: 14,
                color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
