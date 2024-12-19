import 'package:WatchMate/services/getAuthUID.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConversationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String senderID = FirebaseAuth.instance.currentUser!.uid;

  // Create a conversation between two users if it doesn't exist
  Future<String> createConversation(String username) async {
    UserService userService = UserService();
    String? receiverID = await userService.getUserIdFromUsername(username);
    print(username);
    print(receiverID);

    // Check if a conversation already exists between the two users
    var conversationId = await getConversationId(receiverID);
    if (conversationId != null) {
      return conversationId; // Return existing conversation ID if found
    }

    // Otherwise, create a new conversation
    var conversationRef = await _db.collection('conversations').add({
      'participants': [senderID, receiverID],
      'last_message_timestamp': FieldValue.serverTimestamp(),
    });

    return conversationRef.id; // Return the newly created conversation ID
  }

  // Get a conversation ID for two users (sender and receiver)
  Future<String?> getConversationId(String? receiverID) async {
    // Validate inputs
    if (receiverID == null) {
      throw ArgumentError('SenderID and ReceiverID cannot be null');
    }

    // Perform query with `arrayContainsAny` to fetch potential matches
    var querySnapshot = await _db
        .collection('conversations')
        .where('participants', arrayContainsAny: [senderID, receiverID]).get();

    // If no documents are returned, no conversation exists
    if (querySnapshot.docs.isEmpty) {
      return null; // No conversation found
    }

    // Filter results manually to ensure both sender and receiver are in `participants`
    for (var doc in querySnapshot.docs) {
      var participants = List<String>.from(doc['participants']);
      if (participants.contains(senderID) &&
          participants.contains(receiverID)) {
        return doc
            .id; // Return the first conversation ID where both are participants
      }
    }

    // No exact match found
    return null;
  }

  // Fetch all conversations for a user
  Stream<QuerySnapshot> getConversations(String userId) {
    return _db
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy('last_message_timestamp', descending: true)
        .snapshots();
  }

  // Fetch a specific conversation by ID
  Future<DocumentSnapshot> getConversation(String conversationId) async {
    return await _db.collection('conversations').doc(conversationId).get();
  }
}
