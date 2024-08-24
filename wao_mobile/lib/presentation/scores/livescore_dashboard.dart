import 'package:flutter/material.dart';

import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/theme_data.dart';



void main() {
  runApp(const LiveScoresPage());
}

class LiveScoresPage extends StatelessWidget {
  const LiveScoresPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAO Score App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        fontFamily: 'Bronzier medium',

      ),
      home: const LiveScoresHome(title: 'Main LiveScores'),
    );
  }
}

class LiveScoresHome extends StatefulWidget {
  const LiveScoresHome({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LiveScoresHome> createState() => _LiveScoresHomeState();
}

class _LiveScoresHomeState extends State<LiveScoresHome> {
  static const double spacePix = 20.0; // spacing pixel

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
      backgroundColor: Colors.white, // Set the background color

      appBar: CustomAppBar(title: 'Live Score',),

      body:  Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 40.0),
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
             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: <Widget>[
                /** LiveScores logo tile */
                const WelcomeToWAO(title: ' WAO Live Score',),
                const SizedBox(height: spacePix), // space

                /** Heading */
                 Text(
                  'Live Scores',
                  style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: lightColorScheme.secondary,
                  ),
                ),
                SizedBox(height:10.0),
                /*======= Score tile ======*/
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: screenHeight*0.005),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  decoration: BoxDecoration(
                    color: lightColorScheme.primary,
                    borderRadius: BorderRadius.circular(10)
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      const Text(
                        'WAO Match',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          LiveScoresTile(
                            tileLabel: "SQ FC",
                            tileImage: "assets/images/team1.jpg",
                            tileWidth: screenWidth,
                            tileHeight: screenHeight,
                            tileColor: Colors.white,
                            textColor: Colors.white,
                            isAway: true,
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: screenHeight*0.1,
                                child: const Text(
                                  '40 : 100',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ),

                              const Text(
                                "32 '",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )

                            ],
                          ),

                          LiveScoresTile(
                            tileLabel: "GRT FC",
                            tileImage: "assets/images/team2.jpg",
                            tileWidth: screenWidth,
                            tileHeight: screenHeight,
                            tileColor: Colors.white,
                            textColor: Colors.white,
                            isAway: false,
                          ),
                        ],
                      )

                    ],
                  ),
                ),

                SizedBox(height: 30.0),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffffff), // Background color of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                      side:  BorderSide(
                        color:  lightColorScheme.primary, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                  ),
                  onPressed: () {},
                  child:  Text(
                    'Details',
                    style: TextStyle(
                      fontSize: 15.0,
                      color:  lightColorScheme.primary, // Text color
                    ),
                  ),
                ),

                SizedBox(height: 30.0),

                 Text(
                  'Up Coming Matches',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.secondary,
                  ),
                ),

                SizedBox(height: 20.0),
                /// list of matches
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: screenHeight*0.005),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: lightColorScheme.secondary,
                    borderRadius: BorderRadius.circular(10)
                  ),

                  child: UpcomingMatchesTile(
                    teamNames: const ["AGN","FDS"],
                    teamImages: const ["assets/images/team1.jpg","assets/images/team2.jpg"],
                    matchTime: "08 : 25",
                    matchDate: "10 AUG",
                    tileWidth: screenWidth,
                    tileHeight: screenHeight
                  )

                ),

                const SizedBox(height: spacePix-10),

                Container(
                    margin: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: screenHeight*0.005),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: lightColorScheme.secondary,
                        borderRadius: BorderRadius.circular(10)
                    ),

                    child: UpcomingMatchesTile(
                        teamNames: const ["AGN","FDS"],
                        teamImages: const ["assets/images/team1.jpg","assets/images/team2.jpg"],
                        matchTime: "08 : 25",
                        matchDate: "10 AUG",
                        tileWidth: screenWidth,
                        tileHeight: screenHeight
                    )

                ),

                const SizedBox(height: spacePix-10),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: screenHeight*0.005),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color:   lightColorScheme.secondary,
                    borderRadius: BorderRadius.circular(10)
                  ),

                  child: UpcomingMatchesTile(
                    teamNames: const ["QWE","DSX"],
                    teamImages: const ["assets/images/team1.jpg","assets/images/team2.jpg"],
                    matchTime: "05 : 25",
                    matchDate: "10 NOV",
                    tileWidth: screenWidth,
                    tileHeight: screenHeight
                  )

                ),
                const SizedBox(height: spacePix-10),

              ],
            ),
          ),
        ),

      ),
    );
  }
}


class LiveScoresTile extends StatelessWidget {
  const LiveScoresTile({super.key, required this.tileLabel, required this.tileImage , required this.tileWidth, required this.tileHeight, required this.tileColor,required this.textColor, required this.isAway});
  
  final String tileLabel;
  final String tileImage;
  final double tileWidth;
  final double tileHeight;
  final Color tileColor;
  final Color textColor;
  final bool isAway;

  static const double spacePix = 5.0; // spacing pixel 

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Team image
        Container(
          width: tileWidth*0.20,
          height: tileHeight*0.1,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(tileImage), 
              fit: BoxFit.cover,
              scale: (tileWidth*0.20)/1024,
              filterQuality: FilterQuality.high,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
                      
        /*======= Team name ======*/
        Text(
          tileLabel.toUpperCase(), 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),

        /*======= AWAY OR HOME name======*/
        Text(
          (isAway) ? "AWAY" : "HOME", 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ]
    
    );
  
  }
}


class UpcomingMatchesTile extends StatelessWidget {
  const UpcomingMatchesTile({super.key, required this.teamNames, required this.teamImages , required this.matchTime, required this.matchDate, required this.tileWidth, required this.tileHeight});
  
  final List<String> teamNames;
  final List<String> teamImages;
  final String matchTime;
  final String matchDate;
  final double tileWidth;
  final double tileHeight;

  static const double spacePix = 5.0; // spacing pixel 

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        /*======= Team 1 name ======*/
        Text(
          teamNames[0].toUpperCase(), 
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),

        // Team 1 image
        Container(
          width: tileWidth*0.15,
          height: tileHeight*0.02,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(teamImages[0]), 
              fit: BoxFit.cover,
              scale: (tileWidth*0.15)/1024,
              filterQuality: FilterQuality.high,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
                      
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*======= Match time ======*/
            Text(
              matchTime.toUpperCase(), 
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),

            /*======= Match date ======*/
            Text(
              matchDate.toUpperCase(), 
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        // Team 2 image
        Container(
          width: tileWidth*0.15,
          height: tileHeight*0.02,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(teamImages[1]), 
              fit: BoxFit.cover,
              scale: (tileWidth*0.15)/1024,
              filterQuality: FilterQuality.high,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
         
        /*======= Team 2 name ======*/
        Text(
          teamNames[1].toUpperCase(), 
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),

      ]
    
    );
  
  }
}
