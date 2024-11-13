import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/custom_appbar.dart';
import 'package:wao_mobile/shared/custom_text_field.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../../shared/custom_buttons.dart';
import '../../../shared/custom_text.dart';

class NewTeams extends StatelessWidget{
  const NewTeams({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PrimaryCustomAppBar(
        title: 'New Team', 
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20.0,)
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Create Team',
                style: AppStyles.primaryTitle.copyWith(color: lightColorScheme.secondary),
              ),
            ),

            const SizedBox(height: 30.0,),

            SecondaryCustomTextField(
                label: 'Team Name',
                hintText: 'Team A',
                errorColor: lightColorScheme.error,
                borderColor: lightColorScheme.inverseSurface,
                keyboardType: TextInputType.text,
                obscureText: false,
                labelText: 'Team Name'
            ),

            SizedBox(height: 20.0,),

            SecondaryCustomTextField(
                label: 'Team Captain',
                hintText: 'John DOe',
                errorColor: lightColorScheme.error,
                borderColor: lightColorScheme.inverseSurface,
                keyboardType: TextInputType.text,
                obscureText: false,
                labelText: 'Team Captain'
            ),

            const SizedBox(height: 20.0,),

            SecondaryCustomTextField(
                label: 'Team Members',
                hintText: 'John DOe',
                errorColor: lightColorScheme.error,
                borderColor: lightColorScheme.inverseSurface,
                keyboardType: TextInputType.text,
                obscureText: false,
                labelText: 'Team Members',
              height: 80.0,
            ),


            const SizedBox(height: 40.0,),

            CustomButton(
              text: 'Register',
              width: 250.0,
              color: lightColorScheme.secondary,
              onPressed: () {  },
            )
          ],
        ),
      )
    );
  }
}