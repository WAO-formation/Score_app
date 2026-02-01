import 'package:flutter/material.dart';
import 'dart:io';
import '../../../shared/custom_buttons.dart';
import '../../../shared/theme_data.dart';
import '../../authentication/UI/signup.dart';



class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _displayNameController = TextEditingController(text: "John Doe");
  final _usernameController = TextEditingController(text: "johndoe");
  final _emailController = TextEditingController(text: "john.doe@example.com");
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  /// Form validation errors
  String? _displayNameError;
  String? _usernameError;
  String? _emailError;
  String? _oldPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;


  bool _isFormModified = false;
  bool _isLoading = false;
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;


  bool _passwordLengthValid = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();

    /// listeners to check form validity when inputs change
    _displayNameController.addListener(_checkFormModified);
    _usernameController.addListener(_checkFormModified);
    _emailController.addListener(_checkFormModified);
    _oldPasswordController.addListener(_checkFormModified);
    _newPasswordController.addListener(() {
      _updatePasswordValidation();
      _checkFormModified();
    });
    _confirmPasswordController.addListener(() {
      _updatePasswordValidation();
      _checkFormModified();
    });
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Update password validation states
  void _updatePasswordValidation() {
    setState(() {
      _passwordLengthValid = _newPasswordController.text.isEmpty ||
          (_newPasswordController.text.length >= 6 &&
              RegExp(r'\d').hasMatch(_newPasswordController.text));

      _passwordsMatch = _confirmPasswordController.text.isEmpty ||
          (_confirmPasswordController.text == _newPasswordController.text);
    });
  }

  void _checkFormModified() {
    setState(() {
      _isFormModified = true;
    });
  }

  /// Optional validate display name - returns null if empty or valid
  String? _validateDisplayName(String? value) {
    /// All fields are optional, just return null if empty
    if (value == null || value.isEmpty) {
      return null;
    }
    return null;
  }

  /// Optional validate username - returns null if empty or valid
  String? _validateUsername(String? value) {

    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  /// Optional validate email format - returns null if empty or valid
  String? _validateEmail(String? value) {

    if (value == null || value.isEmpty) {
      return null;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validate password only if changing password
  String? _validateOldPassword(String? value) {

    if (_newPasswordController.text.isNotEmpty || _confirmPasswordController.text.isNotEmpty) {
      if (value == null || value.isEmpty) {
        return 'Current password is required to change password';
      }
    }
    return null;
  }


  /// Validate new password only if old password was provided
  String? _validateNewPassword(String? value) {
    if (_oldPasswordController.text.isNotEmpty) {

      /// Only validate if trying to change password
      if (value == null || value.isEmpty) {
        return 'New password is required';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters';
      }
      if (!RegExp(r'\d').hasMatch(value)) {
        return 'Password must contain at least one number';
      }
      if (value == _oldPasswordController.text) {
        return 'New password must be different from old password';
      }
    } else if (value != null && value.isNotEmpty) {
      return 'Please enter your current password first';
    }
    return null;
  }

  /// Validate confirm password only if new password was provided
  String? _validateConfirmPassword(String? value) {
    if (_newPasswordController.text.isNotEmpty) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your new password';
      }
      if (value != _newPasswordController.text) {
        return 'Passwords do not match';
      }
    } else if (value != null && value.isNotEmpty) {
      return 'Please enter your new password first';
    }
    return null;
  }


  void _clearAndFocusField(TextEditingController controller, FocusNode focusNode) {
    controller.clear();
    FocusScope.of(context).requestFocus(focusNode);
  }


  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });


      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      setState(() {
        _isFormModified = false;
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      });
    }
  }

  /// Show delete account confirmation
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: lightColorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted')),
                );
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const RegistrationScreen()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final displayNameFocus = FocusNode();
    final usernameFocus = FocusNode();
    final emailFocus = FocusNode();
    final oldPasswordFocus = FocusNode();
    final newPasswordFocus = FocusNode();
    final confirmPasswordFocus = FocusNode();

    return Scaffold(
      backgroundColor: lightColorScheme.secondary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: AppBar(
          backgroundColor: lightColorScheme.onPrimary,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: lightColorScheme.secondary,
            ),
            onPressed: () => Navigator.of(context).pop(),
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
                    'Edit\nProfile',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.secondary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Update your WAO profile',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: lightColorScheme.secondary.withOpacity(0.7),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),


                TextFormField(
                  controller: _displayNameController,
                  focusNode: displayNameFocus,
                  style: const TextStyle(color: Colors.white),
                  validator: _validateDisplayName,
                  decoration: InputDecoration(
                    labelText: 'Display Name (Optional)',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorText: _displayNameError,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () => _clearAndFocusField(_displayNameController, displayNameFocus),
                    ),
                  ),
                ),

                const SizedBox(height: 24),


                TextFormField(
                  controller: _usernameController,
                  focusNode: usernameFocus,
                  style: const TextStyle(color: Colors.white),
                  validator: _validateUsername,
                  decoration: InputDecoration(
                    labelText: 'Username (Optional)',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorText: _usernameError,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () => _clearAndFocusField(_usernameController, usernameFocus),
                    ),
                  ),
                ),

                const SizedBox(height: 24),


                TextFormField(
                  controller: _emailController,
                  focusNode: emailFocus,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    labelText: 'Email (Optional)',
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorText: _emailError,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey),
                      onPressed: () => _clearAndFocusField(_emailController, emailFocus),
                    ),
                  ),
                ),

                const SizedBox(height: 24),


                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Change Password (Optional)',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 8),


                TextFormField(
                  controller: _oldPasswordController,
                  focusNode: oldPasswordFocus,
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_oldPasswordVisible,
                  validator: _validateOldPassword,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    hintText: 'Enter your current password',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[700]!),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorText: _oldPasswordError,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _oldPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _oldPasswordVisible = !_oldPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),


                TextFormField(
                  controller: _newPasswordController,
                  focusNode: newPasswordFocus,
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_newPasswordVisible,
                  validator: _validateNewPassword,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    hintText: 'Enter a new password with at least 6 characters and one number',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                    labelStyle: TextStyle(color: Colors.grey[400]),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _newPasswordController.text.isNotEmpty
                            ? (_passwordLengthValid ? Colors.green : Colors.red)
                            : Colors.grey[700]!,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _newPasswordController.text.isNotEmpty
                            ? (_passwordLengthValid ? Colors.green : Colors.red)
                            : Colors.white,
                      ),
                    ),
                    errorText: _newPasswordError,
                    errorStyle: const TextStyle(color: Colors.redAccent),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _newPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _newPasswordVisible = !_newPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      _passwordLengthValid || _newPasswordController.text.isEmpty
                          ? Icons.check_circle
                          : Icons.info_outline,
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

                const SizedBox(height: 24),


                TextFormField(
                  controller: _confirmPasswordController,
                  focusNode: confirmPasswordFocus,
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_confirmPasswordVisible,
                  validator: _validateConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    hintText: 'Re-enter your new password to confirm',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
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
                      _passwordsMatch || _confirmPasswordController.text.isEmpty
                          ? Icons.check_circle
                          : Icons.info_outline,
                      size: 14,
                      color: _passwordsMatch ? Colors.green : Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Passwords must match',
                      style: TextStyle(
                        fontSize: 12,
                        color: _passwordsMatch ? Colors.green : Colors.grey[400],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),


                _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : AuthenticationButtons(
                  label: 'Save Changes',
                  onTap: (){_isFormModified ? _saveChanges : null;},
                  color: Colors.white,
                  colorText: lightColorScheme.secondary,
                ),

                const SizedBox(height: 30),


                GestureDetector(
                  onTap: _showDeleteAccountDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}