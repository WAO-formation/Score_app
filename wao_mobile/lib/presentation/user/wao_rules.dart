import 'package:flutter/material.dart';

import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/theme_data.dart';




class GameRules extends StatefulWidget {
  const GameRules({super.key, });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<GameRules> createState() => _GameRulesState();
}

class _GameRulesState extends State<GameRules> {
// spacing pixel


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _toggleTheme method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.



    return Scaffold(
      backgroundColor: Colors.white, // Set the background color

      appBar:  CustomAppBar(
        title: 'Rules',
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),

      body:  SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.

          child: Container(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 40.0, bottom: 60.0),
            child: Column(
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
              //mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: <Widget>[
                /** About logo tile */
                const WelcomeToWAO(title: ' WAO Game Rules',),

                const SizedBox(height:60.0),

                 Column(
                  children: [

                    Text(
                      'WAO SPORT BASIC RULES & PROFILE'.toUpperCase(),
                      style:  TextStyle(
                        fontSize: 18,
                        color:  lightColorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height:10.0),

                    SizedBox(height:20.0),
                    AboutTile(
                      tileContent: 'WAO is a 2-ball multiple-scoring contact sport played on a spherical pitch and thrives on technology '
                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'The object of the sport is to score a higher percentage sum of the opposing team',

                    ),

                    SizedBox(height:10.0),
                    AboutTile(
                        tileContent: 'The four cardinal places to score points are Kingdom, Workout, Goalpost and Judges '
                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'A Team is made up of 7 Players plus 5 subs; thus 14 Players at each time on the WaoSphere. ',

                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'We live on a spherical planet filled with continents; exactly as the WaoSphere, but this time the whole world-as-one WAO!',

                    ),

                    SizedBox(height:10.0),
                    AboutTile(
                        tileContent: 'Every part of WaoSphere is playable by all, any Player can score points anywhere with any ball.  '
                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'Handle and control ball by bouncing, dribbling, giving passes, displaying skills or movement in any direction. '
                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'Blocking is part of defense and to “kiss-a-crown” can be likened to “dunk”. ',

                    ),

                    SizedBox(height:10.0),
                    AboutTile(
                        tileContent: 'A game starts with a maximum of 2 balls of different colours.  '
                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'Each team starts with 1 ball playing offence and defence at the same time. ',

                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'Upon start tip off, each Team makes a long throw from Kingdom to Hi-Court, and then play on. Teams do not own a ball; anyone can play and score with any ball. ',

                    ),

                    SizedBox(height:10.0),
                    AboutTile(
                        tileContent: 'Each Team is expected to score points with the ball at hand and at the same time compete for possession of the opponent\'s ball to score points with it.  '
                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'If 1 Player possesses the 2 balls, control balls in alternating bounce. '
                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'There is a maximum of 2-field Referees, each officiates interactions around the ball he wears its color.',

                    ),

                    SizedBox(height:10.0),
                    AboutTile(
                        tileContent: 'A panel of 6 Judges sit behind Hi-court areas in threesome apart to rule Hi-Court cases.'
                    ),

                    SizedBox(height:10.0),
                    AboutTile(tileContent: 'A game is played in 4 quarters; 1st 17 min. 2nd 17 min. 3rd 13 min, and 4th 13 min. for total time of 60 minutes, or play extra time if need be to break a tie.'
                    ),
                  ]
                ),

                const SizedBox(height: 30.0),


              ],
            ),
          ),

        ),
      ),

      bottomNavigationBar: gameRulesButtomNav(),
    );
  }
}


class AboutTile extends StatelessWidget {
  const AboutTile({super.key,   required this.tileContent, });


  final String tileContent;


  static const double spacePix = 3.0; // spacing pixel 

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*======= Section heading ======*/


              const SizedBox(height: spacePix), // space

              // Section content
              Text(
                tileContent,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff2F3B4A),
                ),
              )
            ]
        )
    );

  }
}

class gameRulesButtomNav extends StatefulWidget{
  @override
  State<gameRulesButtomNav> createState() => gameRulesButtomNavState();

}

class gameRulesButtomNavState extends State<gameRulesButtomNav>{
  @override
  Widget build(BuildContext context) {

    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      height: 100.0,
      color: Colors.white,
      child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:  lightColorScheme.primary, // Background color of the button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Border radius
                side:  BorderSide(
                  color: lightColorScheme.primary, // Border color
                  width: 2.0, // Border width
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
            ),
            onPressed: () {
              const snackBar = SnackBar(
                duration: Duration(seconds: 5),
                content: Column(
                  children: [

                    Text('Downloading...'),
                    SizedBox(width: 20),
                    LinearProgressIndicator(),

                  ],
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

            },
            child: const Text(
              'More',
              style: TextStyle(
                fontSize: 15.0,
                color: Color(0xffffffff), // Text color
              ),
            ),
          ),

      ),
    );
  }

}
