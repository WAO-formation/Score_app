import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wao_mobile/core/widgets/wao_auth_scaffold.dart';
import 'package:wao_mobile/core/widgets/wao_toast.dart';

class ForgotPasswordEmailScreen extends StatefulWidget {
  const ForgotPasswordEmailScreen({super.key});

  @override
  State<ForgotPasswordEmailScreen> createState() =>
      _ForgotPasswordEmailScreenState();
}

class _ForgotPasswordEmailScreenState
    extends State<ForgotPasswordEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  bool _sent = false;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearEmailError);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _clearEmailError() {
    if (_emailError != null) setState(() => _emailError = null);
  }

  String? _validateEmail(String? value) {
    if (_emailError != null) return _emailError;
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (mounted) setState(() => _sent = true);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        if (e.code == 'invalid-email') {
          setState(() => _emailError = 'That email address looks invalid.');
          _formKey.currentState?.validate();
        } else {
          WaoToast.error(context, 'Could not send the reset email. Please try again.');
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WaoAuthScaffold(
      showBack: true,
      child: _sent ? _confirmation() : _form(),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WaoAuthHeading(
            'Forgot Password',
            subtitle:
                "Enter your account email and we'll send you a link to reset your password.",
          ),
          const SizedBox(height: 28),

          WaoAuthField(
            controller: _emailController,
            label: 'Email',
            hint: 'example@email.com',
            validator: _validateEmail,
            enabled: !_loading,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 28),

          WaoAuthButton(
            label: 'Send Reset Link',
            isLoading: _loading,
            onTap: _submit,
          ),
        ],
      ),
    );
  }

  Widget _confirmation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon badge
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: kAuthBrand.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 30,
              color: kAuthBrand,
            ),
          ),
        ),
        const SizedBox(height: 24),

        const WaoAuthHeading('Check your email'),
        const SizedBox(height: 10),

        Text.rich(
          TextSpan(
            text: 'We sent a reset link to  ',
            style: GoogleFonts.oswald(
              fontSize: 13,
              height: 1.6,
              color: kAuthSub,
            ),
            children: [
              TextSpan(
                text: _emailController.text.trim(),
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.w700,
                  color: kAuthInk,
                ),
              ),
              const TextSpan(text: '. Open it to set a new password.'),
            ],
          ),
        ),
        const SizedBox(height: 32),

        WaoAuthButton(
          label: 'Back to Sign In',
          onTap: () => Navigator.of(context).maybePop(),
        ),
      ],
    );
  }
}
