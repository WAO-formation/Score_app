import 'package:flutter/material.dart';



class WelcomeToWAO extends StatelessWidget{

  final String title;
  const WelcomeToWAO({super.key, required this.title});



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    const double spacePix = 10.0;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth*0.02, vertical: screenHeight*0.005),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration:  const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color:Color(0xff011E41),
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

               Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color:  Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
        )
    );
  }

}