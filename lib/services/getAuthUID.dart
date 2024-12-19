import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  Future<Map<String, dynamic>?> fetchDPbyID(uid) async {
    try {
      // Query the 'images' table for a single row where name matches
      final response = await Supabase.instance.client
          .from('images')
          .select()
          .eq('fbid', uid)
          .order('uploaded_at', ascending: false)
          .limit(1) // Filter rows where name = 'something'
          .maybeSingle();

      return response;

      // Fetch at most one row, or null if none found
    } catch (e) {
      print('Unexpected error: $e');
    }
    return null;
  }
}
