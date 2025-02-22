import 'package:flutter/material.dart';

import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';

class CustomInputField extends StatelessWidget{
  const CustomInputField({super.key, required this.labelText, required this.hintText, required this.obscureText, this.suffixIcon, this.controller});

  final String labelText;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;


  @override
  Widget build(BuildContext context) {

    return  TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:  AppStyles.informationText.copyWith(color: lightColorScheme.secondary),
        hintText: hintText,
        hintStyle:  AppStyles.informationText.copyWith(color: Colors.grey),
        suffixIcon: suffixIcon != null
            ? IconTheme(
          data: IconThemeData(color: lightColorScheme.secondary),
          child: suffixIcon!, // Pass the custom icon
        )
            : null,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: lightColorScheme.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: lightColorScheme.secondary,),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: lightColorScheme.secondary),
        ),
      ),
      style:  TextStyle(
        color: lightColorScheme.secondary,
      ),
      obscureText: obscureText,
    );
  }

}