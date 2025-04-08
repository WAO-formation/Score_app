import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wao_mobile/presentation/authentication/reset_password.dart';

import '../../shared/custom_buttons.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpScreen({super.key, required this.email});

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
      4, (_) => TextEditingController()
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    for (var controller in _otpControllers) {
      controller.addListener(_checkFormValidity);
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _checkFormValidity() {
    setState(() {
      _isFormValid = !_otpControllers.any((controller) => controller.text.isEmpty);
    });
  }

  void _handleSubmitOTP() {
    if (_formKey.currentState!.validate()) {
      final otp = _otpControllers.map((controller) => controller.text).join();

      // TODO: Send actual OTP verification request to server
      print('Verifying OTP: $otp for email: ${widget.email}');

      // Show a loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifying code...')),
      );

      // Navigate to Reset Password screen
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen(email: widget.email)),
      );
    }
  }

  void _handleResendCode() {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Resending code to ${widget.email}')),
    );
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
                    'Verify\nCode',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.secondary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Enter the 4-digit code sent to you',
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

                // Email display
                Text(
                  'Code sent to:',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.email,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                        (index) => SizedBox(
                      width: 70,
                      height: 80,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: Colors.grey[800]!.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          _checkFormValidity();
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Verify Button
                AuthenticationButtons(
                  label: 'Verify Code',
                  onTap:  _handleSubmitOTP,
                  color:  Colors.white ,
                  colorText: lightColorScheme.secondary,
                ),

                const SizedBox(height: 24),

                // Resend Code Option
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Didn\'t receive code?',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),

                      const SizedBox(width: 2.0),

                      TextButton(
                        onPressed: _handleResendCode,
                        child: Text(
                          'Resend',
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