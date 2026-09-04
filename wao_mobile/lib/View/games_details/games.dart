import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  DateTime _selectedDate = DateTime.now();
  String _selectedFilter = 'All';
  static const _filters = ['All', 'Friendly', 'Championship', 'Campus'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && mounted) {
        Provider.of<MatchViewModel>(context, listen: false).initialize();
        Provider.of<TeamViewModel>(context, listen: false).initialize(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: top),

          // ── Page title ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              'Matches',
              style: GoogleFonts.oswald(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.waoNavy,
                letterSpacing: 0.3,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Followed teams strip ────────────────────────────────────────
          const MatchesHeader(),

          const SizedBox(height: 16),

          // ── Date picker ─────────────────────────────────────────────────
          DateFilter(
            selectedDate: _selectedDate,
            onDateSelected: (d) => setState(() => _selectedDate = d),
          ),

          const SizedBox(height: 16),

          // ── Category chips ──────────────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final selected = _selectedFilter == f;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.waoRed
                          : isDark
                              ? Colors.white.withOpacity(0.06)
                              : AppColors.waoNavy.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.waoRed
                            : isDark
                                ? Colors.white.withOpacity(0.1)
                                : AppColors.waoNavy.withOpacity(0.12),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      f,
                      style: GoogleFonts.oswald(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : isDark
                                ? Colors.white60
                                : AppColors.waoNavy.withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ── Scrollable match sections ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FavoritesMatchesSection(
                    selectedDate: _selectedDate,
                    selectedFilter: _selectedFilter,
                  ),
                  const SizedBox(height: 8),
                  const LiveMatchesSection(),
                  const SizedBox(height: 8),
                  AllMatchesSection(
                    selectedDate: _selectedDate,
                    selectedFilter: _selectedFilter,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Favourites section ────────────────────────────────────────────────────────

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer2<TeamViewModel, MatchViewModel>(
      builder: (context, teamViewModel, matchViewModel, _) {
        final followedTeamIds = teamViewModel.followedTeamIds;

        return StreamBuilder<List<WaoMatch>>(
          stream: matchViewModel.getMatchesByDate(selectedDate),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();

            var matches = snapshot.data!.where((m) {
              final isFav = m.isFavorite;
              final hasFollowed = followedTeamIds.contains(m.teamAId) ||
                  followedTeamIds.contains(m.teamBId);
              final isLive = m.status == MatchStatus.live;
              return isFav || (hasFollowed && !isLive);
            }).toList();

            if (selectedFilter != 'All') {
              matches = matches.where((m) => _matchesFilter(m, selectedFilter)).toList();
            }

            if (matches.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'My Favourites',
                  count: matches.length,
                  isDark: isDark,
                  accentColor: AppColors.waoYellow,
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
                      isTeamAFollowed: followedTeamIds.contains(m.teamAId),
                      isTeamBFollowed: followedTeamIds.contains(m.teamBId),
                      onFavoriteTap: () =>
                          matchViewModel.toggleMatchFavorite(m.id, m.isFavorite),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }
}

bool _matchesFilter(WaoMatch m, String filter) {
  switch (filter) {
    case 'Friendly':      return m.type == MatchType.friendly;
    case 'Championship':  return m.type == MatchType.championship;
    case 'Campus':        return m.type == MatchType.campusInternal;
    default:              return true;
  }
}

// ── Shared section header ─────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.isDark,
    this.count,
    this.accentColor,
  });

  final String title;
  final bool isDark;
  final int? count;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final bar = accentColor ?? AppColors.waoRed;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 20,
            decoration: BoxDecoration(
              color: bar,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.oswald(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.waoNavy,
              letterSpacing: 0.3,
            ),
          ),
          if (count != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: bar.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.oswald(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: bar,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
