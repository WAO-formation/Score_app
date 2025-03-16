import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../shared/custom_text.dart';


class LiveMatchesCarousel extends StatelessWidget{
  const LiveMatchesCarousel({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: CarouselSlider(
        items: List.generate(5, (index) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: LiveMatches(),
          );
        }),
        options: CarouselOptions(
          height: 260,
          //enlargeCenterPage: true,
          viewportFraction: 1,
          autoPlay: true
        ),
      ),
    );
  }
}


class LiveMatches extends StatelessWidget {



  const LiveMatches({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //in this container we describe the container that will be used to display the upcoming matches in a slider
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xffA7C8FE ),
          borderRadius: BorderRadius.circular(20.0), // Adding border radius to the container
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.live_tv, color: Colors.white,),

                      const SizedBox(width: 10.0,),

                      Text("Live", style: AppStyles.informationText.copyWith(color:  Colors.white)  )
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  decoration: BoxDecoration(
                      color: lightColorScheme.secondary,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Text(
                    'Details',
                    style: AppStyles.informationText.copyWith(color: Colors.white),
                  ),
                )
              ],
            ),

            SizedBox(height: 20.0,),

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

            SizedBox(height: 20.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage("assets/images/teams.jpg") ,
                    ),

                    const SizedBox(width: 10.0),
                    Text(
                        "Team A",
                        style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.w500)),
                  ],
                ),

                Text(
                    "234",
                    style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.bold)),
              ],
            ),

            SizedBox(height: 20.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20.0,
                      backgroundImage: AssetImage("assets/images/teams.jpg") ,
                    ),

                    const SizedBox(width: 10.0),
                    Text(
                        "Team B",
                        style: AppStyles.informationText.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.w500)),
                  ],
                ),

                Text(
                    "284",
                    style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.secondary, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
