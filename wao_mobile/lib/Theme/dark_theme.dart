import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: Color(0xff202020),
      primary:  Color.fromARGB(255, 1, 30, 65),
      secondary: Color.fromARGB(255, 193, 2, 48),
      background:  Color.fromARGB(255, 193, 2, 48),
      error: Colors.red,
      onSurface: Colors.white,
      onError: Colors.black, onPrimary: Color(0xff6c757d), onSecondary: Color.fromARGB(255, 193, 2, 48),
    )
);
