import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/services/auth_service/auth_serivce.dart';
import '../../core/services/auth_service/session_service.dart';
import '../../core/widgets/wao_toast.dart';


class LoginController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService _auth = AuthService();

  bool passwordVisible = false;
  bool rememberMe = false;
  bool isLoading = false;

  // Server-side errors (e.g. "no account with this email", "wrong password")
  // attributed to the specific field they're about, rather than a generic
  // toast — cleared the moment the person edits that field again.
  String? emailError;
  String? passwordError;

  LoginController() {
    emailController.addListener(_clearEmailError);
    passwordController.addListener(_clearPasswordError);
  }

  void _clearEmailError() {
    if (emailError != null) {
      emailError = null;
      notifyListeners();
    }
  }

  void _clearPasswordError() {
    if (passwordError != null) {
      passwordError = null;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }

  void toggleRememberMe(bool? value) {
    rememberMe = value ?? false;
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (emailError != null) return emailError;
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (passwordError != null) return passwordError;
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  /// Returns true on success, false on failure.
  /// The caller (screen) decides where to navigate based on [rememberMe].
  Future<bool> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      UserCredential? userCredential = await _auth.loginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      isLoading = false;
      notifyListeners();

      if (userCredential?.user != null) {
        await SessionService.recordLogin(rememberMe: rememberMe);
        if (context.mounted) {
          WaoToast.success(context, 'Login successful!');
        }
        return true;
      }

      return false;

    } on FirebaseAuthException catch (e) {
      isLoading = false;

      // Errors about a specific field are attached to that field (shown
      // inline, right where the mistake is) instead of a generic toast.
      // Everything else — account-disabled, rate-limited, unknown — isn't
      // about any one input, so it stays a toast.
      switch (e.code) {
        case 'user-not-found':
          emailError = 'No account found with this email';
          break;
        case 'wrong-password':
          passwordError = 'Incorrect password';
          break;
        case 'invalid-credential':
        case 'invalid-login-credentials':
          // Modern Firebase Auth merges "wrong password" and "no such user"
          // into one code so a bad actor can't tell which part was wrong —
          // same reasoning applies here, so flag the password field without
          // confirming whether the email exists.
          passwordError = 'Incorrect email or password';
          break;
        case 'invalid-email':
          emailError = 'Invalid email address';
          break;
        case 'user-disabled':
          if (context.mounted) WaoToast.error(context, 'This account has been disabled');
          break;
        case 'too-many-requests':
          if (context.mounted) WaoToast.error(context, 'Too many failed attempts. Try again later');
          break;
        default:
          if (context.mounted) WaoToast.error(context, 'Login failed: ${e.message}');
      }

      notifyListeners();
      // Field errors are only rendered on the next validation pass — force
      // one now so they show up immediately instead of waiting for the next
      // keystroke.
      formKey.currentState?.validate();
      return false;

    } catch (e) {
      isLoading = false;
      notifyListeners();

      if (context.mounted) {
        WaoToast.error(context, 'An error occurred: ${e.toString()}');
      }

      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}