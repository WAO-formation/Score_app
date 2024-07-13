import 'package:flutter/material.dart';

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary:  Color.fromARGB(255, 193, 2, 48),
  secondary:  Color.fromARGB(255, 1, 30, 65),
  surface: Color.fromARGB(255, 248, 249, 250),
  error: Colors.red,
  onSurface: Colors.black,
  onError: Colors.white, onPrimary: Colors.white, onSecondary: Colors.black,
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary:  Color.fromARGB(255, 1, 30, 65),
  secondary: Color.fromARGB(255, 193, 2, 48),
  surface:  Color.fromARGB(255, 10, 13, 11),
  error: Colors.red,
  onSurface: Colors.white,
  onError: Colors.black, onPrimary: Colors.black, onSecondary: Colors.white,
);