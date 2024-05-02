String? validateEmail(String? value) {
  if (value == null || value.isEmpty || value.trim() == "") {
    return 'Please enter your email';
  } else if (!value.contains('@')) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty || value.trim() == "") {
    return 'Please enter your password';
  }
  //validate if password is strong
  return null;
}

String? validateUsername(String? value) {
  if (value == null || value.isEmpty || value.trim() == "") {
    return 'Please enter a username';
  }
  if (value.contains(' ')) {
    return 'Username should not contain spaces';
  }
  // Add other conditions as per your requirements
  // For example, check if the username already exists in your database (requires async operation)
  return null;
}
