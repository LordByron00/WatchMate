import 'package:WatchMate/services/getAuthUID.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SendMessageService {
  final String senderID = FirebaseAuth.instance.currentUser!.uid;

  void sendMessage(
      String conversationId, String message, String receiverUsername) async {
    UserService userService = UserService();
    String? receiverID =
        await userService.getUserIdFromUsername(receiverUsername);
    print(senderID);
    print(receiverID);

    // Create a new message
    var newMessage = {
      'sender_id': senderID,
      'receiver_id': receiverID,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'sent'
    };

    // Send the message to Firestore in the conversation's messages collection
    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(newMessage);

    // Update the last message in the conversation document
    await FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .update({'last_message_timestamp': FieldValue.serverTimestamp()});
  }
}
