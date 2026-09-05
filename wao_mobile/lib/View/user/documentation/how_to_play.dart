import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class HowToPlayWAO extends StatelessWidget {
  const HowToPlayWAO({super.key, this.showBackButton = true});
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final top = MediaQuery.of(context).padding.top;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Inline header ─────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 20, 20, 0),
            child: Row(
              children: [
                if (showBackButton) ...[
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
                ],
                Text(
                  'How To Play WAO',
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

          // ── Scrollable content ────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              // Clears the floating pill nav bar (~84px) when shown as a
              // tab, not just the OS home-indicator inset SafeArea covers.
              padding: EdgeInsets.only(bottom: bottomInset + 84),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intro card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _IntroCard(isDark: isDark),
                  ),

                  const SizedBox(height: 28),

                  // Basic Rules
                  _SectionHeader(title: 'Basic Rules', isDark: isDark),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _InfoCard(
                      isDark: isDark,
                      icon: Icons.sports_handball,
                      text:
                          'Handle and control the ball by bouncing, dribbling, passing, and displaying skills in any direction.\n\n'
                          'Every part of the pitch is playable by all players. Any player can score points anywhere.\n\n'
                          'The objective is to score in four scoring areas and end with the highest percentage sum.',
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Scoring Areas
                  _SectionHeader(
                    title: 'The Scoring Areas',
                    isDark: isDark,
                    subtitle: 'Kingdom · Workout · Oval-Crown · Judges',
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _ScoringTile(isDark: isDark, icon: Icons.castle,          title: 'KINGDOM',    pct: '30%', text: 'Invade the opponent\'s Kingdom with the ball and bounce. At least one foot must be inside. Each bounce per second = 1 point.'),
                        const SizedBox(height: 10),
                        _ScoringTile(isDark: isDark, icon: Icons.fitness_center,   title: 'WORKOUT',    pct: '30%', text: 'Score in your own Workout area. Time spent inside with the ball is converted to points. At least one foot must be in the area.'),
                        const SizedBox(height: 10),
                        _ScoringTile(isDark: isDark, icon: Icons.sports_basketball, title: 'OVAL-CROWN', pct: '30%', text: 'Each team has 2 Oval Crowns to score and 2 to defend. Also used for fouls, penalty throws, and game-start scoring.'),
                        const SizedBox(height: 10),
                        _ScoringTile(isDark: isDark, icon: Icons.gavel,            title: 'JUDGES',     pct: '10%', text: 'Judges use predictable golden characters and humane behaviours to determine the score.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Players
                  _SectionHeader(title: 'Players & Characters', isDark: isDark),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _InfoCard(
                          isDark: isDark,
                          icon: Icons.people_alt,
                          text:
                              'A team has 7 players plus 5 substitutes — 14 players total on the WaoSphere.\n\n'
                              'Players are identified by characters for storytelling. Positions are interchangeable and characters can be adapted to suit any story.',
                        ),
                        const SizedBox(height: 10),
                        _CharactersTable(isDark: isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Foul Rules
                  _SectionHeader(title: 'Foul Rules', isDark: isDark),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _InfoCard(
                          isDark: isDark,
                          icon: Icons.rule_folder,
                          text:
                              'WAO! is discipline — the better you play, the more disciplined you are expected to be.\n\n'
                              'Greatness is measured by displaying your skillset within game jurisprudence. Playing within the rules makes it attractive and competitive.',
                        ),
                        const SizedBox(height: 10),
                        _InfoCard(
                          isDark: isDark,
                          icon: Icons.map,
                          label: 'Laws of Territory',
                          text:
                              'KING — Minor aggressions defending the Kingdom may not be a foul.\n\n'
                              'WORKER — Any aggression towards the Worker in Workout is a foul.\n\n'
                              'SACRIFICE — Strict rules; attempting to abort or hurt is a Penalty.\n\n'
                              'SACRIFICER — Any aggression in the Sacrifice area is a foul.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Inspection & Officiating
                  _SectionHeader(title: 'Inspection & Officiating', isDark: isDark),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _ChecklistCard(isDark: isDark),
                        const SizedBox(height: 10),
                        _InfoCard(
                          isDark: isDark,
                          icon: Icons.sports,
                          label: 'Officiating',
                          text:
                              '1 field Referee assisted by 2 sideline referees and technology assistants.\n\n'
                              'Technology assists scoring, officiating, and adds to the fun.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Motto
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _MottoBar(),
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

// ── Intro card ────────────────────────────────────────────────────────────────

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.waoNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '"WAO is a multiple scoring hand-controlled sport played on a spherical pitch, and thrives on technology."',
            style: GoogleFonts.oswald(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.65,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Container(
            width: 36,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.waoRed,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Let's play WAO!",
            style: GoogleFonts.oswald(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.waoRed,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header — exact match to games.dart _SectionHeader ─────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.isDark,
    this.subtitle,
  });
  final String title;
  final bool isDark;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                title,
                style: GoogleFonts.oswald(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 13),
              child: Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Generic info card ─────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.isDark,
    required this.icon,
    required this.text,
    this.label,
  });
  final bool isDark;
  final IconData icon;
  final String text;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.waoRed, size: 20),
              if (label != null) ...[
                const SizedBox(width: 10),
                Text(
                  label!,
                  style: GoogleFonts.oswald(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: isDark ? Colors.white : AppColors.waoNavy,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.65,
              color: isDark ? Colors.white70 : AppColors.textSecondary(isDark),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Scoring tile ──────────────────────────────────────────────────────────────

class _ScoringTile extends StatelessWidget {
  const _ScoringTile({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.pct,
    required this.text,
  });
  final bool isDark;
  final IconData icon;
  final String title, pct, text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(isDark),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.waoNavy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.waoRed,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  pct,
                  style: GoogleFonts.oswald(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.oswald(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: isDark ? Colors.white : AppColors.waoNavy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.55,
                    color: isDark ? Colors.white70 : AppColors.textSecondary(isDark),
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

// ── Characters table ──────────────────────────────────────────────────────────

class _CharactersTable extends StatelessWidget {
  const _CharactersTable({required this.isDark});
  final bool isDark;

  static const _rows = [
    ['King',       'Kingdom'],
    ['Warrior',    'Dominion'],
    ['Worker',     'Workout'],
    ['Protaque',   'Hi Court (Left)'],
    ['Sacrificer', 'Sacrifice'],
    ['Antaque',    'Goal Setting (Right)'],
    ['Servitor',   'Discretionary'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecor(isDark),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          Container(
            color: AppColors.waoNavy,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                _Cell('CHARACTER', header: true),
                _Cell('POSITION', header: true),
              ],
            ),
          ),
          // Rows
          ..._rows.asMap().entries.map((e) {
            final even = e.key.isEven;
            return Container(
              color: even
                  ? (isDark
                      ? Colors.white.withOpacity(0.03)
                      : AppColors.waoNavy.withOpacity(0.03))
                  : Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  _Cell(e.value[0], isDark: isDark, bold: true),
                  _Cell(e.value[1], isDark: isDark),
                ],
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Text(
              'Positions are interchangeable. Characters come with learning beyond sport.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.text, {this.header = false, this.isDark, this.bold = false});
  final String text;
  final bool header;
  final bool? isDark;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: header
            ? GoogleFonts.oswald(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: Colors.white,
              )
            : bold
                ? GoogleFonts.oswald(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark! ? Colors.white : AppColors.waoNavy,
                  )
                : TextStyle(
                    fontSize: 13,
                    color: isDark! ? Colors.white60 : Colors.black54,
                  ),
      ),
    );
  }
}

// ── Checklist card ────────────────────────────────────────────────────────────

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.isDark});
  final bool isDark;

  static const _items = [
    'Safety & Security',
    '7 Players per Team (plus 5 Subs)',
    'WaoSphere quality / Pitch condition',
    'Minimum 2 balls of 2 colours',
    '2 field Refs, sideline Refs',
    'Panel of Judges (max 3 per Hi-Court)',
    'Smart kit: Balls, Floor, Jerseys, etc.',
    'Digital Narrators',
    'Storytellers / Storyline',
    'Facilities for human dwelling',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecor(isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.checklist_rounded, color: AppColors.waoRed, size: 20),
              const SizedBox(width: 10),
              Text(
                'Inspection Checklist',
                style: GoogleFonts.oswald(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.waoRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: isDark ? Colors.white70 : AppColors.textSecondary(isDark),
                      ),
                    ),
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

// ── Motto bar ─────────────────────────────────────────────────────────────────

class _MottoBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.waoNavy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'WAO',
            style: GoogleFonts.oswald(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 6,
              color: AppColors.waoRed,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'WORLD AS ONE',
            style: GoogleFonts.oswald(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 4,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared card decoration ────────────────────────────────────────────────────

BoxDecoration _cardDecor(bool isDark) => BoxDecoration(
      color: isDark ? AppColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isDark
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
