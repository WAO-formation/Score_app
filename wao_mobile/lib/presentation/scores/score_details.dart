import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/scores/widgets/match_analysis.dart';

import '../../shared/custom_appbar.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';
import '../dashboard/widgets/ranking.dart';

class ScoreDetails extends StatefulWidget{
  const ScoreDetails({super.key});

  @override
  State<ScoreDetails> createState() => _ScoreDetailsState();
}

class _ScoreDetailsState extends State<ScoreDetails> {

  int currentQuarter = 1;
  int remainingSeconds = 20;
  Timer? _timer;
  bool isHalftime = false;
  bool isMatchOver = false;

  /// Time for each quarter (in seconds)
  final List<int> quarterDurations = [20, 18, 15, 12];

  @override
  void initState() {
    super.initState();
    startQuarterCountdown();
  }

  void startQuarterCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        if (currentQuarter == 1 || currentQuarter == 3) {
          showHalftime();
        } else {
          moveToNextQuarter();
        }
      }
    });
  }

  void showHalftime() {
    setState(() {
      isHalftime = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isHalftime = false;
        moveToNextQuarter();
      });
    });
  }

  void moveToNextQuarter() {
    if (currentQuarter < 4) {
      setState(() {
        currentQuarter++;
        remainingSeconds = quarterDurations[currentQuarter - 1];
      });
      startQuarterCountdown();
    } else {
      setState(() {
        isMatchOver = true;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    if (isHalftime || isMatchOver) return "00 : 00";
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')} : ${secs.toString().padLeft(2, '0')}";
  }

  /// this is holding data for score breakdown
  final Map<String, List<int>> scoreData = {
    "Kingdom (30%)": [12, 9],
    "Workout (30%)": [14, 11],
    "Goalposts (30%)": [15, 14],
    "Hi Court/Judges (10%)": [4, 4]
  };



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: CustomAppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back, color: Colors.white,
          ),
        ),
        title: 'Live Score',
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical:  20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  color: const Color(0xffA7C8FE ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [



                    SizedBox(height: 20.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const CircleAvatar(
                              radius: 20.0,
                              backgroundImage: AssetImage("assets/images/teams.jpg") ,
                            ),

                            const SizedBox(height: 10.0),
                            Text(
                                "Team A",
                                style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.w500)),
                          ],
                        ),

                        Column(
                          children: [

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                              decoration: BoxDecoration(
                                color:  isMatchOver
                              ? Colors.red
                                  : isHalftime
                              ? Colors.greenAccent
                                  : lightColorScheme.tertiary,
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child:  Text(
                                isMatchOver
                                    ? "Match Over"
                                    : isHalftime
                                    ? "Half Time"
                                    : "Quarter: $currentQuarter",
                                  style: AppStyles.informationText.copyWith(color: lightColorScheme.onPrimary, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            Text(
                                formatTime(remainingSeconds),
                                style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.w500)),
                          ],
                        ),


                        Column(
                          children: [
                            const CircleAvatar(
                              radius: 20.0,
                              backgroundImage: AssetImage("assets/images/teams.jpg") ,
                            ),

                            const SizedBox(height: 10.0),
                            Text(
                                "Team B",
                                style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.w500)),
                          ],
                        ),


                      ],
                    ),

                    SizedBox(height: 20.0,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Text(
                            "Total: 34%",
                            style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.bold)
                        ),

                        const Icon(
                          Icons.sports_basketball, size: 30.0, color: Colors.white,
                        ),

                        Text(
                            "Total: 61%",
                            style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),

                    const SizedBox(height: 20.0,),

                    Row(
                      children: [
                        Text(
                          'Venue :',
                          style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(width: 10.0,),

                        Text(
                          'CMU Africa Sporting Complex',
                          style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 30.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Scores Breakdown',
                      style:AppStyles.secondaryTitle
                  ),
                ],
              ),
              const SizedBox(height:10.0),


              ScoreBreakdown(scoreData: scoreData),


              const SizedBox(height: 30.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Ranking',
                      style:AppStyles.secondaryTitle
                  ),
                ],
              ),
              const SizedBox(height:10.0),

              const LeagueRanking()

            ],
          ),
        ),
      ),
    );
  }
}
