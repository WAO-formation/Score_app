import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../shared/custom_text.dart';
import '../../../shared/theme_data.dart';


class UpcomingGamesCarousel extends StatelessWidget{
  const UpcomingGamesCarousel({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: CarouselSlider(
        items: List.generate(5, (index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: UpcomingGames(),
          );
        }),
        options: CarouselOptions(
            height: 210,
            viewportFraction: 1,
            autoPlay: true
        ),
      ),
    );
  }
}


class UpcomingGames extends StatelessWidget {
  const UpcomingGames({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

   return Center(
      child: Container(
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
                    Text(
                        "VS",
                        style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.error, fontSize: 20.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10.0),
                    Text(
                        "1:00 PM",
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Text(
                    "Date:",
                    style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.bold)
                ),

                const SizedBox(width: 10.0,),

                Text(
                    "23 March 2025",
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
    );
  }
}
