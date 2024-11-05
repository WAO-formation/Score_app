import 'package:flutter/material.dart';
import 'package:wao_mobile/presentation/registration%20and%20login/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../shared/bottom_nav_bar.dart';
import '../../shared/custom_text.dart';
import '../../shared/theme_data.dart';

void main() {
  runApp(const MyLoginPage());
}

class MyLoginPage extends StatelessWidget {
  const MyLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WAO Score App',
      theme: ThemeData(
        fontFamily: 'Bronzier medium',
      ),
      home: const LoginHomePage(title: 'Log In Page'),
    );
  }
}

class LoginHomePage extends StatefulWidget {
  const LoginHomePage({super.key, required this.title});

  final String title;

  @override
  State<LoginHomePage> createState() => LoginHomePageState();
}

class LoginHomePageState extends State<LoginHomePage> {
  static const double spacePix = 20.0; // spacing pixel

  String email = "", password = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Login successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: lightColorScheme.secondary,
          content: const Text(
            'Login successful',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Login failed. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error: $e',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: lightColorScheme.secondary,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: Column(
              children: <Widget>[
                // LOGO Holder
                Container(
                  width: 110.0,
                  height: 110.0,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/images/WAO_LOGO.jpg"),
                      fit: BoxFit.cover,
                      scale: 0.146,
                      filterQuality: FilterQuality.high,
                    ),
                    color: lightColorScheme.surface,
                    borderRadius: const BorderRadius.all(Radius.circular(60)),
                  ),
                ),
                // Form heading
                Text(
                  'WAO',
                  style: AppStyles.primaryTitle
                      .copyWith(fontSize: 30.0, color: lightColorScheme.surface),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: screenHeight * 0.75,
                  padding:
                  const EdgeInsets.only(top: 70.0, left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    color: lightColorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Login',
                          style: AppStyles.secondaryTitle.copyWith(fontSize: 25.0),
                        ),
                        const SizedBox(height: 35.0),

                        // Email entry field
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter your email";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                color: lightColorScheme.secondary),
                            hintText: 'Enter your email',
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: const Icon(
                              Icons.mail,
                              color: Color(0xff333533),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: lightColorScheme.secondary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: lightColorScheme.secondary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: lightColorScheme.secondary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),

                        // Password entry field
                        TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter your Password";
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                color: lightColorScheme.secondary),
                            hintText: 'Enter your password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            suffixIcon: const Icon(
                              Icons.lock,
                              color: Color(0xff333533),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: lightColorScheme.secondary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: lightColorScheme.secondary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: lightColorScheme.secondary),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 25.0),

                        // Forgot Password functionality
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: AppStyles.informationText
                                    .copyWith(color: lightColorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: spacePix),

                        // Login button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightColorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: lightColorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60.0, vertical: 10.0),
                          ),
                          onPressed: login,
                          child: Text(
                            'Register',
                            style: AppStyles.informationText
                                .copyWith(fontSize: 15.0),
                          ),
                        ),
                        SizedBox(height: spacePix - 5),

                        // Sign Up button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an Account?',
                              style: AppStyles.informationText
                                  .copyWith(color: lightColorScheme.secondary),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupHomePage(
                                      title: '',
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  color: lightColorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
