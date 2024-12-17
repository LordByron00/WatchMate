import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String username;
  final String name;
  final String email;
  final DateTime? createdAt;

  UserData({
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
    this.createdAt,
  });

  // Factory method to create a User object from Firestore data
  factory UserData.fromFirestore(Map<String, dynamic> data) {
    return UserData(
      uid: data['uid'],
      username: data['username'],
      name: data['name'],
      email: data['email'],
      createdAt: (data['created_at'] is Timestamp)
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime.now(), // Fallback for incomplete data
    );
  }
}
