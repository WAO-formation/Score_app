import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/authentication/signup.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../shared/bottom_nav_bar.dart';
import '../../shared/custom_buttons.dart';
import '../../shared/custom_text.dart';
import '../../system_admin/presentation/admin_bottom_nav.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _passwordVisible = false;


  final _formKey = GlobalKey<FormState>();


  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  String? _emailError;
  String? _passwordError;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


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


  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }


  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      print('Logging in with: $email');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing login...')),
      );

      if(_rememberMe == true){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminBottomNavBar()),
        );
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.secondary,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(260.0),
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
                    'Welcome\nBack!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.secondary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'WAO - World As One',
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
                const SizedBox(height: 60),

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



                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_passwordVisible,
                  validator: _validatePassword,

                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),

                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
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

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordEmailScreen()));
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10.0),


                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Colors.white;
                            }
                            return Colors.transparent;
                          },
                        ),
                        checkColor: lightColorScheme.secondary,
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'I\'m a staff',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 40),


                AuthenticationButtons(
                  label: 'Login',
                  onTap: _handleLogin,
                  color: Colors.white,
                  colorText: lightColorScheme.secondary,
                ),

                const SizedBox(height: 30),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),

                      const SizedBox(width: 2.0),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                        },
                        child: Text(
                          'Register',
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