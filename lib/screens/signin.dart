import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smlc_erp/screens/home.dart';
import 'package:smlc_erp/screens/signup.dart';
import 'package:smlc_erp/services/validations.dart';
import 'package:smlc_erp/widgets/error_message.dart';
import 'package:smlc_erp/widgets/reusable_widget.dart';
import 'package:smlc_erp/widgets/success_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _showError = false;
  bool _isLoading = false; // Track loading state
  String _message = ""; // To handle success or error messages
  bool isSuccessLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 237, 66, 123),
          Color.fromARGB(255, 162, 50, 182),
          Color.fromARGB(251, 60, 215, 207)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      logoWidget("assets/images/SMLC official logo.png"),
                      const SizedBox(height: 70),
                      reusableTextField("Enter Email", Icons.person_outline,
                          false, _emailTextController,
                          validator: validateEmail),
                      const SizedBox(height: 30),
                      reusableTextField("Enter Password", Icons.lock_outline,
                          !_isPasswordVisible, _passwordTextController,
                          showPasswordToggle: true, validator: validatePassword,
                          onTogglePasswordVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      }),
                      const SizedBox(height: 10),
                      forgotPasswordOption(),
                      const SizedBox(height: 20),
                      if (_isLoading)
                        CircularProgressIndicator()
                      else
                        signInSignUpButton(context, true, () async {
                          setState(() {
                            _showError = false;
                            _isLoading = true;
                            _message = ""; // Clear any previous messages
                          });
                          if (_formKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _emailTextController.text,
                                      password: _passwordTextController.text);
                              setState(() {
                                _message =
                                    "Login Successfully. Redirecting you to homepage..";
                                isSuccessLogin = true;
                                _showError = false;
                              });
                              await Future.delayed(const Duration(
                                  seconds: 2)); // Wait for 2 seconds
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            } catch (e) {
                              setState(() {
                                _message = "Incorrect Username or Password";
                                _showError = true;
                              });
                            }
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        }),
                      if (_showError)
                        ErrorMessageWidget(
                          message: _message,
                          isVisible: true,
                        )
                      else if (!_showError &&
                          _message.isNotEmpty &&
                          isSuccessLogin)
                        SuccessMessageWidget(
                          message: _message,
                          isVisible: true,
                        ),
                      signUpOption(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text("Sign Up",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Row forgotPasswordOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            // Here, you can add functionality to reset the password
          },
          child: const Text("Forgot Password?",
              style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}
