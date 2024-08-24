import 'package:flutter/material.dart';

import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/theme_data.dart';



class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key, });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
        title: 'Privacy Rules',
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),

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
              /** About logo tile */
              WelcomeToWAO(title: 'WAO Privacy Rules',),

              SizedBox(height:60.0),

              const AboutTile(
                tileLabel: "About WAO",
                tileContent: "WAO is a 2-ball multiple scoring sport played on a spherical pitch, and thrives on technology. (WAO is acronym for World As One)",
              ),

              SizedBox(height:20.0),
              const AboutTile(
                tileLabel: "Vision",
                tileContent: "To champion world oneness, pleasurably tell our stories and bring development through WAO!",

              ),

              SizedBox(height:20.0),
              const AboutTile(
                tileLabel: "Mission",
                tileContent: "Through organizing World-class edutainment, we empower WAO lovers to use our success in the Sport as a nucleus for success in other areas of life beyond WAO Sport.",

              ),

              const SizedBox(height: 30.0),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightColorScheme.primary, // Background color of the button
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

            ],
          ),
        ),

      ),



    );
  }
}


class AboutTile extends StatelessWidget {
  const AboutTile({super.key, required this.tileLabel, required this.tileContent, });

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

