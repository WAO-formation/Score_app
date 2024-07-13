import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
      background: Color.fromARGB(255, 1, 30, 65),
    primary:  Color.fromARGB(255, 193, 2, 48),
    secondary:  Color.fromARGB(255, 1, 30, 65),
    surface: Color.fromARGB(255, 248, 249, 250),
    error: Colors.red,
    onSurface: Color.fromARGB(255, 1, 30, 65),
    onError: Colors.white, onPrimary: Color(0xffadb5bd), onSecondary: Colors.black,
  )
);

