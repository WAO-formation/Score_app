import 'package:flutter/material.dart';

import '../../../shared/Welcome_box.dart';
import '../../../shared/custom_appbar.dart';
import '../../../shared/theme_data.dart';

class GameRules extends StatelessWidget {
  const GameRules({super.key});


  static const List<String> _sectionTitles = [
    'WAO SPORT BASIC RULES & PROFILE',
    'BASIC FOUL RULES',
    'LAWS OF TERRITORY',
    'INSPECTION'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Rules',
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 40.0, bottom: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header section
              const WelcomeToWAO(title: ' WAO Game Rules'),
              const SizedBox(height: 60.0),

              // Basic Rules Section
              _buildSectionHeader(_sectionTitles[0]),
              const SizedBox(height: 20.0),
              _buildBasicRulesSection(),

              // Foul Rules Section
              const SizedBox(height: 30.0),
              _buildSectionHeader(_sectionTitles[1]),
              const SizedBox(height: 20.0),
              _buildFoulRulesSection(),

              // Laws of Territory Section
              const SizedBox(height: 30.0),
              _buildSectionHeader(_sectionTitles[2]),
              const SizedBox(height: 20.0),
              _buildLawsOfTerritorySection(),

              // Inspection Section
              const SizedBox(height: 30.0),
              _buildSectionHeader(_sectionTitles[3]),
              const SizedBox(height: 20.0),
              _buildInspectionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 18,
        color: lightColorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget _buildBulletItem(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff2F3B4A),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xff2F3B4A),
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedBulletItem(String highlight, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff2F3B4A),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff2F3B4A),
                ),
                children: [
                  TextSpan(
                    text: highlight + " ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: content),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicRulesSection() {
    final List<String> basicRules = [
      'WAO is a 2-ball multiple-scoring contact sport played on a spherical pitch and thrives on technology',
      'The object of the sport is to score a higher percentage sum of the opposing team',
      'The four cardinal places to score points are Kingdom, Workout, Goalpost and Judges',
      'A Team is made up of 7 Players plus 5 subs; thus 14 Players at each time on the WaoSphere.',
      'We live on a spherical planet filled with continents; exactly as the WaoSphere, but this time the whole world-as-one WAO!',
      'Every part of WaoSphere is playable by all, any Player can score points anywhere with any ball.',
      'Handle and control ball by bouncing, dribbling, giving passes, displaying skills or movement in any direction.',
      'Blocking is part of defense and to "kiss-a-crown" can be likened to "dunk".',
      'A game starts with a maximum of 2 balls of different colours.',
      'Each team starts with 1 ball playing offence and defence at the same time.',
      'Upon start tip off, each Team makes a long throw from Kingdom to Hi-Court, and then play on. Teams do not own a ball; anyone can play and score with any ball.',
      'Each Team is expected to score points with the ball at hand and at the same time compete for possession of the opponent\'s ball to score points with it.',
      'If 1 Player possesses the 2 balls, control balls in alternating bounce.',
      'There is a maximum of 2-field Referees, each officiates interactions around the ball he wears its color.',
      'A panel of 6 Judges sit behind Hi-court areas in threesome apart to rule Hi-Court cases.',
      'A game is played in 4 quarters; 1st 17 min. 2nd 17 min. 3rd 13 min, and 4th 13 min. for total time of 60 minutes, or play extra time if need be to break a tie.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: basicRules.map((rule) => _buildBulletItem(rule)).toList(),
    );
  }

  Widget _buildFoulRulesSection() {
    final List<String> foulRules = [
      'Wao! Is a discipline, the better you play/fame the more you\'re expected to be disciplined in life! The overall greatness of a Player is measured by the ability to display actual man power skillset within the game jurisprudence.',
      'Team contact sport can be aggressive and unclear, it is playing within rules that makes it attractive and competitive to determine a clear winner.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: foulRules.map((rule) => _buildBulletItem(rule)).toList(),
    );
  }

  Widget _buildLawsOfTerritorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBulletItem('In Wao! the area of a playing field associated with a particular Player comes with special treats. They include:'),
        _buildHighlightedBulletItem('KING:', 'Minor aggressions expressed by the Player KING while protecting or defending His KINGDOM may not be foul.'),
        _buildHighlightedBulletItem('WORKER:', 'Any aggression towards the Player WORKER while displaying skills in His WORKOUT is foul.'),
        _buildHighlightedBulletItem('SACRIFICE:', 'There is a strict rule governing SACRIFICE. When a Team sets SACRIFICE, the least attempt to abort it or hurt them is Penalty.'),
        _buildHighlightedBulletItem('SACRIFICER:', 'Any aggression towards Player Sacrificer in the Sacrifice area is foul.'),
      ],
    );
  }

  Widget _buildInspectionSection() {
    final List<String> inspectionItems = [
      'Safety & Security',
      '7 Players on each Team (plus 5 Subs)',
      'WaoSphere quality / Pitch condition',
      'Minimum of 2 balls of 2 expressive colours',
      '2 field Refs, each dressed in a colour of ball to rule, plus sideline Refs',
      'Panel of Judges, not more than 3 sitting behind each of the 2 Hi-Courts',
      'Smart kit; Balls, Floor, Jerseys, Whistle, Sacrificer-Robots, Gloves/Rings',
      'Digital Narrators (Media content enablers) Storytellers / Storyline',
      'Facilities, convenience for human dwelling',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: inspectionItems.map((item) => _buildBulletItem(item)).toList(),
    );
  }
}