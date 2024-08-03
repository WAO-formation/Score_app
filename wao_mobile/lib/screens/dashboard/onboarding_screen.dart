
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wao_mobile/screens/registration%20and%20login/login.dart';
import 'package:wao_mobile/screens/registration%20and%20login/signup.dart';

class onboardingSreen extends StatefulWidget {
  const onboardingSreen({
    super.key, 
  });
  

  @override
  State<onboardingSreen> createState() => _onboardingSreenState();
}

class _onboardingSreenState extends State<onboardingSreen> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
     backgroundColor: Colors.white,

        body: Center(
          child: Container(
              margin: const EdgeInsets.only( top: 150.0),
            child:  Column(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20.0),
                  child: const CircleAvatar(
                    radius: 70.0, // Image size
                    backgroundImage: AssetImage('assets/images/WAO_LOGO.jpg'),
                  ),
                ),
                SizedBox(height:20.0),
                const Text(
                 "WAO",
                  style: TextStyle(
                    fontSize: 50,
                    color:  Color.fromARGB(255, 193, 2, 48),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height:20.0),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric( horizontal: 15.0),
                    child: const Text(
                      "Welcome to the new era of digitised sports where technology meets skills, Wao! ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff011638),
                      ),
                    ),
                  ),
                ),
                
              ]
            )
          ),
        ),
      bottomNavigationBar: splashButtomNav(),
    );
  }

}


class splashButtomNav extends StatefulWidget{
  @override
  State<splashButtomNav> createState() => splashButtomNavState();

}

class splashButtomNavState extends State<splashButtomNav>{
  @override
  Widget build(BuildContext context) {

    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      height: 125.0,
     color: Colors.white,
      child: Container(
          child:   Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffffffff), // Background color of the button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Border radius
                      side: const BorderSide(
                        color:Color(0xffC10230), // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignupHomePage(title: '',))
                    );
                  },
                  child: const Text(
                    'Signup',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffC10230), // Text color
                    ),
                  ),
                ),

                // Register button
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginHomePage(title: '',))
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
              ]
          )
      ),
    );
  }

}
