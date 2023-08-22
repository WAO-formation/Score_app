import 'package:flutter/material.dart';

import 'dashboard.dart';


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
  Color bgcolor =  const Color.fromARGB(255, 1, 30, 65);
  Color fgcolor =  const Color.fromARGB(255, 162, 170, 173);
  int _counter = 0;     
  IconData icon = Icons.light_mode;
  String _tltip = "light mode";

  void _toggleTheme() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      if (_counter%2 == 0) {
        bgcolor =  const Color.fromARGB(255, 1, 30, 65);
        fgcolor =  const Color.fromARGB(255, 162, 170, 173);
        icon = Icons.light_mode;
        _tltip = "light mode";
      }else{
        bgcolor = const Color.fromARGB(255, 162, 170, 173);
        fgcolor = const Color.fromARGB(255, 1, 30, 65);
        icon = Icons.dark_mode;
        _tltip = "dark mode";
      }
      _counter -= 2;
    });
  }


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
    
    AppBar appBar = AppBar(
      // Here we create our AppBar and style it
      backgroundColor: const Color.fromARGB(255, 193, 2, 48),
      
      title: Row( 
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(onPressed: _toggleTheme, icon: Icon( icon ), tooltip: _tltip,),
        ]
      ),
    );
    
    return Scaffold(
      backgroundColor: bgcolor, // Set the background color 
      
      appBar: appBar,
      
      body:  Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            /** LiveScores logo tile */
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05, vertical: screenHeight*0.005),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color.fromARGB(255, 193, 2, 48),
              ),
              
              child : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tile image
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: AssetImage("assets/images/WAO_LOGO.jpg"), 
                        fit: BoxFit.cover,
                        scale: 0.0195,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),

                  const SizedBox(width: spacePix),

                  const Text(
                    "WAO SPORT", 
                    style: TextStyle(
                      fontSize: 15, 
                      color:  Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              )
            ),

            const SizedBox(height: spacePix), // space

            /** Heading */
            Text(
              'Live Scores', 
              style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: fgcolor,
              ),
            ),
            
            /*======= Score tile ======*/
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: screenHeight*0.005),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: fgcolor,
                borderRadius: BorderRadius.circular(10)
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    'WAO Match', 
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: bgcolor,
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
                        tileColor: fgcolor, 
                        textColor: bgcolor,
                        isAway: true,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: screenHeight*0.1,
                            child: Text(
                              '40 : 100', 
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: bgcolor,
                              ),
                            )
                          ),

                          Text(
                            "32 '", 
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: bgcolor,
                            ),
                          )

                        ],
                      ),
                     
                      LiveScoresTile(
                        tileLabel: "GRT FC", 
                        tileImage: "assets/images/team2.jpg", 
                        tileWidth: screenWidth, 
                        tileHeight: screenHeight, 
                        tileColor: fgcolor, 
                        textColor: bgcolor,
                        isAway: false,
                      ),
                    ],
                  )
                
                ],
              ),
            ),

            Text(
              'Matches', 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: fgcolor,
              ),
            ),
            
            /// list of matches
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.1, vertical: screenHeight*0.005),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 193, 2, 48),
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
                color: const Color.fromARGB(255, 193, 2, 48),
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

            Container(
              width: 400,
              height: 60,
              decoration: BoxDecoration(
                color: bgcolor,
              ),
              child: const Row(

              ),
            ),

          ],
        ),
        
      ),
      
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 193, 2, 48),
        ),
        height: appBar.preferredSize.height,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const DashboardPage())
            );
          }, 
          foregroundColor: Colors.white70,
          label: const Text("Dashboard")
        ),
      )
      
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
