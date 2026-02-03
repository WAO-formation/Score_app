import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wao_mobile/View/user/teams/models/teams_models.dart';
import 'dart:convert';

import 'package:wao_mobile/View/user/teams/models/user_models.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isPlayer => _currentUser?.isPlayer ?? false;

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');

    if (userJson != null) {
      _currentUser = User.fromJson(json.decode(userJson));
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    // In a real app, you would validate credentials with your backend

    // Mock login for demonstration
    if (email.isNotEmpty && password.isNotEmpty) {
      // For demo: make the user a player if their email contains "player"
      final isPlayer = email.contains('player');

      Team? playerTeam;
      if (isPlayer) {
        playerTeam = Team(
          id: '1',
          name: 'Team A',
          logoUrl: 'assets/images/WAO_LOGO.jpg',
          description: 'Official WAO Team A with top players',
        );
      }

      _currentUser = User(
        id: '123',
        name: 'John Doe',
        email: email,
        profileImageUrl: 'assets/images/WAO_LOGO.jpg',
        playerTeam: playerTeam,
        isPlayer: isPlayer,
      );

      _isAuthenticated = true;

      // Save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(_currentUser!.toJson()));

      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');

    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? profileImageUrl,
  }) async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        email: email,
        profileImageUrl: profileImageUrl,
      );

      // Save updated user to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', json.encode(_currentUser!.toJson()));

      notifyListeners();
    }
  }
}