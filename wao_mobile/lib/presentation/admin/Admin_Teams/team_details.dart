import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/custom_text.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../../shared/custom_appbar.dart';

class TeamDetails extends StatelessWidget{
  const TeamDetails({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PrimaryCustomAppBar(
        title: 'Team Details',
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20.0,)
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child:  Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60.0),
              child: const Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/images/teams.jpg'),
                ),
              ),
            ),

            const SizedBox(height: 25.0,),

            Text(
              "Team A",
              style: AppStyles.primaryTitle.copyWith(color: lightColorScheme.secondary),
            ),

            const SizedBox(height: 25.0,),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(),
                  child:  Column(
                    children: [
                      Text(
                        "Team A",
                        style: AppStyles.primaryTitle.copyWith(color: lightColorScheme.secondary),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}