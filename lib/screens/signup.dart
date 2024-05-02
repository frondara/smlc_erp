import 'package:flutter/material.dart';
import 'package:smlc_erp/screens/signin.dart';
import 'package:smlc_erp/services/firebase_user_service.dart';
import 'package:smlc_erp/services/validations.dart';
import 'package:smlc_erp/widgets/error_message.dart';
import 'package:smlc_erp/widgets/reusable_widget.dart';
import 'package:smlc_erp/widgets/success_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  bool _showError = false;
  String _errorMessage = "";
  bool _isLoading = false;
  bool _isSuccessSignup = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 237, 66, 123),
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
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      reusableTextField("Enter Username", Icons.person_outline,
                          false, _userNameTextController,
                          validator: validateUsernameSignUp),
                      const SizedBox(height: 20),
                      reusableTextField("Enter Email", Icons.email, false,
                          _emailTextController,
                          validator: validateEmail),
                      const SizedBox(height: 20),
                      reusableTextField("Enter Password", Icons.lock_outline,
                          !_isPasswordVisible, _passwordTextController,
                          showPasswordToggle: true,
                          validator: validatePasswordSignUp,
                          onTogglePasswordVisibility: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      }),
                      const SizedBox(height: 20),
                      if (_isLoading)
                        CircularProgressIndicator()
                      else
                        signInSignUpButton(context, false, () async {
                          if (!_formKey.currentState!.validate()) {
                            return; // Exit early if validation fails
                          }
                          setState(() {
                            _showError = false;
                            _isLoading =
                                true; // Start loading only after validation passes
                          });
                          try {
                            final userCredentials =
                                await _firebaseService.createUser(
                                    _emailTextController.text,
                                    _passwordTextController.text);

                            await _firebaseService.addUserDetails(
                                userCredentials.user!.uid,
                                _userNameTextController.text,
                                _emailTextController.text);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignInScreen()));
                          } catch (e) {
                            _errorMessage = e.toString();
                            _showError = true;
                          } finally {
                            setState(() {
                              _isLoading =
                                  false; // Ensure loading is stopped whether success or failure
                            });
                          }
                        }),
                      if (_showError)
                        ErrorMessageWidget(
                          message: _errorMessage,
                          isVisible: true,
                        )
                      else if (!_showError && _isSuccessSignup)
                        SuccessMessageWidget(
                          message:
                              "Signup Successfully. Redirecting you to login page..",
                          isVisible: true,
                        ),
                      signInOption(),
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
