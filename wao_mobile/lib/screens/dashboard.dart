import 'package:flutter/material.dart';
import 'package:wao_mobile/Theme/theme_data.dart';
import '../custom_widgets/Welcome_box.dart';
import '../custom_widgets/custom_appbar.dart';
import '../custom_widgets/up_coming _matches.dart';
import 'about_dashboard.dart';
import 'all_teams.dart';
import 'livescore_dashboard.dart';
import 'package:wao_mobile/screens/teams_dashboard.dart';
import 'package:wao_mobile/screens/officiate_dashboard.dart';

void main() {
  runApp(const DashboardPage());
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAO Score App',
      debugShowCheckedModeBanner: false,
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
      home: const DashboardHome(title: 'Main Dashboard'),
    );
  }
}

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
  static const double spacePix = 10.0; // spacing pixel
  Color bgcolor =  lightColorScheme.surface;
  Color fgcolor =  lightColorScheme.surface;
  Color WlcContainer = lightColorScheme.secondary;
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
         bgcolor =  lightColorScheme.surface;
         fgcolor =  lightColorScheme.onSurface;
          WlcContainer = lightColorScheme.secondary;
        icon = Icons.light_mode;
        _tltip = "light mode";
      }else{
        bgcolor =  darkColorScheme.surface;
        fgcolor =  darkColorScheme.primary;
         WlcContainer = darkColorScheme.secondary;
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


    return Scaffold(
      backgroundColor: bgcolor, // Set the background color

      appBar:  CustomAppBar(
      title: 'Dashboard',
    ),
      body:   SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50.0),
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
             // mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: <Widget>[

                /** Dashboard logo tile */
                const WelcomeToWAO(title: 'Welcome to WAO',),
                const SizedBox(height: 30.0),

                /*======= Dahboard tiles ======*/

                // ROW 1 TILES
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UpcomingMatches(
                        teamA: 'Team A',
                        teamB: 'Team B',
                        date: 'June 20',
                        time: '12:20',
                        ImagePath1: 'assets/images/teams.jpg',
                        ImagePath2: 'assets/images/officiate.jpg',
                      ),
                      SizedBox(width:20.0),
                      UpcomingMatches(
                        teamA: 'Team A',
                        teamB: 'Team B',
                        date: 'June 20',
                        time: '12:20',
                        ImagePath1: 'assets/images/teams.jpg',
                        ImagePath2: 'assets/images/officiate.jpg',
                      ),

                      SizedBox(width:20.0),

                      UpcomingMatches(
                        teamA: 'Team A',
                        teamB: 'Team B',
                        date: 'June 20',
                        time: '12:20',
                        ImagePath1: 'assets/images/teams.jpg',
                        ImagePath2: 'assets/images/officiate.jpg',
                      ),

                      SizedBox(width:20.0),

                      UpcomingMatches(
                        teamA: 'Team A',
                        teamB: 'Team B',
                        date: 'June 20',
                        time: '12:20',
                        ImagePath1: 'assets/images/teams.jpg',
                        ImagePath2: 'assets/images/officiate.jpg',
                      ),
                      SizedBox(width:20.0),
                    ],
                  ),
                ),

                const SizedBox(height: 30.0),

                // ROW 2 TILES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        'Teams',
                        style: TextStyle(
                            fontSize:25.0,
                            fontWeight: FontWeight.bold
                        )
                    ),

                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>  allTeams())
                          );
                        },
                        child: const Text(
                            'See all',
                            style: TextStyle(
                                fontSize:20.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffC10230)
                            )
                        )
                    )
                  ],
                ),
                const SizedBox(height:20.0),

                const topTeams(
                  teamName: 'Team Q',
                  imagePath: 'assets/images/officiate.jpg',
                ),
                const SizedBox(height:20.0),

                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    otherTeams(
                      teamName: 'Team G',
                      imagePath: 'assets/images/teams.jpg',
                    ),
                    SizedBox(width:15.0),
                    otherTeams(
                      teamName: 'Team B',
                      imagePath: 'assets/images/livescores.jpg',
                    ),
                  ]
                )
              ],
            ),
        ),


      
    );
  }
}


class DashboardTile extends StatelessWidget {
  const DashboardTile({super.key, required this.tileLabel, required this.tileImage , required this.pageName});
  
  final String tileLabel;
  final String tileImage;
  final Widget pageName;

  static const double spacePix = 20.0;// spacing pixel


  @override
  Widget build(BuildContext context) {
    return Container(
      color:lightColorScheme.secondary,
      padding: const EdgeInsets.symmetric(horizontal:10.0, vertical:15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tile image
          Container(
            width: 150.0,
            height: 110,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(tileImage),
                fit: BoxFit.cover,
                scale: 0.146,
                filterQuality: FilterQuality.high,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),

          const SizedBox(height: spacePix), // space

          /*======= Tile button ======*/
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pageName)
              );
            },
            label: Text(tileLabel, style: const TextStyle(fontSize: 15),),
            backgroundColor: const Color.fromARGB(255, 193, 2, 48),
            foregroundColor: Colors.white70,
            hoverColor: Colors.black,
            heroTag: Object(),
          ),

        ]

      ),
    );

  
  }
}

