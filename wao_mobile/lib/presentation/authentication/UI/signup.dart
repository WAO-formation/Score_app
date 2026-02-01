import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import '../../../shared/bottom_nav_bar.dart';
import '../../../shared/custom_buttons.dart';
import '../logic/RegistrationController.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationController _controller = RegistrationController();

  @override
  void initState() {
    super.initState();
    _controller.passwordController.addListener(_controller.updatePasswordValidation);
    _controller.confirmPasswordController.addListener(_controller.updatePasswordValidation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    bool success = await _controller.signUp(context);

    if (success && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: lightColorScheme.secondary,
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      _buildTextField(
                        controller: _controller.emailController,
                        label: 'Email',
                        validator: _controller.validateEmail,
                        enabled: !_controller.isLoading,
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                        controller: _controller.usernameController,
                        label: 'Username',
                        validator: _controller.validateUsername,
                        enabled: !_controller.isLoading,
                      ),
                      const SizedBox(height: 24),
                      _buildPasswordField(),
                      const SizedBox(height: 24),
                      _buildConfirmPasswordField(),
                      const SizedBox(height: 40),
                      AuthenticationButtons(
                        label: _controller.isLoading ? 'Creating Account...' : 'Register',
                        onTap: _controller.isLoading ? () {} : _onRegisterPressed,
                        color: Colors.white,
                        colorText: lightColorScheme.secondary,
                      ),
                      _buildLoginRedirect(),
                    ],
                  ),
                ),
              ),
              // Loading overlay — always in the tree, fades in/out via AnimatedOpacity.
              // IgnorePointer blocks taps when visible.
              AnimatedOpacity(
                opacity: _controller.isLoading ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !_controller.isLoading,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Creating your account...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- UI Sub-Widgets to keep build method clean ---

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(210.0),
      child: AppBar(
        backgroundColor: lightColorScheme.onPrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.0)),
        ),
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 20.0, bottom: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create\nAccount',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: lightColorScheme.secondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Lets Play WAO',
                style: TextStyle(
                  fontSize: 16.0,
                  color: lightColorScheme.secondary.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: enabled ? Colors.grey[400] : Colors.grey[600],
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Column(
      children: [
        TextFormField(
          controller: _controller.passwordController,
          obscureText: !_controller.passwordVisible,
          validator: _controller.validatePassword,
          enabled: !_controller.isLoading,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
              color: _controller.isLoading ? Colors.grey[600] : Colors.grey[400],
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _controller.passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: _controller.isLoading ? null : _controller.togglePasswordVisibility,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[800]!),
            ),
          ),
        ),
        _buildValidationHint(
          _controller.passwordLengthValid,
          'At least 6 characters with one number',
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      children: [
        TextFormField(
          controller: _controller.confirmPasswordController,
          obscureText: !_controller.confirmPasswordVisible,
          validator: _controller.validateConfirmPassword,
          enabled: !_controller.isLoading,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            labelStyle: TextStyle(
              color: _controller.isLoading ? Colors.grey[600] : Colors.grey[400],
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _controller.confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: _controller.isLoading ? null : _controller.toggleConfirmVisibility,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[800]!),
            ),
          ),
        ),
        _buildValidationHint(
          _controller.passwordsMatch,
          'Passwords must match',
        ),
      ],
    );
  }

  Widget _buildValidationHint(bool isValid, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.info_outline,
            size: 14,
            color: isValid ? Colors.green : Colors.grey[400],
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isValid ? Colors.green : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRedirect() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: _controller.isLoading
                ? null
                : () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                color: _controller.isLoading
                    ? Colors.grey[600]
                    : lightColorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}