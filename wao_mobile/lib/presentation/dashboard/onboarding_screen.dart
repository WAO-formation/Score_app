import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';
import '../registration and login/login.dart';



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 1, 30, 65),
              Color.fromARGB(255, 34, 193, 195),
              Color.fromARGB(255, 253, 187, 45),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 150.0),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20.0),
                    child: const CircleAvatar(
                      radius: 70.0,
                      backgroundImage: AssetImage('assets/images/WAO_LOGO.jpg'),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    "WAO Sport",
                    style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 193, 2, 48),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Welcome to the new era of digitised sports where technology meets skills, Wao!",
                      textAlign: TextAlign.center,
                      style: AppStyles.secondaryTitle.copyWith(color: lightColorScheme.surface)
                    ),
                  ),

                  SizedBox(height: 150.0),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:lightColorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 18.0),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginHomePage(title: '')),
                      );
                    },
                    child:  Text(
                      'Get Started',
                      style: AppStyles.informationText.copyWith( fontSize: 15.0)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

