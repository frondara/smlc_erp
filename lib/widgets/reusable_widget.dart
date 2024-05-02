import 'package:flutter/material.dart';

Widget logoWidget(String imageName) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(30.0), // Set the radius here
    child: Image.asset(
      imageName,
      fit: BoxFit.fitWidth,
      width: 150,
      height: 150,
    ),
  );
}

TextFormField reusableTextField(
  String labelText,
  IconData icon,
  bool isPasswordType,
  TextEditingController controller, {
  bool showPasswordToggle = false,
  required Function(String?) validator,
  VoidCallback? onTogglePasswordVisibility,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
      suffixIcon: showPasswordToggle
          ? IconButton(
              icon: Icon(
                isPasswordType ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: onTogglePasswordVisibility,
            )
          : null,
      errorStyle:
          TextStyle(color: Colors.white), // Set the error text color to white
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    validator: (value) => validator(value),
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        isLogin ? 'LOGIN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}
