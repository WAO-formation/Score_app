import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wao_mobile/Model/user_model.dart';

import '../core/services/auth_service/auth_serivce.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserProfile? _userProfile;
  bool _isLoading = false;
  StreamSubscription<UserProfile?>? _profileSub;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _userProfile != null;

  UserProvider() {
    _initUser();
  }

  void _initUser() {
    _authService.authStateChanges.listen((User? user) {
      if (user != null) {
        loadUserProfile(user.uid);
      } else {
        _profileSub?.cancel();
        _profileSub = null;
        _userProfile = null;
        notifyListeners();
      }
    });
  }

  Future<void> loadUserProfile(String uid) async {
    // Cancel any existing subscription before creating a new one
    await _profileSub?.cancel();
    _profileSub = null;

    _isLoading = true;
    notifyListeners();

    _profileSub = _authService.getUserProfile(uid).listen(
      (profile) {
        _userProfile = profile;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        print('Error loading user profile: $e');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _profileSub?.cancel();
    super.dispose();
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_userProfile == null) return;

    try {
      await _authService.updateUserProfile(_userProfile!.uid, updates);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> toggleFavoriteTeam(String teamId) async {
    if (_userProfile == null) return;

    try {
      if (_userProfile!.favoriteTeamIds.contains(teamId)) {
        await _authService.removeFavoriteTeam(_userProfile!.uid, teamId);
      } else {
        await _authService.addFavoriteTeam(_userProfile!.uid, teamId);
      }
    } catch (e) {
      print('Error toggling favorite team: $e');
      rethrow;
    }
  }

  Future<void> toggleFavoriteMatch(String matchId) async {
    if (_userProfile == null) return;

    try {
      if (_userProfile!.favoriteMatchIds.contains(matchId)) {
        await _authService.removeFavoriteMatch(_userProfile!.uid, matchId);
      } else {
        await _authService.addFavoriteMatch(_userProfile!.uid, matchId);
      }
    } catch (e) {
      print('Error toggling favorite match: $e');
      rethrow;
    }
  }

  Future<void> updateThemePreference(ThemePreference preference) async {
    if (_userProfile == null) return;

    try {
      await _authService.updateThemePreference(_userProfile!.uid, preference);
    } catch (e) {
      print('Error updating theme: $e');
      rethrow;
    }
  }

  Future<void> updateNotifications({bool? push, bool? email}) async {
    if (_userProfile == null) return;

    try {
      await _authService.updateNotificationSettings(
        _userProfile!.uid,
        pushNotifications: push,
        emailNotifications: email,
      );
    } catch (e) {
      print('Error updating notifications: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
      _userProfile = null;
      notifyListeners();
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }
}