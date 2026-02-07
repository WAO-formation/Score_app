import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/user_model.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemePreference _themePreference = ThemePreference.system;

  ThemeMode get themeMode => _themeMode;
  ThemePreference get themePreference => _themePreference;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString('themePreference');

      if (savedTheme != null) {
        _themePreference = ThemePreference.values.firstWhere(
              (e) => e.name == savedTheme,
          orElse: () => ThemePreference.system,
        );
        _updateThemeMode();
      }
    } catch (e) {
      print('Error loading theme preference: $e');
    }
  }

  void _updateThemeMode() {
    switch (_themePreference) {
      case ThemePreference.light:
        _themeMode = ThemeMode.light;
        break;
      case ThemePreference.dark:
        _themeMode = ThemeMode.dark;
        break;
      case ThemePreference.system:
        _themeMode = ThemeMode.system;
        break;
    }
  }

  Future<void> setThemePreference(ThemePreference preference) async {
    _themePreference = preference;
    _updateThemeMode();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('themePreference', preference.name);
    } catch (e) {
      print('Error saving theme preference: $e');
    }

    notifyListeners();
  }

  // Legacy method for backward compatibility
  void toggleTheme(bool isOn) {
    setThemePreference(isOn ? ThemePreference.dark : ThemePreference.light);
  }
}