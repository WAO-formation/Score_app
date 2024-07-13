import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/screens/login.dart';
import 'package:wao_mobile/screens/signup.dart';
import 'package:wao_mobile/screens/teams_dashboard.dart';
import 'dart:ui';

import 'Theme/dark_theme.dart';
import 'Theme/light_theme.dart';
import 'Theme/theme_provider.dart';
import 'custom_widgets/bottom_nav_bar.dart';

void main() {
  runApp(
       MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAO Score App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home:  BottomNavBar(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        //appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          //title: Text(widget.title),
         // backgroundColor: const Color.fromARGB(255, 193, 2, 48),
        //),

        body: Container(
          // Attach background image
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/WAO_LOGO.jpg"),
                fit: BoxFit.contain,
                opacity: 0.2,
              )
          ),

          child: Center(
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
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                /* === SignUp button */
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MySignUpPage())
                    );
                  },
                  label: const Text("I'm new to WAO"),
                  backgroundColor: const Color.fromARGB(255, 1, 30, 65),
                  foregroundColor: const Color.fromARGB(255, 162, 170, 173),
                  hoverColor: Colors.indigo,
                  heroTag: Object(),
                ),

                const SizedBox(height: 20.0),

                /* === SignIn button */
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyLoginPage())
                    );
                  },
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 1, 30, 65)
                    ),
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }

}

