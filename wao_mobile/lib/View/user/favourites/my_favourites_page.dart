import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_match.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/Model/user_provider.dart';
import 'package:wao_mobile/View/games_details/live_game_details.dart';
import 'package:wao_mobile/View/games_details/past_match_details.dart';
import 'package:wao_mobile/View/games_details/team_details.dart';
import 'package:wao_mobile/View/games_details/upcoming_game_details.dart';
import 'package:wao_mobile/ViewModel/teams_games/match_viewmodel.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class MyFavouritesPage extends StatefulWidget {
  const MyFavouritesPage({super.key});

  @override
  State<MyFavouritesPage> createState() => _MyFavouritesPageState();
}

class _MyFavouritesPageState extends State<MyFavouritesPage> {
  bool _showTeams = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<UserProvider>().userProfile;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Inline header ─────────────────────────────────────────────
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
                    'My Favourites',
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

            const SizedBox(height: 20),

            // ── Teams / Matches toggle ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _ToggleChip(
                      label: 'Teams',
                      count: user?.favoriteTeamIds.length ?? 0,
                      selected: _showTeams,
                      isDark: isDark,
                      onTap: () => setState(() => _showTeams = true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ToggleChip(
                      label: 'Matches',
                      count: user?.favoriteMatchIds.length ?? 0,
                      selected: !_showTeams,
                      isDark: isDark,
                      onTap: () => setState(() => _showTeams = false),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: user == null
                  ? const Center(child: CircularProgressIndicator())
                  : _showTeams
                      ? _FavouriteTeamsList(favouriteIds: user.favoriteTeamIds, isDark: isDark)
                      : _FavouriteMatchesList(favouriteIds: user.favoriteMatchIds, isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Teams / Matches toggle chip ─────────────────────────────────────────────
class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.waoRed
              : isDark
                  ? Colors.white.withOpacity(0.06)
                  : AppColors.waoNavy.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.oswald(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : isDark
                        ? Colors.white60
                        : AppColors.waoNavy.withOpacity(0.7),
                letterSpacing: 0.3,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.waoRed.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.oswald(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.waoRed,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Favourite teams list ─────────────────────────────────────────────────────
class _FavouriteTeamsList extends StatelessWidget {
  const _FavouriteTeamsList({required this.favouriteIds, required this.isDark});
  final List<String> favouriteIds;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (favouriteIds.isEmpty) {
      return _EmptyState(
        icon: Icons.shield_outlined,
        label: 'No favourite teams yet',
        hint: 'Star a team from its page to see it here',
        isDark: isDark,
      );
    }

    return StreamBuilder<List<WaoTeam>>(
      stream: context.read<TeamViewModel>().getAllTeams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final teams = (snapshot.data ?? [])
            .where((t) => favouriteIds.contains(t.id))
            .toList();

        if (teams.isEmpty) {
          return _EmptyState(
            icon: Icons.shield_outlined,
            label: 'No favourite teams yet',
            hint: 'Star a team from its page to see it here',
            isDark: isDark,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          itemCount: teams.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final team = teams[index];
            return _FavouriteTeamTile(team: team, isDark: isDark);
          },
        );
      },
    );
  }
}

class _FavouriteTeamTile extends StatelessWidget {
  const _FavouriteTeamTile({required this.team, required this.isDark});
  final WaoTeam team;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final hasLogo = team.logoUrl.isNotEmpty && team.logoUrl.startsWith('http');

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TeamDetails(team: team)),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _tileDecor(isDark),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.waoNavy,
              ),
              child: ClipOval(
                child: hasLogo
                    ? Image.network(
                        team.logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.shield_outlined,
                          color: Colors.white54,
                          size: 22,
                        ),
                      )
                    : const Icon(Icons.shield_outlined, color: Colors.white54, size: 22),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.oswald(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    team.category.name.toUpperCase(),
                    style: GoogleFonts.oswald(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            _UnfavouriteButton(
              onTap: () => context.read<UserProvider>().toggleFavoriteTeam(team.id),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Favourite matches list ───────────────────────────────────────────────────
class _FavouriteMatchesList extends StatelessWidget {
  const _FavouriteMatchesList({required this.favouriteIds, required this.isDark});
  final List<String> favouriteIds;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (favouriteIds.isEmpty) {
      return _EmptyState(
        icon: Icons.sports_outlined,
        label: 'No favourite matches yet',
        hint: 'Star a match from its page to see it here',
        isDark: isDark,
      );
    }

    return StreamBuilder<List<WaoMatch>>(
      stream: context.read<MatchViewModel>().getAllMatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final matches = (snapshot.data ?? [])
            .where((m) => favouriteIds.contains(m.id))
            .toList()
          ..sort((a, b) => b.startTime.compareTo(a.startTime));

        if (matches.isEmpty) {
          return _EmptyState(
            icon: Icons.sports_outlined,
            label: 'No favourite matches yet',
            hint: 'Star a match from its page to see it here',
            isDark: isDark,
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          itemCount: matches.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final match = matches[index];
            return _FavouriteMatchTile(match: match, isDark: isDark);
          },
        );
      },
    );
  }
}

class _FavouriteMatchTile extends StatelessWidget {
  const _FavouriteMatchTile({required this.match, required this.isDark});
  final WaoMatch match;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isLive = match.status == MatchStatus.live;
    final isFinished = match.status == MatchStatus.finished;
    final showScore = isLive || isFinished;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => isLive
              ? LiveGamesDetails(match: match)
              : isFinished
                  ? PastMatchDetails(match: match)
                  : UpcomingGameDetails(match: match),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _tileDecor(isDark, highlighted: isLive),
        child: Row(
          children: [
            SizedBox(
              width: 46,
              child: _MatchStatusLabel(match: match, isDark: isDark),
            ),
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : AppColors.waoNavy.withOpacity(0.08),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TeamLine(
                    name: match.teamAName,
                    score: match.scoreA,
                    showScore: showScore,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  _TeamLine(
                    name: match.teamBName,
                    score: match.scoreB,
                    showScore: showScore,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            _UnfavouriteButton(
              onTap: () => context.read<UserProvider>().toggleFavoriteMatch(match.id),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchStatusLabel extends StatelessWidget {
  const _MatchStatusLabel({required this.match, required this.isDark});
  final WaoMatch match;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (match.status == MatchStatus.live) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.waoRed,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          'LIVE',
          textAlign: TextAlign.center,
          style: GoogleFonts.oswald(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    final label = match.status == MatchStatus.finished
        ? 'FT'
        : DateFormat('MMM d').format(match.startTime);

    return Text(
      label,
      textAlign: TextAlign.center,
      style: GoogleFonts.oswald(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white70 : AppColors.waoNavy.withOpacity(0.7),
      ),
    );
  }
}

class _TeamLine extends StatelessWidget {
  const _TeamLine({
    required this.name,
    required this.score,
    required this.showScore,
    required this.isDark,
  });
  final String name;
  final int score;
  final bool showScore;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
        if (showScore)
          Text(
            '$score',
            style: GoogleFonts.oswald(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.waoNavy,
            ),
          ),
      ],
    );
  }
}

// ── Shared bits ───────────────────────────────────────────────────────────────

class _UnfavouriteButton extends StatelessWidget {
  const _UnfavouriteButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Padding(
        padding: EdgeInsets.only(left: 10),
        child: Icon(Icons.star_rounded, size: 24, color: AppColors.waoYellow),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.label,
    required this.hint,
    required this.isDark,
  });
  final IconData icon;
  final String label;
  final String hint;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.2)),
            const SizedBox(height: 14),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.oswald(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white60 : AppColors.waoNavy.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _tileDecor(bool isDark, {bool highlighted = false}) => BoxDecoration(
      color: isDark ? AppColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: highlighted
            ? AppColors.waoRed.withOpacity(0.4)
            : isDark
                ? Colors.white.withOpacity(0.08)
                : AppColors.waoNavy.withOpacity(0.08),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
