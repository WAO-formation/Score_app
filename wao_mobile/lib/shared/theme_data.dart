import 'package:flutter/material.dart';

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFC10230),
  secondary: Color(0xFF011E41),
  surface: Color(0xFF121212),
  background: Color(0xFF1E1E1E),
  error: Color(0xFFE53935),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onBackground: Colors.white,
  onError: Colors.white,
  tertiary: Color(0xFFFFC600),
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

