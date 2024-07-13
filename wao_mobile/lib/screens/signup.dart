import 'package:flutter/material.dart';
import '../custom_widgets/bottom_nav_bar.dart';
import 'login.dart';
import 'dashboard.dart';

void main() {
  runApp(const MySignUpPage());
}

class MySignUpPage extends StatelessWidget {
  const MySignUpPage({super.key});

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
      home: const SignUpHomePage(title: 'Sign Up Page'),
    );
  }
}

class SignUpHomePage extends StatefulWidget {
  const SignUpHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SignUpHomePage> createState() => _SignUpHomePageState();
}

class _SignUpHomePageState extends State<SignUpHomePage> {
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
    
    AppBar appBar = AppBar(
      // Here we take the value from the SignUpHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      backgroundColor: const Color.fromARGB(255, 193, 2, 48),
    );

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 30, 65), // Set the background color 
      
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
            /*======= Form heading ======*/
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 35.0, fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 162, 170, 173),
              )
            ),
            
           /*======= LOGO Holder ======*/
            Container(
              //margin: const EdgeInsets.fromLTRB(100, 0, 100, 0),
              width: 150.0,
              height: 150.0,
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
            
            const SizedBox(height: spacePix-10), // space

            /*======= Email entry field ======*/
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.07, vertical: screenHeight*0.005),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 162, 170, 173),
              ),
              
              child : const TextField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.email, size: 70, color: Color.fromARGB(255, 193, 2, 48),
                  ), 
                  hintText: 'Email Address',
                  hintStyle: TextStyle(fontWeight: FontWeight.w100)
                ),
                style: TextStyle(fontWeight: FontWeight.bold,),
                keyboardType: TextInputType.emailAddress,
                cursorWidth: 3.0,
                cursorColor: Colors.black,
              ),

            ),
            
            /*======= Password entry field ======*/
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.07, vertical: screenHeight*0.005),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 162, 170, 173),
              ),
              
              child : const TextField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock, size: 70, color: Color.fromARGB(255, 193, 2, 48),
                  ), 
                  hintText: 'Password',
                  hintStyle: TextStyle(fontWeight: FontWeight.w100)
                ),
                style: TextStyle(fontWeight: FontWeight.bold,),
                keyboardType: TextInputType.visiblePassword,
                cursorWidth: 3.0,
                cursorColor: Colors.black,
              ),

            ),
            
            /*======= Password re-entry field ======*/
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: screenWidth*0.07, vertical: screenHeight*0.005),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 162, 170, 173),
              ),
              
              child : const TextField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock, size: 70, color: Color.fromARGB(255, 193, 2, 48),
                  ), 
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(fontWeight: FontWeight.w100)
                ),
                style: TextStyle(fontWeight: FontWeight.bold,),
                keyboardType: TextInputType.visiblePassword,
                cursorWidth: 3.0,
                cursorColor: Colors.black,
              ),

            ),
            
            const SizedBox(height: spacePix-10), // space

            /*======= Sign up button ======*/
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) =>  BottomNavBar())
                );
              }, 
              label: Container(
                margin: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                child: const Text('Sign Up', style: TextStyle(fontSize: 15),),
              ),
              backgroundColor: const Color.fromARGB(255, 193, 2, 48),
              foregroundColor: Colors.white70,
              hoverColor: Colors.black,
            ),
            
            /* === SignIn button */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an Account?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w100,
                    color:  Color.fromARGB(255, 162, 170, 173)
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const MyLoginPage())
                    );
                  }, 
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      color:  Color.fromARGB(255, 0, 113, 205)
                    ),
                  ),
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
      )
      
    );
  }

}

