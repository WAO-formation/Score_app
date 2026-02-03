import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../shared/custom_text.dart';
import '../../scores/score_details.dart';

class LiveMatchesCarousel extends StatelessWidget {
  const LiveMatchesCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 5,
      itemBuilder: (context, index, realIndex) {

        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: LiveMatches(

          ),
        );
      },
      options: CarouselOptions(
        height: 280,
        viewportFraction: 0.95,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        enlargeCenterPage: false,
        scrollPhysics: BouncingScrollPhysics(),
      ),
    );
  }
}

class LiveMatches extends StatelessWidget {


  const LiveMatches({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int teamAPoints = 234;
    int teamBPoints = 284;
    int totalPoints = teamAPoints + teamBPoints;


    double teamAPercentage = (teamAPoints / totalPoints * 100).roundToDouble();
    double teamBPercentage = (teamBPoints / totalPoints * 100).roundToDouble();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB9D5FF),
            Color(0xFF88BBFF),
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.3),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.live_tv, color: Colors.white, size: 16),
                      const SizedBox(width: 6.0),
                      Text(
                        "LIVE",
                        style: AppStyles.informationText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      )
                    ],
                  ),
                ),
                _buildDetailsButton(context),
              ],
            ),
          ),


          _buildTeamScore("Team A", teamAPercentage, context),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 1),
          ),
          _buildTeamScore("Team B", teamBPercentage, context),
          const SizedBox(height: 16.0),

          // Location information aligned to left
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: lightColorScheme.secondary,
                      size: 18,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      'CMU Africa Sporting Complex',
                      style: AppStyles.informationText.copyWith(
                        color: lightColorScheme.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildTeamScore(String teamName, double percentage, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage("assets/images/teams.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12.0),
              Text(
                teamName,
                style: AppStyles.informationText.copyWith(
                  color: lightColorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  "${percentage.toStringAsFixed(1)}%",
                  style: AppStyles.secondaryTitle.copyWith(
                    color: lightColorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ScoreDetails()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: lightColorScheme.secondary,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: lightColorScheme.secondary.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Details',
          style: AppStyles.informationText.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}