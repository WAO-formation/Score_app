import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/View/games_details/widgets/game_detail_shared.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import '../../Model/teams_games/wao_match.dart';

class UpcomingGameDetails extends StatefulWidget {
  final WaoMatch match;
  const UpcomingGameDetails({super.key, required this.match});

  @override
  State<UpcomingGameDetails> createState() => _UpcomingGameDetailsState();
}

class _UpcomingGameDetailsState extends State<UpcomingGameDetails>
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
      // top:false leaves the hero card's gradient full-bleed against the
      // status bar (it hand-rolls its own top inset for the back button);
      // bottom protects the roster panel from the home indicator.
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _UpcomingHeroCard(match: widget.match, topPadding: top),

            const SizedBox(height: 24),

            DetailTabBar(
              controller: _tab,
              tabs: [widget.match.teamAName, widget.match.teamBName],
              isDark: isDark,
            ),

            const SizedBox(height: 20),

            TeamRosterPanel(
              teamId: _tab.index == 0 ? widget.match.teamAId : widget.match.teamBId,
              isDark: isDark,
            ),

            const SizedBox(height: 32),
          ],
        ),
        ),
      ),
    );
  }
}

// ── Upcoming hero card ────────────────────────────────────────────────────────

class _UpcomingHeroCard extends StatelessWidget {
  const _UpcomingHeroCard({required this.match, required this.topPadding});
  final WaoMatch match;
  final double topPadding;

  String _fmtDate(DateTime dt) => DateFormat('MMM d, yyyy').format(dt);
  String _fmtTime(DateTime dt) => DateFormat('h:mm a').format(dt);

  @override
  Widget build(BuildContext context) {
    final date = match.scheduledDate ?? match.startTime;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.waoRed, Color(0xFFB01030)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40, bottom: -40,
            child: Opacity(
              opacity: 0.08,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                child: Image.asset('assets/images/wao-ball.png', width: 200,
                  errorBuilder: (_, __, ___) => const SizedBox()),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DetailBackButton(),
                    MatchTypeBadge(type: match.type),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PulsingDot(color: Colors.white),
                          const SizedBox(width: 6),
                          Text('UPCOMING', style: GoogleFonts.oswald(
                            fontSize: 10, fontWeight: FontWeight.w700,
                            color: Colors.white, letterSpacing: 0.8,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_rounded, color: Colors.white54, size: 12),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(match.venue, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.oswald(fontSize: 11, color: Colors.white70)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    HeroTeamColumn(name: match.teamAName),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
                      ),
                      child: Text('VS', style: GoogleFonts.oswald(
                        fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                    HeroTeamColumn(name: match.teamBName),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 13),
                      const SizedBox(width: 8),
                      Text(_fmtDate(date), style: GoogleFonts.oswald(
                        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 1, height: 14,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      const Icon(Icons.access_time_rounded, color: Colors.white70, size: 13),
                      const SizedBox(width: 6),
                      Text(_fmtTime(match.startTime), style: GoogleFonts.oswald(
                        fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
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
