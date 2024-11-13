import 'package:flutter/material.dart';
import '../../provider/Models/all-teams-class.dart';
import '../../shared/Welcome_box.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/theme_data.dart';

class allTeams extends StatefulWidget{
  const allTeams({super.key});

  @override
  State<allTeams> createState() => allTeamsState();

}

class allTeamsState extends State<allTeams>{
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: lightColorScheme.surface,
        appBar:  CustomAppBar(
          title: 'All Teams',
          leading: IconButton(
              icon:  Icon(
                  Icons.arrow_back_rounded,
                  color: lightColorScheme.surface
              ),

              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ),

        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0, bottom: 30.0),
              child: Column(
                children: [

                  const WelcomeToWAO(title: ' All WAO Team ',),
                  const SizedBox(height: 20.0),


                  Container(
                      child: const AllTeamsList()
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

}

