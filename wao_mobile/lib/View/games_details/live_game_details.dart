import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wao_mobile/View/games_details/widgets/game_detail_shared.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import '../../Model/teams_games/wao_match.dart';

class LiveGamesDetails extends StatefulWidget {
  final WaoMatch match;
  const LiveGamesDetails({super.key, required this.match});

  @override
  State<LiveGamesDetails> createState() => _LiveGamesDetailsState();
}

class _LiveGamesDetailsState extends State<LiveGamesDetails>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 2, vsync: this)
    ..addListener(() => setState(() {}));
  int _teamIndex = 0;

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero card ─────────────────────────────────────────────────
            _LiveHeroCard(match: widget.match, topPadding: top),

            const SizedBox(height: 24),

            // ── Tab bar ───────────────────────────────────────────────────
            DetailTabBar(
              controller: _tab,
              tabs: const ['Statistics', 'Players'],
              isDark: isDark,
            ),

            const SizedBox(height: 20),

            // ── Tab content ───────────────────────────────────────────────
            if (_tab.index == 0)
              _StatsTab(match: widget.match, isDark: isDark)
            else
              _PlayersTab(
                match: widget.match,
                isDark: isDark,
                teamIndex: _teamIndex,
                onTeamSelect: (i) => setState(() => _teamIndex = i),
              ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Live hero card ────────────────────────────────────────────────────────────

class _LiveHeroCard extends StatelessWidget {
  const _LiveHeroCard({required this.match, required this.topPadding});
  final WaoMatch match;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF011B3B), Color(0xFF02264D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Watermark
          Positioned(
            right: -40, bottom: -40,
            child: Opacity(
              opacity: 0.06,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(AppColors.waoYellow, BlendMode.srcIn),
                child: Image.asset('assets/images/wao-ball.png', width: 200,
                  errorBuilder: (_, __, ___) => const SizedBox()),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
            child: Column(
              children: [
                // Top row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DetailBackButton(),
                    MatchTypeBadge(type: match.type),
                    // Live badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.waoRed.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.waoRed, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PulsingDot(),
                          const SizedBox(width: 6),
                          Text('LIVE', style: GoogleFonts.oswald(
                            fontSize: 10, fontWeight: FontWeight.w700,
                            color: AppColors.waoRed, letterSpacing: 0.8,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Venue
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_rounded, color: Colors.white38, size: 12),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(match.venue, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.oswald(fontSize: 11, color: Colors.white54)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Teams + score
                Row(
                  children: [
                    HeroTeamColumn(name: match.teamAName),
                    // Score
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${match.scoreA}', style: GoogleFonts.oswald(
                            fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(':', style: GoogleFonts.oswald(
                              fontSize: 28, fontWeight: FontWeight.w300, color: Colors.white54)),
                          ),
                          Text('${match.scoreB}', style: GoogleFonts.oswald(
                            fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white)),
                        ],
                      ),
                    ),
                    HeroTeamColumn(name: match.teamBName),
                  ],
                ),

                const SizedBox(height: 20),

                // Timer strip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('23:34', style: GoogleFonts.oswald(
                        fontSize: 22, fontWeight: FontWeight.w700,
                        color: Colors.white, letterSpacing: 1,
                      )),
                      const SizedBox(width: 12),
                      Container(
                        width: 1, height: 18,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      const SizedBox(width: 12),
                      Text('2nd Quarter', style: GoogleFonts.oswald(
                        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats tab ─────────────────────────────────────────────────────────────────

class _StatsTab extends StatelessWidget {
  const _StatsTab({required this.match, required this.isDark});
  final WaoMatch match;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final kingdom = match.getKingdomPercentages();
    final workout = match.getWorkoutPercentages();
    final goals   = match.getGoalSettingPercentages();
    final judges  = match.getJudgesPercentages();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.07) : AppColors.waoNavy.withOpacity(0.08),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            StatBarRow(label: 'Kingdom (30%)',     teamAVal: kingdom['teamA']!.round(), teamBVal: kingdom['teamB']!.round(), teamAName: match.teamAName, teamBName: match.teamBName, isDark: isDark),
            const SizedBox(height: 20),
            StatBarRow(label: 'Workout (30%)',     teamAVal: workout['teamA']!.round(), teamBVal: workout['teamB']!.round(), teamAName: match.teamAName, teamBName: match.teamBName, isDark: isDark),
            const SizedBox(height: 20),
            StatBarRow(label: 'Goal Setting (30%)', teamAVal: goals['teamA']!.round(),  teamBVal: goals['teamB']!.round(),  teamAName: match.teamAName, teamBName: match.teamBName, isDark: isDark),
            const SizedBox(height: 20),
            StatBarRow(label: 'Judges (10%)',      teamAVal: judges['teamA']!.round(), teamBVal: judges['teamB']!.round(), teamAName: match.teamAName, teamBName: match.teamBName, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ── Players tab ───────────────────────────────────────────────────────────────

class _PlayersTab extends StatelessWidget {
  const _PlayersTab({
    required this.match,
    required this.isDark,
    required this.teamIndex,
    required this.onTeamSelect,
  });
  final WaoMatch match;
  final bool isDark;
  final int teamIndex;
  final ValueChanged<int> onTeamSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeamSelectorChips(
          teamAName: match.teamAName,
          teamBName: match.teamBName,
          selectedIndex: teamIndex,
          onSelect: onTeamSelect,
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        TeamRosterPanel(
          teamId: teamIndex == 0 ? match.teamAId : match.teamBId,
          isDark: isDark,
        ),
      ],
    );
  }
}
