import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/authentication/login.dart';
import 'package:wao_mobile/shared/custom_text.dart';

import '../../shared/custom_buttons.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/officiate.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 450,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xFF011B3B).withOpacity(0.9),
                      const Color(0xFF011B3B).withOpacity(0.7),
                      const Color(0xFF011B3B).withOpacity(0.2),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
            ),


            Positioned(
              bottom: 100,
              left: 25,
              right: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'WAO Sport',
                      style: AppStyles.secondaryTitle.copyWith(color: Colors.white, fontSize: 28.0)
                  ),
                  Text(
                      'World As One',
                      style: AppStyles.secondaryTitle.copyWith(color: const Color(0xFFFFC600), fontSize: 28.0)
                  ),
                  const SizedBox(height: 20),
                  Text(
                      'Welcome to the new era of digitised sports where technology meets skills, WAO!',
                      style: AppStyles.informationText.copyWith(color: Colors.white)
                  ),
                ],
              ),
            ),


            Positioned(
              bottom: 30,
              left: 25,
              right: 25,
              child: AuthenticationButtons(
                label: 'Get Started',
                onTap: (){
                  Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                color: const Color(0xFFFFC600),
                colorText: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}