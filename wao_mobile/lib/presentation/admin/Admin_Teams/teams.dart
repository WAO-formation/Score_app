import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/admin/Admin_Teams/team_details.dart';
import 'package:wao_mobile/shared/custom_appbar.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../../shared/custom_buttons.dart';
import '../../../shared/custom_text.dart';
import 'new_teams.dart';


class AdminTeams extends StatelessWidget{
  const AdminTeams({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar:  CustomAppBar(title: "Teams"),

        body: Container(

          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: const Column(
            children: <Widget>[

              TeamsContainer(),

              SizedBox(height: 20.0,),

              TeamsContainer()
            ],
          ),
        ),
      bottomNavigationBar: const AdminTeamsButtomNav(),
    );
  }

}


// this part is a container for the teams

class TeamsContainer extends StatelessWidget{
  const TeamsContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return  Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      decoration: BoxDecoration(
          color:  Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/teams.jpg'),
              ),
              const SizedBox(width: 20.0,),

              Text(
                "Team A",
                style: AppStyles.secondaryTitle,
              )
            ],
          ),

          CustomButton(
            text: 'View',
            width: 100.0,
            color: lightColorScheme.primary,
            onPressed: () { 
              Navigator.push(
                  context,
                MaterialPageRoute(builder: (context) => const TeamDetails())
              );
            },
          )
        ],
      ),
    );
  }

}

class AdminTeamsButtomNav extends StatefulWidget{
  const AdminTeamsButtomNav({super.key});

  @override
  State<AdminTeamsButtomNav> createState() => AdminTeamsButtomNavState();

}

class AdminTeamsButtomNavState extends State<AdminTeamsButtomNav>{
  @override
  Widget build(BuildContext context) {

    return BottomAppBar(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      height: 100.0,
      color: Colors.white,
      child: Center(
        child: CustomButton(
            text: "Create Team",
            width: 250.0,
            color: lightColorScheme.secondary,
            onPressed: (){
              Navigator.push(
                  context,
                 MaterialPageRoute(builder: (builder) => const NewTeams())
              );
            }
        ),

      ),
    );
  }

}
