import 'package:flutter/material.dart';

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFC10230),
  secondary: Color(0xFF011B3B) ,
  surface: Color(0xFFF1F2F3),
  background: Color(0xFFE2E5E6),
  error: Color(0xFFAE022B),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.white,
  tertiary: Color(0xFFE6B200),
);


const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF011731),
  secondary: Color(0xFF910224),
  surface: Color(0xFF121212),
  background: Color(0xFF1E1E1E),
  error: Color(0xFF74011D),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onBackground: Colors.white,
  onError: Colors.white,
  tertiary: Color(0xFF997700),
);


ThemeData waoDarkTheme = ThemeData(
  colorScheme: lightColorScheme,
  primaryColor: lightColorScheme.primary,
  scaffoldBackgroundColor: lightColorScheme.background,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: lightColorScheme.primary,
      foregroundColor: lightColorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 32, fontWeight: FontWeight.bold, color: lightColorScheme.tertiary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16, color: lightColorScheme.onBackground,
    ),
    labelLarge: TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: lightColorScheme.onPrimary,
    ),
  ),
);

