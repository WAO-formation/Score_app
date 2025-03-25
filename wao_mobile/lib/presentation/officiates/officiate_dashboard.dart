import 'package:flutter/material.dart';

import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/custom_buttons.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';

class OfficiatePage extends StatelessWidget {
  const OfficiatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAO Score App',
      theme: ThemeData(
        fontFamily: 'Bronzier medium',
      ),
      home: const OfficiateHome(title: 'Main Officiate'),
    );
  }
}

class OfficiateHome extends StatefulWidget {
  const OfficiateHome({super.key, required this.title});

  final String title;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Officiating Guideline'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: guidelineData.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20.0),
                itemBuilder: (context, index) {
                  return GuidelineSection(
                    title: guidelineData[index]['title'],
                    contentList: guidelineData[index]['content'],
                  );
                },
              ),
            ),

            const SizedBox(height: 30.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CartButtonWidget(label: 'Register',  onTap: () {  },),
                
                SizedBox(width: 20.0,),
                
                CartButtonWidget(label: 'Download Guide', onTap: (){}, color: lightColorScheme.secondary,)
              ],
            ),


          ],
        ),
      ),
    );
  }
}

class GuidelineSection extends StatelessWidget {
  const GuidelineSection({
    super.key,
    required this.title,
    required this.contentList,
  });

  final String title;
  final List<String> contentList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppStyles.primaryTitle,
        ),
        const SizedBox(height: 10.0),
        ...contentList.map((content) => Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff2F3B4A),
            ),
          ),
        )).toList(),
      ],
    );
  }
}