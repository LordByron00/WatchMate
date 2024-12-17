import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user details using their username
  Future<String?> getUserIdFromUsername(String username) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Return the Firebase UID of the user
        return snapshot.docs.first.id; // Firebase UID is the document ID
      } else {
        return null; // Username not found
      }
    } catch (e) {
      print('Error fetching user ID: $e');
      return null;
    }
  }
}
