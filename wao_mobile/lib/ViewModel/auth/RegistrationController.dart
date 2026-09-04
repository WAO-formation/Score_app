import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/services/auth_service/auth_serivce.dart';
import '../../core/widgets/wao_toast.dart';

class RegistrationController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthService _auth = AuthService();

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  bool passwordLengthValid = false;
  bool passwordsMatch = false;
  bool isLoading = false;

  // Server-side errors attributed to the specific field they're about
  // (e.g. "this email is already registered"), cleared as soon as that
  // field is edited again — see LoginController for the same pattern.
  String? usernameError;
  String? emailError;
  String? passwordError;

  RegistrationController() {
    usernameController.addListener(_clearUsernameError);
    emailController.addListener(_clearEmailError);
    passwordController.addListener(_clearPasswordError);
  }

  void _clearUsernameError() {
    if (usernameError != null) {
      usernameError = null;
      notifyListeners();
    }
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

  void toggleConfirmVisibility() {
    confirmPasswordVisible = !confirmPasswordVisible;
    notifyListeners();
  }

  void updatePasswordValidation() {
    passwordLengthValid = passwordController.text.length >= 6 &&
        RegExp(r'\d').hasMatch(passwordController.text);

    passwordsMatch = confirmPasswordController.text.isNotEmpty &&
        confirmPasswordController.text == passwordController.text;

    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (emailError != null) return emailError;
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? validateUsername(String? value) {
    if (usernameError != null) return usernameError;
    if (value == null || value.isEmpty) return 'Username is required';
    if (value.length < 3) return 'Username must be at least 3 characters';
    return null;
  }

  String? validatePassword(String? value) {
    if (passwordError != null) return passwordError;
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'\d').hasMatch(value)) return 'Password must contain at least one number';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm Password is required';
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<bool> signUp(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      User? user = await _auth.registerWithEmailAndPassword(
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      isLoading = false;
      notifyListeners();

      if (user != null) {
        if (context.mounted) {
          WaoToast.success(context, 'Account created successfully!');
          clearFields();
        }
        return true;
      }

      return false;

    } on FirebaseAuthException catch (e) {
      isLoading = false;

      switch (e.code) {
        case 'email-already-in-use':
          emailError = 'This email is already registered';
          break;
        case 'invalid-email':
          emailError = 'Invalid email address';
          break;
        case 'weak-password':
          passwordError = 'Password is too weak';
          break;
        case 'operation-not-allowed':
          if (context.mounted) WaoToast.error(context, 'Email/password accounts are not enabled');
          break;
        case 'too-many-requests':
          if (context.mounted) WaoToast.error(context, 'Too many attempts. Try again later');
          break;
        default:
          if (context.mounted) WaoToast.error(context, 'Registration failed: ${e.message}');
      }

      notifyListeners();
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

  void clearFields() {
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    passwordLengthValid = false;
    passwordsMatch = false;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}