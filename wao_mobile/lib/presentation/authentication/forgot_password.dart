
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wao_mobile/presentation/authentication/login.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import '../../shared/custom_buttons.dart';
import '../../shared/custom_text.dart';
import 'forgot_password_otp.dart';


class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() => _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState extends State<ForgotPasswordEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String? _emailError;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = _validateEmail(_emailController.text) == null;
    });
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

  void _handleSubmitEmail() {
    if (_formKey.currentState!.validate()) {
      // TODO: Send actual email verification request to server
      print('Sending password reset email to: ${_emailController.text}');


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sending verification email...')),
      );

      // Navigate to OTP verification screen
       Navigator.push(
         context,
        MaterialPageRoute(builder: (context) =>
            ForgotPasswordOtpScreen(email: _emailController.text)),
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
                    'Forgot\nPassword',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.secondary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter your email to reset',
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
                    hintText: 'Enter your registered email',
                    hintStyle: TextStyle(color: Colors.grey[600]),
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

                const SizedBox(height: 16),

                Text(
                  'We will send a verification code to this email address',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),

                const SizedBox(height: 60),

                // Continue Button
                AuthenticationButtons(
                  label: 'Send Verification Code ',
                  onTap: _handleSubmitEmail,
                  color: Colors.white,
                  colorText: lightColorScheme.secondary,
                ),

                const SizedBox(height: 24),


                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Remember your password?',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),

                      const SizedBox(width: 2.0),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginScreen()));
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
