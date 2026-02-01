import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> registerWithEmailAndPassword(
      String username,
      String email,
      String password,
      ) async {
    try {
      // creating the user in firebase auth
      UserCredential results = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = results.user;

      // if user creation was successful we save the extra information in firestore
      if (user != null) {
        try {
          // Timeout added — Firestore hangs forever on PERMISSION_DENIED
          // instead of throwing, so we force it to fail fast
          await _db.collection('users').doc(user.uid).set({
            'username': username,
            'email': email,
            'createdAt': DateTime.now(),
          }).timeout(const Duration(seconds: 5));
        } catch (firestoreErr) {
          // Auth succeeded — don't let a Firestore failure block the flow
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
          email: email, password: password);

      return userCredential;
    } catch (err) {
      print("Login Failed: $err");
      rethrow;
    }
  }
}