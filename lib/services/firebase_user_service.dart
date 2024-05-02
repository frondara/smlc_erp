// firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> createUser(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> addUserDetails(String uid, String username, String email) async {
    return await _firestore.collection('users').doc(uid).set({
      'username': username,
      'email': email,
      'Role': "N/A",
    });
  }

  Future<UserCredential> login(String identifier, String password) async {
    // Check if identifier is an email or a username
    String email = identifier.contains('@')
        ? identifier
        : await fetchEmailFromUsername(identifier);
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String> fetchEmailFromUsername(String username) async {
    final result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (result.docs.isEmpty) {
      throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for the given username.');
    }
    return result.docs.first.data()['email'] as String;
  }

  Future<String> getUsernameFromDB(String username) async {
    final result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (result.docs.isEmpty) {
      return "";
    }
    return result.docs.first.data()['username'] as String;
  }
}
