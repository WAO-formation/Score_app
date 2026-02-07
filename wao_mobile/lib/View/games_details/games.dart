import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/View/games_details/widgets/live_matchs.dart';
import 'package:wao_mobile/View/games_details/widgets/match_card.dart';
import 'package:wao_mobile/View/games_details/widgets/match_header.dart';
import 'package:wao_mobile/ViewModel/teams_games/match_viewmodel.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import '../../Model/teams_games/wao_match.dart';
import 'widgets/date_filter.dart';
import 'widgets/all_matches.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Friendly', 'Championship', 'Campus'];

  @override
  void initState() {
    super.initState();
    _initializeViewModel();
  }

  void _initializeViewModel() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final matchViewModel = Provider.of<MatchViewModel>(context, listen: false);
          final teamViewModel = Provider.of<TeamViewModel>(context, listen: false);
          matchViewModel.initialize();
          teamViewModel.initialize(user.uid);
        }
      });
    }
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          // Add top safe area padding
          SizedBox(height: MediaQuery.of(context).padding.top),

          // Fixed header and date filter
          const MatchesHeader(),

          const SizedBox(height: 15),

          DateFilter(
            selectedDate: selectedDate,
            onDateSelected: _onDateSelected,
          ),

          const SizedBox(height: 20),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100.0), // Space for bottom nav
                child: Column(
                  children: [
                    CategoryFilter(
                      filters: filters,
                      selectedFilter: selectedFilter,
                      onFilterSelected: _onFilterSelected,
                    ),

                    const SizedBox(height: 20),

                    // My Favorites Section
                    FavoritesMatchesSection(
                      selectedDate: selectedDate,
                      selectedFilter: selectedFilter,
                    ),

                    const SizedBox(height: 24),

                    const LiveMatchesSection(),

                    const SizedBox(height: 16),

                    // All Matches Section
                    AllMatchesSection(
                      selectedDate: selectedDate,
                      selectedFilter: selectedFilter,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// favourites section
class FavoritesMatchesSection extends StatelessWidget {
  final DateTime selectedDate;
  final String selectedFilter;

  const FavoritesMatchesSection({
    super.key,
    required this.selectedDate,
    required this.selectedFilter,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<TeamViewModel, MatchViewModel>(
      builder: (context, teamViewModel, matchViewModel, child) {
        final followedTeamIds = teamViewModel.followedTeamIds;

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
              return const SizedBox.shrink();
            }

            // Filter matches that are marked as favorite OR have a followed team
            // BUT exclude live matches that are ONLY in favorites because of followed teams
            // (allow explicitly favorited live matches)
            var favoriteMatches = snapshot.data!.where((match) {
              // Check if match is explicitly favorited
              final isFavorite = match.isFavorite;

              // Check if either team is followed
              final hasFollowedTeam = followedTeamIds.contains(match.teamAId) ||
                  followedTeamIds.contains(match.teamBId);

              final isLive = match.status == MatchStatus.live;

              // Show if:
              // 1. Explicitly favorited (regardless of status), OR
              // 2. Has followed team AND is not live (followed team matches shown when not live)
              return isFavorite || (hasFollowedTeam && !isLive);
            }).toList();

            // Apply category filter
            if (selectedFilter != 'All') {
              favoriteMatches = favoriteMatches.where((match) {
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

            if (favoriteMatches.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.waoYellow.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: AppColors.waoYellow,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'My Favourites',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.waoYellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${favoriteMatches.length}',
                          style: const TextStyle(
                            color: Color(0xFF011B3B),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
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
                  itemCount: favoriteMatches.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final match = favoriteMatches[index];
                    final isTeamAFollowed = followedTeamIds.contains(match.teamAId);
                    final isTeamBFollowed = followedTeamIds.contains(match.teamBId);

                    return MatchCard(
                      match: match,
                      isTeamAFollowed: isTeamAFollowed,
                      isTeamBFollowed: isTeamBFollowed,
                      onFavoriteTap: () {
                        // Toggle favorite status
                        matchViewModel.toggleMatchFavorite(
                          match.id,
                          match.isFavorite,
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}