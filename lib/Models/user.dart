import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String username;
  final String name;
  final String email;
  final DateTime? createdAt;
  final DateTime? birthdate;
  final String? age;
  final String? gender;
  final String? school;
  final String? location;
  final String? bio;
  final List<dynamic>? genre;

  UserData({
    required this.uid,
    required this.username,
    required this.name,
    required this.email,
    this.createdAt,
    this.birthdate,
    this.age,
    this.gender,
    this.school,
    this.location,
    this.bio,
    this.genre,
  });

  // Factory method to create a User object from Firestore data
  factory UserData.fromFirestore(Map<String, dynamic> data) {
    return UserData(
      uid: data['uid'],
      username: data['username'],
      name: data['name'],
      email: data['email'],
      birthdate: (data['birthdate'] is Timestamp)
          ? (data['birthdate'] as Timestamp).toDate()
          : DateTime.now(),
      age: data['age'],
      gender: data['gender'],
      school: data['school'],
      location: data['location'],
      bio: data['bio'],
      genre: data['genre'],
      createdAt: (data['created_at'] is Timestamp)
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime.now(), // Fallback for incomplete data
    );
  }
}
