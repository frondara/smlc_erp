import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smlc_erp/screens/home.dart';
import 'package:smlc_erp/screens/signup.dart';
import 'package:smlc_erp/utils/color_utils.dart';
import 'package:smlc_erp/widgets/reusable_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool _isPasswordVisible =
      false; // Initialize as false to start with the password hidden
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 600), // Limit the max width
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center content vertically
                children: <Widget>[
                  logoWidget("assets/images/SMLC official logo.png"),
                  const SizedBox(height: 70),
                  reusableTextField("Enter Username", Icons.person_outline,
                      false, _emailTextController,
                      showPasswordToggle: false,
                      onTogglePasswordVisibility: () {}),
                  const SizedBox(height: 30),
                  reusableTextField("Enter Password", Icons.lock_outline,
                      !_isPasswordVisible, _passwordTextController,
                      showPasswordToggle: true, onTogglePasswordVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  }),
                  const SizedBox(height: 30),
                  signInSignUpButton(context, true, () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    }).onError((error, stackTrace) {
                      print("Error login: ${error.toString()}");
                    });
                  }),
                  signUpOption(),
                ],
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
}
