import 'package:flutter/material.dart';
import '../custom_widgets/Welcome_box.dart';
import '../custom_widgets/custom_appbar.dart';
import 'dashboard.dart';



class TeamsHome extends StatefulWidget {
  const TeamsHome({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TeamsHome> createState() => _TeamsHomeState();
}

class _TeamsHomeState extends State<TeamsHome> {
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
      
      appBar: CustomAppBar(
        title: 'Team Details',
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
            margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 5.0,),
            child:  Column(
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

              children: <Widget>[
                /** Teams logo tile */
                const WelcomeToWAO(title: ' WAO Team Details',),
                const SizedBox(height: 20.0),

                Image.asset(
                    'assets/images/teams.jpg',
                    height: 235.0
                ),

                const SizedBox(height:20.0),

                 Container(
                   margin: EdgeInsets.only(left: 15.0, right: 15.0 ),
                   child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[

                      // basic team information regarding their achievement
                       Container(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical:20.0),
                          decoration: BoxDecoration(
                              color: const Color(0xff011638),
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          child:  const Column(
                            children: <Widget> [
                              Text(
                                "Goals",
                                style:  TextStyle(
                                    color: Color(0xffC10230),
                                    fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                "20",
                                style:  TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ]
                          )
                        ),


                       Container(
                            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical:20.0),
                            decoration: BoxDecoration(
                                color: Color(0xff011638),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child:  const Column(
                                children: <Widget> [
                                  Text(
                                    "Games",
                                    style:  TextStyle(
                                        color: Color(0xffC10230),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    "4",
                                    style:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                                ]
                            )
                        ),


                       Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical:20.0),
                            decoration: BoxDecoration(
                                color: const Color(0xff011638),
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child:  const Column(
                                children: <Widget> [
                                  Text(
                                    "Points",
                                    style:  TextStyle(
                                        color: Color(0xffC10230),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    "15",
                                    style:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                                ]
                            )
                        ),

                    ]
                                 ),
                 ),

                const SizedBox(height: 30.0),

                //short details about the team that the supporters have to know
                const Text(
                    'Team Information',
                  style:  TextStyle(
                      color: Color(0xffC10230),
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold
                  ),
                ),

                const SizedBox(height: 10.0),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,),
                  child: const Text(
                    'WAO is a 2-ball multiple scoring sport played on a spherical pitch, and thrives on technology. (WAO is acronym for World As One)',
                    style:  TextStyle(
                        color: Color(0xff2F3B4A),
                        fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 25.0),

                //call to action for the supporters to follow the team so that they can get updated when their team is having a match
                //for this section if the user is already following the team then this section won't be displayed to the current user

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0,),
                  child: const Text(
                    'In order to get team updates about matches and success achieved by the team click the button below to follow the team.',
                    style:  TextStyle(
                      color: Color(0xff2F3B4A),
                      fontSize: 20.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20.0),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  const Color(0xffC10230),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                  ),
                  onPressed: (){},
                  child: const Text(
                    'Follow',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20.0),

              ],
            ),
          ),
        ),
      ),

    );
  }
}



