import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up and store user details in Firestore
  Future<void> signUp(
      String email, String password, String username, String name) async {
    try {
      // Create user with Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After user is created, store additional user details in Firestore
      User? user = userCredential.user;

      if (user != null) {
        // Create a user document in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'name': name,
          'email': user.email,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error signing up: $e');
    }
  }
}
