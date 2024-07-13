import 'package:flutter/material.dart';

import 'package:wao_mobile/Theme/theme_data.dart';
import 'dashboard.dart';



void main() {
  runApp(const OfficiatePage());
}

class OfficiatePage extends StatelessWidget {
  const OfficiatePage({super.key});

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
      home: const OfficiateHome(title: 'Main Officiate'),
    );
  }
}

class OfficiateHome extends StatefulWidget {
  const OfficiateHome({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<OfficiateHome> createState() => _OfficiateHomeState();
}

class _OfficiateHomeState extends State<OfficiateHome> {
  static const double spacePix = 20.0; // spacing pixel 
  Color bgcolor =  lightColorScheme.surface;
  Color fgcolor =  lightColorScheme.surface;
  Color WlcContainer = lightColorScheme.secondary;
  Color TextColor = lightColorScheme.secondary;
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
        TextColor = lightColorScheme.secondary;
        icon = Icons.light_mode;
        _tltip = "light mode";
      }else{
        bgcolor =  darkColorScheme.surface;
        fgcolor =  darkColorScheme.primary;
        WlcContainer = darkColorScheme.secondary;
        TextColor = lightColorScheme.onSurface;
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            /** Officiate logo tile */
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.05, vertical: screenHeight*0.005),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
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
                    "Officiate WAO", 
                    style: TextStyle(
                      fontSize: 15, 
                      color:  Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              )
            ),

            const SizedBox(height: spacePix-5), // space

            OfficiateTile(
              tileLabel: "Referee's Call", 
              tileContent: "WAO fictions war, but death is ruled out. Opposing teams compete in an open field to outwit each other and prove supremacy by scoring. The One to police by rules and turn everything into showbiz is the Referee -without a competent Referee there will be chaos and no order to determine a winner.", 
              fgcolor: TextColor
            ),
            
            OfficiateTile(
              tileLabel: "Referee's Purpose", 
              tileContent: "The purpose of WAO Referee is to officiate games fairly that even the losing team can say in all sincerity \"thank you Referee\".", 
              fgcolor: TextColor
            ),
            
            const SizedBox(height: spacePix-10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // More pdf download
                FloatingActionButton.extended(
                  onPressed: () {}, 
                  label: const Text("more", style: TextStyle(fontSize: 15),),
                  backgroundColor: const  Color.fromARGB(255, 193, 2, 48),
                  foregroundColor: Colors.white70,
                  tooltip: "Referee_Manual.pdf",
                  heroTag: Object(),
                ),

                // Register button
                FloatingActionButton.extended(
                  onPressed: () {}, 
                  label: const Text("Register", style: TextStyle(fontSize: 15),),
                  backgroundColor: const  Color.fromARGB(255, 193, 2, 48),
                  foregroundColor: Colors.white70,
                  tooltip: "Referee-Registration-link",
                  heroTag: Object(),
                ),
          
              ],
            )

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
          label: const Text("Dashboard"),
          heroTag: Object(),
        ),
      )
      
    );
  }
}


class OfficiateTile extends StatelessWidget {
  const OfficiateTile({super.key, required this.tileLabel, required this.tileContent, required this.fgcolor});
  
  final String tileLabel;
  final String tileContent;
  final Color fgcolor;

  static const double spacePix = 3.0; // spacing pixel 

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      alignment: Alignment.center,
      margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*======= Section heading ======*/
          Text(
            tileLabel.toUpperCase(), 
            style: const TextStyle(
              fontSize: 15, 
              color:  Color.fromARGB(255, 193, 2, 48),
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: spacePix), // space

          // Section content
          Text(
            tileContent, 
            style: TextStyle(
              fontSize: 12, 
              color: fgcolor,
              fontWeight: FontWeight.bold,
            ),
          )
        ]
      )
    );
  
  }
}

