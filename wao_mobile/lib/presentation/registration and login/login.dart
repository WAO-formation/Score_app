import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/registration%20and%20login/signup.dart';

import '../../shared/bottom_nav_bar.dart';


void main() {
  runApp(const MyLoginPage());
}

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

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
      home: const LoginHomePage(title: 'Log In Page'),
    );
  }
}



class LoginHomePage extends StatefulWidget {
  const LoginHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginHomePage> createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage> {
  static const double spacePix = 20.0; // spacing pixel

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool isRememberMeChecked = false;



    return Scaffold(
      backgroundColor: const Color(0xff011638),// Set the background color
      body:  SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only( top: 80.0),
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
              // mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: <Widget>[
                /*======= LOGO Holder ======*/
                Container(
                  //margin: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                  width: 110.0,
                  height: 110.0,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/WAO_LOGO.jpg"),
                      fit: BoxFit.cover,
                      scale: 0.146,
                      filterQuality: FilterQuality.high,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                  ),
                ),

                /*======= Form heading ======*/
                const Text(
                    'WAO',
                    style: TextStyle(
                      fontSize: 35.0, fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 162, 170, 173),
                    )
                ),

                const SizedBox(height: 20.0), // space

                Container(
                    height: screenHeight*0.75 ,
                    padding: const EdgeInsets.only( top: 70.0, left: 20.0, right:20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                      ),
                    ),

                    child:  Column(
                        children:[

                          const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold,
                                color: Color(0xff011E41),
                              )
                          ),
                          const SizedBox(height: 35.0), // space

                          /*======= Email entry field ======*/

                          const TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle:  TextStyle(color: Color(0xff011638),),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixIcon: Icon(Icons.mail, color: Color(0xff333533),),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff011638),),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff011638),),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff011638),),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25.0), // space

                          /*======= Password entry field ======*/

                          const TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle:  TextStyle(color: Color(0xff011638),),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(color: Colors.grey),
                              suffixIcon: Icon(Icons.lock, color: Color(0xff333533),),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff011638),),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff011638),),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xff011638),),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.black, // Set your desired text color here
                            ),
                            obscureText: true,
                          ),


                          const SizedBox(height: 25.0), // space

                          /* ================ remember me and the forgot password functionality =============== */

                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: isRememberMeChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isRememberMeChecked = value ?? false;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Remember Me',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff011638),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:  Color(0xffC10230),
                                    ),
                                  ),
                                ),

                              ]
                          ),

                          SizedBox(height: spacePix), // space

                          /*======= Sign up button ======*/
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffC10230), // Background color of the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0), // Border radius
                                side: const BorderSide(
                                  color:Color(0xffC10230), // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  BottomNavBar())
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0xffffffff), // Text color
                              ),
                            ),
                          ),

                          SizedBox(height: spacePix-5), // space
                          /* === SignIn button */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an Account?',
                                style: TextStyle(
                                  color: Color(0xff011E41),
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SignupHomePage(title: '',))
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffC10230),
                                  ),
                                ),
                              ),

                            ],
                          )

                        ]
                    )
                )
              ],
            ),
          ),
        ),
      ),

    );
  }

}


