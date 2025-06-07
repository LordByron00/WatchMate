import 'package:WatchMate/services/getAuthUID.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Send a message to another user
  Future<void> sendMessage(String receiverUsername, String message) async {
    // Fetch the receiver's Firebase UID using the username
    UserService userService = UserService();
    String? receiverId =
        await userService.getUserIdFromUsername(receiverUsername);

    String senderId =
        FirebaseAuth.instance.currentUser!.uid; // Get current user's UID

    // Create a message document in Firestore (example)
    await _db.collection('conversations').add({
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
