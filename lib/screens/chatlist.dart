import 'package:WatchMate/screens/Chat.dart';
import 'package:WatchMate/utils/auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationsList extends StatelessWidget {
  final String currentUserId = Auth().curUserData!.uid;
  // ConversationsList({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .where('participants', arrayContains: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final conversations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final participants =
                  List<String>.from(conversation['participants']);

              // Determine the receiver by excluding the current user
              final receiverId =
                  participants.firstWhere((id) => id != currentUserId);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(receiverId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(
                      title: Text("Loading..."),
                    );
                  }

                  final user = userSnapshot.data!;

                  Map<String, dynamic> userSnapData =
                      user.data() as Map<String, dynamic>;

                  final receiverName =
                      user['name']; // Assumes `name` field in users collection

                  return ListTile(
                    title: Text(receiverName),
                    onTap: () {
                      // Navigate to chat screen or perform desired action
                      print("Tapped on conversation with $receiverName");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat(user: userSnapData)));
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
