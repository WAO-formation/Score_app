import 'package:flutter/material.dart';

class AppColors {
  // --- WAO Brand Colors ---
  static const Color waoRed = Color(0xFFD30336);
  static const Color waoRedLight = Color(0xFFFF3366);
  static const Color waoRedDark = Color(0xFFA50229);
  static const Color waoNavy = Color(0xFF011B3B);
  static const Color waoYellow = Color(0xFFFFC600);


  // --- Theme Specific Constants ---

  // High emphasis for titles, medium for body, low for hints
  static Color textPrimary(bool isDark) => isDark ? const Color(0xFFE3E3E3) : waoNavy;
  static Color textSecondary(bool isDark) => isDark ? const Color(0xFFC4C7C5) : const Color(0xFF444746);
  static Color textTertiary(bool isDark) => isDark ? const Color(0xFF8E918F) : const Color(0xFF757575);

  // --- Button & Container Palette ---
  static Color buttonBackground(bool isDark) => waoRed;
  static Color buttonText(bool isDark) => Colors.white;

  // Custom Container Fill (for your GestureDetectors)
  static Color inputFill(bool isDark) => isDark ? const Color(0xFF1E1F20) : const Color(0xFFE8EDF2);

  // form fill colors
  static Color fieldBackground(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return inputFill(isDark).withOpacity(isDark ? 0.5 : 0.8);
  }


  // Dark Neutrals (Charcoal/Cool Tones)
  static const Color darkBackground = Color(0xFF131314);
  static const Color darkSurface = Color(0xFF1E1F20);
  static const Color darkTextPrimary = Color(0xFFE3E3E3);

  // Light Neutrals (Soft Off-White)
  static const Color lightBackground = Color(0xFFF0F4F9);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF1F1F1F);

  // --- ColorSchemes ---

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: waoRed,
    onPrimary: Colors.white,
    secondary: waoNavy,
    onSecondary: Colors.white,
    tertiary: waoYellow,
    background: lightBackground,
    onBackground: lightTextPrimary,
    surface: lightSurface,
    onSurface: lightTextPrimary,
    error: Color(0xFFAE022B),
    onError: Colors.white,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: waoRed,
    onPrimary: Colors.white,
    secondary: Color(0xFFD2E3FC),
    onSecondary: waoNavy,
    tertiary: waoYellow,
    background: darkBackground,
    onBackground: darkTextPrimary,
    surface: darkSurface,
    onSurface: darkTextPrimary,
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
  );
}