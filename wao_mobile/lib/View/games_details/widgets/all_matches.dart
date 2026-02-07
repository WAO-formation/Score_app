import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';
import 'package:wao_mobile/ViewModel/teams_games/match_viewmodel.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';

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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<MatchViewModel, TeamViewModel>(
      builder: (context, matchViewModel, teamViewModel, child) {
        return StreamBuilder<List<WaoMatch>>(
          stream: matchViewModel.getMatchesByDate(selectedDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_busy,
                        size: 64,
                        color: isDarkMode ? Colors.white30 : Colors.black26,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No matches scheduled for this date',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Filter out live matches (they're shown in live section)
            var filteredMatches = snapshot.data!
                .where((match) => match.status != MatchStatus.live)
                .toList();

            // Apply category filter
            if (selectedFilter != 'All') {
              filteredMatches = filteredMatches.where((match) {
                switch (selectedFilter) {
                  case 'Friendly':
                    return match.type == MatchType.friendly;
                  case 'Championship':
                    return match.type == MatchType.championship;
                  case 'Campus':
                    return match.type == MatchType.campusInternal;
                  default:
                    return true;
                }
              }).toList();
            }

            if (filteredMatches.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.filter_list_off,
                        size: 64,
                        color: isDarkMode ? Colors.white30 : Colors.black26,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No matches found for selected filter',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Group matches by type
            final Map<MatchType, List<WaoMatch>> groupedMatches = {};
            for (var match in filteredMatches) {
              groupedMatches.putIfAbsent(match.type, () => []).add(match);
            }

            final followedTeamIds = teamViewModel.followedTeamIds;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupedMatches.entries.map((entry) {
                return MatchTypeSection(
                  type: entry.key,
                  matches: entry.value,
                  followedTeamIds: followedTeamIds,
                  matchViewModel: matchViewModel,
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}

class MatchTypeSection extends StatelessWidget {
  final MatchType type;
  final List<WaoMatch> matches;
  final Set<String> followedTeamIds;
  final MatchViewModel matchViewModel;

  const MatchTypeSection({
    super.key,
    required this.type,
    required this.matches,
    required this.followedTeamIds,
    required this.matchViewModel,
  });

  String _getTypeTitle(MatchType type) {
    switch (type) {
      case MatchType.friendly:
        return 'Friendly Matches';
      case MatchType.championship:
        return 'Championship';
      case MatchType.campusInternal:
        return 'Campus Internal';
    }
  }

  IconData _getTypeIcon(MatchType type) {
    switch (type) {
      case MatchType.friendly:
        return Icons.handshake;
      case MatchType.championship:
        return Icons.emoji_events;
      case MatchType.campusInternal:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTypeIcon(type),
                  size: 20,
                  color: isDarkMode ? Colors.white70 : const Color(0xFF011B3B),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _getTypeTitle(type),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.15)
                      : Colors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${matches.length}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.white30 : Colors.black26,
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: matches.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final match = matches[index];
            final isTeamAFollowed = followedTeamIds.contains(match.teamAId);
            final isTeamBFollowed = followedTeamIds.contains(match.teamBId);

            return MatchCard(
              match: match,
              isTeamAFollowed: isTeamAFollowed,
              isTeamBFollowed: isTeamBFollowed,
              onFavoriteTap: () {
                matchViewModel.toggleMatchFavorite(match.id, match.isFavorite);
              },
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}