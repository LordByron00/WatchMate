import 'package:WatchMate/Models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final Auth AuthSingleInstance = Auth._internal();

  // Private constructor
  Auth._internal();

  // Factory constructor to return the singleton instance
  factory Auth() {
    return AuthSingleInstance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  UserData? curUser;

  UserData? get curUserData => curUser;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    setUser();
  }

  Future<void> setUser() async {
    print('Seting User');
    if (currentUser != null) {
      print(currentUser!.uid);

      DocumentSnapshot UserSnap = await getUser(currentUser!.uid);

      Map<String, dynamic> userSnapData =
          UserSnap.data() as Map<String, dynamic>;

      if (userSnapData.isEmpty) {
        throw Exception("User data not found for UID: ${currentUser!.uid}");
      }

      Map<String, dynamic> userData = {
        'uid': currentUser!.uid,
        ...userSnapData
      };

      print(userData);

      curUser = UserData.fromFirestore(userData);
      if (curUser != null) {
        print(curUserData!.name); // Now curUser is guaranteed to be non-null
      } else {
        print("curUser is null after assigning data.");
      }
    }
  }

  Future<DocumentSnapshot> getUser(String userId) async {
    print('Getting user');
    return await _firebaseFirestore.collection('users').doc(userId).get();
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signUp(
      String email, String password, String username, String name) async {
    try {
      // Create user with Firebase Auth
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After user is created, store additional user details in Firestore
      User? user = userCredential.user;

      if (user != null) {
        Map<String, dynamic> userData = {
          'username': username,
          'name': name,
          'email': user.email,
          'created_at': FieldValue.serverTimestamp(),
        };

        // Create a user document in Firestore
        await _firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .set(userData);

        print(userData);

        curUser = UserData.fromFirestore({
          'uid': user.uid,
          ...userData,
        });

        if (curUser != null) {
          print(curUserData!.name); // Now curUser is guaranteed to be non-null
        } else {
          print("curUser is null after assigning data.");
        }
      } else {
        print('user is null');
      }
    } catch (e) {
      print('Error signing up: $e');
    }
  }
}
