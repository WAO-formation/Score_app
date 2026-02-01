import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../../shared/bottom_nav_bar.dart';
import '../../../shared/custom_buttons.dart';
import '../../../shared/custom_text.dart';
import '../../../system_admin/presentation/admin_bottom_nav.dart';
import '../logic/LoginController.dart';
import 'forgot_password.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    bool success = await _controller.login(context);

    if (success && context.mounted) {
      if (_controller.rememberMe) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminBottomNavBar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
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
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        _buildEmailField(),
                        const SizedBox(height: 24),
                        _buildPasswordField(),
                        const SizedBox(height: 24),
                        _buildForgotPassword(),
                        const SizedBox(height: 10),
                        _buildRememberMe(),
                        const SizedBox(height: 40),
                        AuthenticationButtons(
                          label: _controller.isLoading ? 'Logging in...' : 'Login',
                          onTap: _controller.isLoading ? () {} : _onLoginPressed,
                          color: Colors.white,
                          colorText: lightColorScheme.secondary,
                        ),
                        const SizedBox(height: 30),
                        _buildRegisterRedirect(),
                      ],
                    ),
                  ),
                ),
              ),
              // Loading overlay
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
                            'Logging in...',
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

  // --- UI Sub-Widgets ---

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(260.0),
      child: AppBar(
        backgroundColor: lightColorScheme.onPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
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
                    color: lightColorScheme.secondary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _controller.emailController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: _controller.validateEmail,
      enabled: !_controller.isLoading,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          color: _controller.isLoading ? Colors.grey[600] : Colors.grey[400],
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
    return TextFormField(
      controller: _controller.passwordController,
      style: const TextStyle(color: Colors.white),
      obscureText: !_controller.passwordVisible,
      validator: _controller.validatePassword,
      enabled: !_controller.isLoading,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: _controller.isLoading ? Colors.grey[600] : Colors.grey[400],
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
        suffixIcon: IconButton(
          icon: Icon(
            _controller.passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: _controller.isLoading ? null : _controller.togglePasswordVisibility,
        ),
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _controller.isLoading
              ? null
              : () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordEmailScreen()),
          ),
          child: Text(
            'Forgot password?',
            style: TextStyle(
              color: _controller.isLoading ? Colors.grey[600] : Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _controller.rememberMe,
            onChanged: _controller.isLoading ? null : _controller.toggleRememberMe,
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
    );
  }

  Widget _buildRegisterRedirect() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Don\'t have an account?',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(width: 2.0),
          TextButton(
            onPressed: _controller.isLoading
                ? null
                : () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegistrationScreen()),
            ),
            child: Text(
              'Register',
              style: TextStyle(
                color: _controller.isLoading
                    ? Colors.grey[600]
                    : lightColorScheme.primary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}