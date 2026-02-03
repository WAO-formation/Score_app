import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../shared/custom_text.dart';
import '../../../shared/theme_data.dart';
import '../upcoming_match_details.dart';

class UpcomingGamesCarousel extends StatelessWidget {
  const UpcomingGamesCarousel({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> matches = [
      {
        'teamA': 'Phoenix Risers',
        'teamB': 'Ocean Warriors',
        'time': '1:00 PM',
        'date': '8 April 2025',
        'venue': 'Phoenix Arena'
      },
      {
        'teamA': 'Mountain Kings',
        'teamB': 'Star Strikers',
        'time': '3:30 PM',
        'date': '11 April 2025',
        'venue': 'Mountain Stadium'
      },
      {
        'teamA': 'Thunder Bolts',
        'teamB': 'Forest Rangers',
        'time': '5:45 PM',
        'date': '14 April 2025',
        'venue': 'Thunder Dome'
      },
      {
        'teamA': 'Silver Wolves',
        'teamB': 'Golden Eagles',
        'time': '7:30 PM',
        'date': '16 April 2025',
        'venue': 'Wolf Den Arena'
      },
      {
        'teamA': 'Diamond Sharks',
        'teamB': 'Crown Royals',
        'time': '2:15 PM',
        'date': '19 April 2025',
        'venue': 'Central WAO Stadium'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: CarouselSlider.builder(
        itemCount: matches.length,
        itemBuilder: (context, index, realIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: UpcomingGames(
              teamA: matches[index]['teamA'],
              teamB: matches[index]['teamB'],
              time: matches[index]['time'],
              date: matches[index]['date'],
              venue: matches[index]['venue'],
            ),
          );
        },
        options: CarouselOptions(
          height: 245,
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 5),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
          pauseAutoPlayOnTouch: true,
        ),
      ),
    );
  }
}

class UpcomingGames extends StatelessWidget {
  final String teamA;
  final String teamB;
  final String time;
  final String date;
  final String venue;

  const UpcomingGames({
    Key? key,
    this.teamA = "Team A",
    this.teamB = "Team B",
    this.time = "1:00 PM",
    this.date = "23 March 2025",
    this.venue = "CMU Africa Sporting Complex",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameDetailsPage())
        );
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xffA7C8FE),
              const Color(0xffA7C8FE).withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 14.0,
                    backgroundImage: AssetImage("assets/images/WAO_LOGO.jpg"),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "WAO! Sport League",
                    style: AppStyles.informationText.copyWith(
                      color: lightColorScheme.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Teams and Match Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Team A
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 24.0,
                          backgroundImage: AssetImage("assets/images/teams.jpg"),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        teamA,
                        style: AppStyles.informationText.copyWith(
                          color: lightColorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Match Details
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "VS",
                        style: AppStyles.secondaryTitle.copyWith(
                          color: lightColorScheme.error,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          time,
                          style: AppStyles.informationText.copyWith(
                            color: lightColorScheme.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Team B
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 24.0,
                          backgroundImage: AssetImage("assets/images/teams.jpg"),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        teamB,
                        style: AppStyles.informationText.copyWith(
                          color: lightColorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20.0),

            // Date and Venue Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: lightColorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: AppStyles.informationText.copyWith(
                          color: lightColorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Venue
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: lightColorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        venue,
                        style: AppStyles.informationText.copyWith(
                          color: lightColorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}