import 'package:flutter/material.dart';
import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';

class HowToPlayWAO extends StatefulWidget {
  const HowToPlayWAO({super.key});

  @override
  State<HowToPlayWAO> createState() => _HowToPlayWAOState();
}

class _HowToPlayWAOState extends State<HowToPlayWAO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'How To Play',
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              const WelcomeToWAO(title: 'How To Play WAO'),

              const SizedBox(height: 30.0),

              // Introduction
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [lightColorScheme.primaryContainer, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  "WAO is a multiple scoring hand-controlled sport played on a spherical pitch, and thrives on technology.",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                    color: Color(0xFF2F3B4A),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20.0),


              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: lightColorScheme.secondary,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child:  Text(
                    "Let's play WAO!",
                    style: AppStyles.secondaryTitle.copyWith( color: Colors.white)
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Basic playing rules
              _buildSectionWithIcon(
                Icons.sports_handball,
                "Basic Rules",
                "Handle and control ball by bouncing, dribbling, passing, and displaying skills or movement in any direction.\n\nEvery part of the pitch is playable by all players, and any Player can score points anywhere.\n\nThe objective of the sport is to score points in four scoring areas, and end with a high percentage sum.",
              ),

              const SizedBox(height: 20.0),

              // Scoring areas introduction
              Center(
                child: Text(
                  "THE SCORING AREAS",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 5.0),

              const Center(
                child: Text(
                  "The scoring areas are: Kingdom, Workout, Oval-Crown and Judges.",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF2F3B4A),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24.0),

              // Kingdom scoring
              _buildScoringSection(
                "KINGDOM",
                Icons.castle,
                "You score points by invading your opponent's KINGDOM area with the ball and bounce.\n\nAt least one foot must be in the Kingdom area before it is valid. Each bounce per second is 1 point.\n\nKingdom determines 30% of total score.",
                "30%",
              ),

              const SizedBox(height: 16.0),

              // Workout scoring
              _buildScoringSection(
                "WORKOUT",
                Icons.fitness_center,
                "You score points in your own Workout area by entering with ball.\n\nThe time you stay in with the ball is counted and converted to point.\n\nAt least one foot must be in the Workout area before it is valid.\n\nWorkout determines 30% of total score.",
                "30%",
              ),

              const SizedBox(height: 16.0),

              // Oval-Crown scoring
              _buildScoringSection(
                "OVAL-CROWN",
                Icons.sports_basketball,
                "Each Team has 2 Oval Crowns to score and 2 others to defend.\n\nOval-Crowns are for fowls and penalty throws at the beginning of a game, and can be opened for other scoring too.\n\nOval-Crown determines 30% of total score.",
                "30%",
              ),

              const SizedBox(height: 16.0),

              // Judges scoring
              _buildScoringSection(
                "JUDGES",
                Icons.gavel,
                "Judges use predictable golden characters and humane behaviors to determines 10% of total score.",
                "10%",
              ),

              const SizedBox(height: 24.0),

              // Player identification
              _buildSectionWithIcon(
                Icons.people_alt,
                "Players Identification",
                "A Team is made up of 7 Players plus 5 subs; thus 14 Players at each time on the WaoSphere.\n\nThe players are identified by characters for storytelling.",
              ),

              const SizedBox(height: 16.0),

              // NEW SECTION: Player Characters and Positions
              _buildExpandableSection(
                "PLAYERS CHARACTERS AND POSITIONS",
                Icons.sports_score,
                [
                  _buildCharacterRow("King", "Kingdom"),
                  _buildCharacterRow("Warrior", "Dominion"),
                  _buildCharacterRow("Worker", "Workout"),
                  _buildCharacterRow("Protaque", "Hi Court (Left)"),
                  _buildCharacterRow("Sacrificer", "Sacrifice"),
                  _buildCharacterRow("Antaque", "Goal Setting (Right)"),
                  _buildCharacterRow("Servitor", "Discretionary"),
                ],
                "Positions are interchangeable. Characters and Pitch descriptions are changeable to suit a particular story we want to tell. Characters come with mass learning beyond sport.",
              ),

              const SizedBox(height: 16.0),

              // NEW SECTION: Basic Foul Rules
              _buildSectionWithIcon(
                Icons.rule_folder,
                "Basic Foul Rules",
                "Code: Wao! Is a discipline, the better you play/fame the more you're expected to be disciplined in life!\n\nThe overall greatness of a Player is measured by the ability to display actual man power skillset within the game jurisprudence.\n\nTeam contact sport can be aggressive and unclear, it is playing within rules that makes it attractive and competitive to determine a clear winner.",
              ),

              const SizedBox(height: 16.0),

              // NEW SECTION: Laws of Territory
              _buildSectionWithIcon(
                Icons.map,
                "Laws of Territory",
                "In Wao! the area of a playing field associated with a particular Player comes with special treats. They include:\n\n"
                    "KING: Minor aggressions expressed by the Player KING while protecting or defending His KINGDOM may not be foul.\n\n"
                    "WORKER: Any aggression towards the Player WORKER while displaying skills in His WORKOUT is foul.\n\n"
                    "SACRIFICE: There is a strict rule governing SACRIFICE. When a Team sets SACRIFICE, the least attempt to abort it or hurt them is Penalty.\n\n"
                    "SACRIFICER: Any aggression towards Player Sacrificer in the Sacrifice area is foul.",
              ),

              const SizedBox(height: 16.0),

              // NEW SECTION: Inspection
              _buildSectionWithIcon(
                Icons.checklist,
                "Inspection",
                "• Safety & Security\n"
                    "• 7 Players on each Team (plus 5 Subs)\n"
                    "• WaoSphere quality / Pitch condition\n"
                    "• Minimum of 2 balls of 2 expressive colours\n"
                    "• 2 field Refs, each dressed in a colour of ball to rule, plus sideline Refs\n"
                    "• Panel of Judges, not more than 3 sitting behind each of the 2 Hi-Courts\n"
                    "• Smart kit: Balls, Floor, Jerseys, Whistle, Sacrificer-Robots, Gloves/Rings\n"
                    "• Digital Narrators (Media content enablers)\n"
                    "• Storytellers / Storyline\n"
                    "• Facilities, convenience for human dwelling",
              ),

              const SizedBox(height: 16.0),

              // Officiating
              _buildSectionWithIcon(
                Icons.sports,
                "Officiating",
                "There shall be 1 field Referee assisted by 2 sideline referees and technology assistant referees. Technology assist scoring, officiating and adds to the fun.",
              ),

              const SizedBox(height: 30.0),

              // WAO motto
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: lightColorScheme.secondary,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    "WAO - World As One!",
                    style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.onPrimary),
                  ),
                ),
              ),

              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionWithIcon(IconData icon, String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: lightColorScheme.secondary,
                size: 24.0,
              ),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: AppStyles.secondaryTitle
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            content,
            style: AppStyles.informationText
          ),
        ],
      ),
    );
  }

  Widget _buildScoringSection(String title, IconData icon, String content, String percentage) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80.0,
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: lightColorScheme.primary,
                  size: 24.0,
                ),

                const SizedBox(height: 8.0),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: lightColorScheme.secondary,
                    borderRadius: BorderRadius.circular(5.0),
                  ),

                  child: Text(
                    percentage,
                    style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.onPrimary)
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1.0,
            height: 120.0,
            color: Colors.grey.shade300,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
          ),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14.0,
                    height: 1.5,
                    color: Color(0xFF2F3B4A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildExpandableSection(String title, IconData icon, List<Widget> rows, String footer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: lightColorScheme.secondary,
                size: 24.0,
              ),
              const SizedBox(width: 10.0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: lightColorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Headers
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: lightColorScheme.secondary,
                  child:  Text(
                    "CHARACTER",
                    style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: lightColorScheme.secondary,
                  child:  Text(
                    "POSITION",
                    style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.onPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),

          // Character rows
          ...rows,

          const SizedBox(height: 16.0),

          // Footer text
          Text(
            footer,
            style: const TextStyle(
              fontSize: 14.0,
              fontStyle: FontStyle.italic,
              color: Color(0xFF2F3B4A),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCharacterRow(String character, String position) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1.0,
          ),
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                character,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                position,
                style: AppStyles.informationText,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}