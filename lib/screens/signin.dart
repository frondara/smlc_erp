import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smlc_erp/screens/home.dart';
import 'package:smlc_erp/screens/signup.dart';
import 'package:smlc_erp/services/validations.dart';
import 'package:smlc_erp/widgets/error_message.dart';
import 'package:smlc_erp/widgets/reusable_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>(); // Add a key for the form
  bool _showError = false;
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    logoWidget("assets/images/SMLC official logo.png"),
                    const SizedBox(height: 70),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: reusableTextField("Enter Email",
                          Icons.person_outline, false, _emailTextController,
                          validator: validateEmail),
                    ),
                    const SizedBox(height: 30),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: reusableTextField(
                          "Enter Password",
                          Icons.lock_outline,
                          !_isPasswordVisible,
                          _passwordTextController,
                          showPasswordToggle: true,
                          validator: validatePassword,
                          onTogglePasswordVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      }),
                    ),
                    const SizedBox(height: 10),
                    forgotPasswordOption(),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: signInSignUpButton(context, true, () {
                        if (_formKey.currentState!.validate()) {
                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text)
                              .then((value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          }).onError((error, stackTrace) {
                            print("Error login: ${error.toString()}");
                            setState(() {
                              _showError = true;
                            });
                          });
                        }
                      }),
                    ),
                    ErrorMessageWidget(
                      message: "Incorrect Username or Password",
                      isVisible: _showError,
                    ),
                    signUpOption(),
                  ],
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
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
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
            //Navigator.push(context,
            //    MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
