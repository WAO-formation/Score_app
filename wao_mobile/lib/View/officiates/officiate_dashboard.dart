import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/custom_buttons.dart';

class OfficiateHome extends StatefulWidget {
  const OfficiateHome({super.key});

  @override
  State<OfficiateHome> createState() => _OfficiateHomeState();
}

class _OfficiateHomeState extends State<OfficiateHome> {
  final List<Map<String, dynamic>> guidelineData = const [
    {
      'title': "Referee's Call",
      'content': [
        "WAO fictions war, but death is ruled out. Opposing teams compete in an open field to outwit each other and prove supremacy by scoring. The One to police by rules and turn everything into showbiz is the Referee -without a competent Referee there will be chaos and no order to determine a winner."
      ]
    },
    {
      'title': "Referee's Purpose",
      'content': [
        "The purpose of WAO Referee is to officiate games fairly that even the losing team can say in all sincerity \"thank you Referee\"."
      ]
    },
    {
      'title': "Field Referees",
      'content': [
        "Maximum of 2 field referees, each responsible for one ball.",
        "Referees wear the color of their assigned ball for distinction.",
        "Oversee and rule on all interactions around their ball, ensuring rules are followed across the WaoSphere."
      ]
    },
    {
      'title': "1. Match Officials",
      'content': [
        "Field Referees:",
        "• Maximum of 2 field referees, each responsible for one ball.",
        "• Referees wear the color of their assigned ball for distinction.",
        "• Oversee and rule on all interactions around their ball, ensuring rules are followed across the WaoSphere.",
        "Hi-Court Judges:",
        "• 6 Judges total – 3 per Hi-Court.",
        "• Officiate Hi-Court cases, award Judges' points (10%), and evaluate skill displays.",
        "• Judges take control when the ball enters the Hi-Court, replacing field referees' role."
      ]
    },
    {
      'title': "2. Game Duration",
      'content': [
        "The game is played in 4 quarters totaling 60 minutes:",
        "• 1st Quarter – 17 mins",
        "• 2nd Quarter – 17 mins",
        "• 3rd Quarter – 13 mins",
        "• 4th Quarter – 13 mins",
        "Extra Time: Played only to break a tie."
      ]
    },
    {
      'title': "3. Scoring Supervision ",
      'content': [
        "The WaoScor App manages real-time score calculation based on:",
        "• Kingdom – 30%",
        "• Workout – 30%",
        "• Goalpost – 30%",
        "• Judges – 10%",
        "Ensures fair and accurate scoring. Tracks fouls, cards, and assists in predicting Judges' scores with 80-100% accuracy."
      ]
    },
  ];

  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentShowTitle = _scrollController.offset > 100;
    if (currentShowTitle != _showTitle) {
      setState(() {
        _showTitle = currentShowTitle;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: _showTitle ? 'WAO OFFICIATING GUIDE' : '',
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Logo or Header banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: lightColorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'WAO OFFICIATING GUIDE',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: guidelineData.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guidelineData[index]['title'].toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...List.generate(
                            guidelineData[index]['content'].length,
                                (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                guidelineData[index]['content'][i],
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CartButtons(label: 'Download Guide', onTap: () {  }, color: lightColorScheme.secondary,),

                  const SizedBox(width: 20),

                  CartButtons(label: 'Register', onTap: (){}, color: lightColorScheme.tertiary,)
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}