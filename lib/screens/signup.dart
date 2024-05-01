import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smlc_erp/screens/home.dart';
import 'package:smlc_erp/screens/signin.dart';
import 'package:smlc_erp/utils/color_utils.dart';
import 'package:smlc_erp/widgets/reusable_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  bool _isPasswordVisible =
      false; // Initialize as false to start with the password hidden

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ),
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
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    reusableTextField("Enter Username", Icons.person_outline,
                        false, _userNameTextController,
                        showPasswordToggle: false,
                        onTogglePasswordVisibility: () {}),
                    const SizedBox(height: 20),
                    reusableTextField(
                        "Enter Email", Icons.email, false, _emailTextController,
                        showPasswordToggle: false,
                        onTogglePasswordVisibility: () {}),
                    const SizedBox(height: 20),
                    reusableTextField("Enter Password", Icons.lock_outline,
                        !_isPasswordVisible, _passwordTextController,
                        showPasswordToggle: true,
                        onTogglePasswordVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    }),
                    const SizedBox(height: 20),
                    signInSignUpButton(context, false, () {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()));
                      }).onError((error, stackTrace) {
                        print("Error: ${error.toString()}");
                      });
                    }),
                    signInOption(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignInScreen()));
          },
          child: const Text(
            "Login",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
