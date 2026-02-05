import 'package:flutter/material.dart';
import 'package:wao_mobile/View/dashboard/widgets/liveMatches.dart';
import 'package:wao_mobile/View/dashboard/widgets/ranking.dart';
import 'package:wao_mobile/View/dashboard/widgets/upcoming_games.dart';
import '../../provider/Models/teams-class.dart';
import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';
import 'widgets/up_coming _matches.dart';
import '../teams/all_teams.dart';


class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
// spacing pixel
  Color bgcolor =  lightColorScheme.surface;
  Color fgcolor =  lightColorScheme.surface;
  Color WlcContainer = lightColorScheme.secondary;
  IconData icon = Icons.light_mode;



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _toggleTheme method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      //backgroundColor: bgcolor, // Set the background color

      appBar:  CustomAppBar(
      title: 'Dashboard',
    ),
      body:   SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
             // mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: <Widget>[

               // this section carries user profile and a punch line

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                          const CircleAvatar(
                            radius: 30.0,
                            backgroundImage: AssetImage("assets/images/teams.jpg") ,
                          ),
                    
                        const SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Hi Afanyu",
                                style: AppStyles.secondaryTitle.copyWith(fontSize: 18.0)
                            ),
                    
                            const SizedBox(height: 5.0,),
                            Text(
                                'Lets Play WAO', style: AppStyles.informationText.copyWith(color: Colors.grey, fontSize: 14.0)
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: const Icon(Icons.notifications_active_outlined, color: Colors.grey,),
                    )
                  ],
                ),

                const SizedBox(height: 20.0),

                // Quote Section



                /// this section will be displaying all live matches

                const LiveMatchesCarousel(),

                const SizedBox(height: 30.0),

                /// upcoming games to be played

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                        'Upcoming Games',
                        style:AppStyles.secondaryTitle
                    ),
                  ],
                ),
                const SizedBox(height:10.0),

                const UpcomingMatchesCarousel(),

                /// this section contain statistics of the past marches

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


      
    );
  }
}


