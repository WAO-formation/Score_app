import 'package:flutter/material.dart';

import 'package:wao_mobile/Theme/theme_data.dart';
import '../../custom_widgets/Welcome_box.dart';
import '../../custom_widgets/custom_appbar.dart';
import '../dashboard/dashboard.dart';



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

      appBar: CustomAppBar(title: 'Officials',),

      body:  Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

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
            //mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: <Widget>[
              /** Officiate logo tile */
              const WelcomeToWAO(title: ' WAO Officials',),

              const SizedBox(height: 80.0), // space

              const OfficiateTile(
                tileLabel: "Referee's Call",
                tileContent: "WAO fictions war, but death is ruled out. Opposing teams compete in an open field to outwit each other and prove supremacy by scoring. The One to police by rules and turn everything into showbiz is the Referee -without a competent Referee there will be chaos and no order to determine a winner.",

              ),

              const SizedBox(height: 40.0),

              const OfficiateTile(
                tileLabel: "Referee's Purpose",
                tileContent: "The purpose of WAO Referee is to officiate games fairly that even the losing team can say in all sincerity \"thank you Referee\".",

              ),

              const SizedBox(height: 50.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // More pdf download
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
                      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
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
                    child:  Text(
                      'More',
                      style: TextStyle(
                        fontSize: 15.0,
                        color:  lightColorScheme.primary, // Text color
                      ),
                    ),
                  ),

                  // Register button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  lightColorScheme.primary, // Background color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Border radius
                        side:  BorderSide(
                          color:  lightColorScheme.primary, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20.0),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Color(0xffffffff), // Text color
                      ),
                    ),
                  ),

                ],
              )

            ],
          ),
        ),

      ),
      
    );
  }
}


class OfficiateTile extends StatelessWidget {
  const OfficiateTile({super.key, required this.tileLabel, required this.tileContent, });
  
  final String tileLabel;
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
          Text(
            tileLabel.toUpperCase(), 
            style:  TextStyle(
              fontSize: 18,
              color:  lightColorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height:10.0),
          
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

