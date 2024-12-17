import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch a list of all users from Firestore
  Stream<QuerySnapshot> getUsers() {
    return _db.collection('users').snapshots();
  }

  // Fetch all users and print their emails
  Future<void> fetchUsers() async {
    QuerySnapshot snapshot = await _db.collection('users').get();

    for (var doc in snapshot.docs) {
      print(doc.toString()); // Example: printing the email of each user
      print(doc['email']); // Example: printing the email of each user
      print(doc['id']); // Example: printing the email of each user
    }
  }

  // Add a user to the users collection
  // Future<void> createUser(String userId, String name, String email) async {
  //   await _db.collection('users').doc(userId).set({
  //     'name': name,
  //     'email': email,
  //     'created_at': FieldValue.serverTimestamp(),
  //   });
  // }

  // Fetch a user's data
  Future<DocumentSnapshot> getUser(String userId) async {
    return await _db.collection('users').doc(userId).get();
  }
}
