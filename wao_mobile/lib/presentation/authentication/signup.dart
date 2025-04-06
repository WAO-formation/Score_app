import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/authentication/login.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../shared/bottom_nav_bar.dart';
import '../../shared/custom_buttons.dart';
import '../../shared/custom_text.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _agreeToTerms = false;
  bool _isFormValid = false;

  // Create a form key to validate the form
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form validation errors
  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;

  // Password requirements state
  bool _passwordLengthValid = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to check form validity when inputs change
    _emailController.addListener(_checkFormValidity);
    _usernameController.addListener(_checkFormValidity);
    _passwordController.addListener(() {
      _updatePasswordValidation();
      _checkFormValidity();
    });
    _confirmPasswordController.addListener(() {
      _updatePasswordValidation();
      _checkFormValidity();
    });
  }

  // Dispose controllers when the widget is disposed
  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Update password validation states
  void _updatePasswordValidation() {
    setState(() {
      _passwordLengthValid = _passwordController.text.length >= 6 &&
          RegExp(r'\d').hasMatch(_passwordController.text);
      _passwordsMatch = _confirmPasswordController.text.isNotEmpty &&
          _confirmPasswordController.text == _passwordController.text;
    });
  }

  // Check if all form fields are valid
  void _checkFormValidity() {
    setState(() {
      _isFormValid = _validateEmail(_emailController.text) == null &&
          _validateUsername(_usernameController.text) == null &&
          _validatePassword(_passwordController.text) == null &&
          _validateConfirmPassword(_confirmPasswordController.text) == null &&
          _agreeToTerms;
    });
  }

  // Validate email format
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // Validate username
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    return null;
  }

  // Validate password strength
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    // Check for at least one number
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // Validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }


  void _handleRegistration() {
    // Validate the form
    if (_formKey.currentState!.validate()) {

      final email = _emailController.text;
      final username = _usernameController.text;


      print('Registering with: $email, username: $username');



      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing registration...')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
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
          automaticallyImplyLeading: false,

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
                    'Create\nAccount',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.secondary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Lets Play WAO',
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

                // Email Field
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorText: _emailError,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                  ),
                ),

                const SizedBox(height: 24),

                // Username Field
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white),
                  validator: _validateUsername,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorText: _usernameError,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                  ),
                ),

                const SizedBox(height: 24),

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
                        labelText: 'Password',
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

                        errorText: _passwordError,
                        errorStyle: const TextStyle(color: Colors.redAccent),
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


                TextFormField(
                  controller: _confirmPasswordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_confirmPasswordVisible,
                  validator: _validateConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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

                    errorText: _confirmPasswordError,
                    errorStyle: const TextStyle(color: Colors.redAccent),
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
                      'Confirm Password Entered above',
                      style: TextStyle(
                        fontSize: 12,
                        color: _passwordsMatch ? Colors.green : Colors.grey[400],
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 40),


                AuthenticationButtons(
                  label: 'Register',
                  onTap: _handleRegistration,
                  color:  Colors.white,
                  colorText: lightColorScheme.secondary,
                ),

                const SizedBox(height: 30),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),

                      const SizedBox(width: 2.0),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, 
                          MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: lightColorScheme.primary, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}