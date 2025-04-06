import 'package:flutter/material.dart';

import '../../shared/custom_buttons.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isFormValid = false;

  bool _passwordLengthValid = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      _updatePasswordValidation();
      _checkFormValidity();
    });
    _confirmPasswordController.addListener(() {
      _updatePasswordValidation();
      _checkFormValidity();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordValidation() {
    setState(() {
      _passwordLengthValid = _passwordController.text.length >= 6 &&
          RegExp(r'\d').hasMatch(_passwordController.text);
      _passwordsMatch = _confirmPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text == _passwordController.text;
    });
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = _validatePassword(_passwordController.text) == null &&
          _validateConfirmPassword(_confirmPasswordController.text) == null;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }


    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {

      print('Resetting password for: ${widget.email}');


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Resetting password...')),
      );


      Future.delayed(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful! Please login with your new password.')),
        );


        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.secondary,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(210.0),
        child: AppBar(
          backgroundColor: lightColorScheme.onPrimary,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: lightColorScheme.secondary),
            onPressed: () => Navigator.pop(context),
          ),

          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(0.0),
              bottomLeft: Radius.circular(50.0),
            ),
          ),

          flexibleSpace: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset\nPassword',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.secondary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Set your new password',
                    style: AppStyles.informationText.copyWith(
                        fontSize: 16.0,
                        color: lightColorScheme.secondary.withOpacity(0.7)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // Password Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      obscureText: !_passwordVisible,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: _passwordController.text.isNotEmpty
                                ? (_passwordLengthValid ? Colors.green : Colors.red)
                                : Colors.grey[700]!,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: _passwordController.text.isNotEmpty
                                ? (_passwordLengthValid ? Colors.green : Colors.red)
                                : Colors.white,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          _passwordLengthValid ? Icons.check_circle : Icons.info_outline,
                          size: 14,
                          color: _passwordLengthValid ? Colors.green : Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'At least 6 characters with one number',
                          style: TextStyle(
                            fontSize: 12,
                            color: _passwordLengthValid ? Colors.green : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_confirmPasswordVisible,
                  validator: _validateConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _confirmPasswordController.text.isNotEmpty
                            ? (_passwordsMatch ? Colors.green : Colors.red)
                            : Colors.grey[700]!,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _confirmPasswordController.text.isNotEmpty
                            ? (_passwordsMatch ? Colors.green : Colors.red)
                            : Colors.white,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _passwordsMatch ? Icons.check_circle : Icons.info_outline,
                      size: 14,
                      color: _passwordsMatch ? Colors.green : Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Confirm the password entered above',
                      style: TextStyle(
                        fontSize: 12,
                        color: _passwordsMatch ? Colors.green : Colors.grey[400],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Reset Password Button
                AuthenticationButtons(
                  label: 'Reset Password',
                  onTap:  _handleResetPassword,
                  colorText: lightColorScheme.secondary,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}