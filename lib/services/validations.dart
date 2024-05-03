import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smlc_erp/services/firebase_user_service.dart';

final FirebaseService _firebaseService = FirebaseService();

String? validateEmail(String? value) {
  if (value == null || value.isEmpty || value.trim() == "") {
    return 'Please enter your username or email';
  } else if (!value.contains('@')) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validateEmailLogin(String? value) {
  if (value == null || value.isEmpty || value.trim() == "") {
    return 'Please enter your username or email';
  } else if (!value.contains('@')) {
    //return 'Please enter a valid email';
  }
  return null;
}

String? validatePasswordLogin(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  return null; // If all conditions are met, return null indicating the password is strong
}

String? validatePasswordSignUp(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Password must have at least one uppercase letter';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Password must have at least one lowercase letter';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must have at least one number';
  }
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return 'Password must have at least one special character';
  }
  return null; // If all conditions are met, return null indicating the password is strong
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty || value.trim() == "") {
    return 'Please enter your username';
  }
  if (value.contains(' ')) {
    return 'Username should not contain spaces';
  }
  // Add other conditions as per your requirements
  // For example, check if the username already exists in your database (requires async operation)
  return null;
}

String? validateUsernameSignUp(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your username';
  }
  if (value.contains(' ')) {
    return 'Username should not contain spaces';
  }
  if (value.length < 3 || value.length > 20) {
    return 'Username must be between 3 and 20 characters';
  }

  return null; // If all checks are passed, return null
}
