import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> registerWithEmailAndPassword(
      String username,
      String email,
      String password,
      ) async {
    try {
      UserCredential results = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = results.user;

      if (user != null) {
        try {
          final userProfile = UserProfile(
            uid: user.uid,
            username: username,
            email: email,
            createdAt: DateTime.now(),
          );

          await _db
              .collection('users')
              .doc(user.uid)
              .set(userProfile.toFirestore())
              .timeout(const Duration(seconds: 5));
        } catch (firestoreErr) {
          print('Firestore write failed: $firestoreErr');
        }
      }

      return user;
    } catch (err) {
      print("Registration Failed: $err");
      rethrow;
    }
  }

  Future<UserCredential?> loginWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (err) {
      print("Login Failed: $err");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  // Get user profile
  Stream<UserProfile?> getUserProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    });
  }

  Future<UserProfile?> getUserProfileOnce(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserProfile.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _db.collection('users').doc(uid).update(updates);
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Favorite management
  Future<void> addFavoriteTeam(String uid, String teamId) async {
    try {
      await _db.collection('users').doc(uid).update({
        'favoriteTeamIds': FieldValue.arrayUnion([teamId]),
        'totalTeams': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding favorite team: $e');
      rethrow;
    }
  }

  Future<void> removeFavoriteTeam(String uid, String teamId) async {
    try {
      await _db.collection('users').doc(uid).update({
        'favoriteTeamIds': FieldValue.arrayRemove([teamId]),
        'totalTeams': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error removing favorite team: $e');
      rethrow;
    }
  }

  Future<void> addFavoriteMatch(String uid, String matchId) async {
    try {
      await _db.collection('users').doc(uid).update({
        'favoriteMatchIds': FieldValue.arrayUnion([matchId]),
        'totalMatches': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding favorite match: $e');
      rethrow;
    }
  }

  Future<void> removeFavoriteMatch(String uid, String matchId) async {
    try {
      await _db.collection('users').doc(uid).update({
        'favoriteMatchIds': FieldValue.arrayRemove([matchId]),
        'totalMatches': FieldValue.increment(-1),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error removing favorite match: $e');
      rethrow;
    }
  }

  // Preferences
  Future<void> updateThemePreference(String uid, ThemePreference preference) async {
    try {
      await _db.collection('users').doc(uid).update({
        'themePreference': preference.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating theme preference: $e');
      rethrow;
    }
  }

  Future<void> updateNotificationSettings(
      String uid, {
        bool? pushNotifications,
        bool? emailNotifications,
      }) async {
    try {
      Map<String, dynamic> updates = {'updatedAt': FieldValue.serverTimestamp()};

      if (pushNotifications != null) {
        updates['notificationsEnabled'] = pushNotifications;
      }
      if (emailNotifications != null) {
        updates['emailNotifications'] = emailNotifications;
      }

      await _db.collection('users').doc(uid).update(updates);
    } catch (e) {
      print('Error updating notification settings: $e');
      rethrow;
    }
  }
}