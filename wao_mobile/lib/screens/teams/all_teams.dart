import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wao_mobile/screens/teams/teams_dashboard.dart';

import 'package:wao_mobile/Theme/theme_data.dart';
import 'package:wao_mobile/custom_widgets/Welcome_box.dart';
import 'package:wao_mobile/custom_widgets/custom_appbar.dart';

import 'Models/all-teams-class.dart';

class allTeams extends StatefulWidget{
  @override
  State<allTeams> createState() => allTeamsState();

}

class allTeamsState extends State<allTeams>{
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: Colors.white,
        appBar:  CustomAppBar(
          title: 'All Teams',
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
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

