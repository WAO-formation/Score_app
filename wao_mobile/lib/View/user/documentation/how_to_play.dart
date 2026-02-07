import 'package:flutter/material.dart';

import '../../../shared/app_bar.dart';

class HowToPlayWAO extends StatelessWidget {
  const HowToPlayWAO({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      appBar: const CustomAppBar(
        title: 'How To Play WAO!',
        showBackButton: true,
        showNotification: true,
        hasNotificationDot: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Introduction
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFD30336).withOpacity(0.1),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD30336).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        "WAO is a multiple scoring hand-controlled sport played on a spherical pitch, and thrives on technology.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.6,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Let's Play banner
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF011B3B), Color(0xFFD30336)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Let's play WAO!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Basic Rules
                    _buildSection(
                      isDarkMode: isDarkMode,
                      icon: Icons.sports_handball,
                      title: "Basic Rules",
                      content: "Handle and control ball by bouncing, dribbling, passing, and displaying skills or movement in any direction.\n\n"
                          "Every part of the pitch is playable by all players, and any Player can score points anywhere.\n\n"
                          "The objective is to score points in four scoring areas, and end with a high percentage sum.",
                    ),

                    const SizedBox(height: 32),

                    // Scoring Areas Header
                    Text(
                      "THE SCORING AREAS",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Kingdom, Workout, Oval-Crown and Judges",
                      style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Scoring sections
                    _buildScoringCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.castle,
                      title: "KINGDOM",
                      percentage: "30%",
                      content: "Score by invading opponent's KINGDOM with the ball and bounce.\n\n"
                          "At least one foot must be in the Kingdom area. Each bounce per second is 1 point.",
                    ),

                    const SizedBox(height: 16),

                    _buildScoringCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.fitness_center,
                      title: "WORKOUT",
                      percentage: "30%",
                      content: "Score in your own Workout area by entering with ball.\n\n"
                          "Time you stay in with the ball is counted and converted to points. At least one foot must be in the area.",
                    ),

                    const SizedBox(height: 16),

                    _buildScoringCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.sports_basketball,
                      title: "OVAL-CROWN",
                      percentage: "30%",
                      content: "Each Team has 2 Oval Crowns to score and 2 to defend.\n\n"
                          "For fowls and penalty throws at game start, can be opened for other scoring too.",
                    ),

                    const SizedBox(height: 16),

                    _buildScoringCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.gavel,
                      title: "JUDGES",
                      percentage: "10%",
                      content: "Judges use predictable golden characters and humane behaviors to determine score.",
                    ),

                    const SizedBox(height: 24),

                    // Players
                    _buildSection(
                      isDarkMode: isDarkMode,
                      icon: Icons.people_alt,
                      title: "Players Identification",
                      content: "A Team has 7 Players plus 5 subs; 14 Players total on the WaoSphere.\n\n"
                          "Players are identified by characters for storytelling.",
                    ),

                    const SizedBox(height: 16),

                    // Characters Table
                    _buildCharactersTable(isDarkMode),

                    const SizedBox(height: 16),

                    // Foul Rules
                    _buildSection(
                      isDarkMode: isDarkMode,
                      icon: Icons.rule_folder,
                      title: "Basic Foul Rules",
                      content: "Wao! is discipline - the better you play, the more disciplined you're expected to be in life!\n\n"
                          "Greatness is measured by displaying skillset within game jurisprudence.\n\n"
                          "Playing within rules makes it attractive and competitive.",
                    ),

                    const SizedBox(height: 16),

                    // Laws of Territory
                    _buildSection(
                      isDarkMode: isDarkMode,
                      icon: Icons.map,
                      title: "Laws of Territory",
                      content: "Special rules for player positions:\n\n"
                          "KING: Minor aggressions defending Kingdom may not be foul.\n\n"
                          "WORKER: Any aggression towards Worker in Workout is foul.\n\n"
                          "SACRIFICE: Strict rules - attempting to abort or hurt is Penalty.\n\n"
                          "SACRIFICER: Any aggression in Sacrifice area is foul.",
                    ),

                    const SizedBox(height: 16),

                    // Inspection
                    _buildSection(
                      isDarkMode: isDarkMode,
                      icon: Icons.checklist,
                      title: "Inspection",
                      content: "• Safety & Security\n"
                          "• 7 Players per Team (plus 5 Subs)\n"
                          "• WaoSphere quality / Pitch condition\n"
                          "• Minimum 2 balls of 2 colors\n"
                          "• 2 field Refs, sideline Refs\n"
                          "• Panel of Judges (max 3 per Hi-Court)\n"
                          "• Smart kit: Balls, Floor, Jerseys, etc.\n"
                          "• Digital Narrators\n"
                          "• Storytellers / Storyline\n"
                          "• Facilities for human dwelling",
                    ),

                    const SizedBox(height: 16),

                    // Officiating
                    _buildSection(
                      isDarkMode: isDarkMode,
                      icon: Icons.sports,
                      title: "Officiating",
                      content: "1 field Referee assisted by 2 sideline referees and technology assistants.\n\n"
                          "Technology assists scoring, officiating and adds to the fun.",
                    ),

                    const SizedBox(height: 32),

                    // WAO Motto
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF011B3B), Color(0xFFD30336)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD30336).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        "WAO - World As One!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFD30336), size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoringCard({
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String percentage,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF011B3B), Color(0xFFD30336)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD30336),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  percentage,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharactersTable(bool isDarkMode) {
    final characters = [
      ['King', 'Kingdom'],
      ['Warrior', 'Dominion'],
      ['Worker', 'Workout'],
      ['Protaque', 'Hi Court (Left)'],
      ['Sacrificer', 'Sacrifice'],
      ['Antaque', 'Goal Setting (Right)'],
      ['Servitor', 'Discretionary'],
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sports_score, color: Color(0xFFD30336), size: 24),
              const SizedBox(width: 12),
              Text(
                'PLAYERS CHARACTERS & POSITIONS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Table Header
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF011B3B), Color(0xFFD30336)],
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'CHARACTER',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'POSITION',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Table Rows
          ...characters.map((row) => Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      row[0],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      row[1],
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )),

          const SizedBox(height: 12),
          Text(
            'Positions are interchangeable. Characters and descriptions are changeable to suit stories. Characters come with learning beyond sport.',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: isDarkMode ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}