import 'package:WatchMate/screens/Chat.dart';
import 'package:WatchMate/services/getAuthUID.dart';
import 'package:WatchMate/utils/auth.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationsList extends StatefulWidget {
  const ConversationsList({super.key});

  @override
  State<ConversationsList> createState() => _ConversationsListState();
}

class _ConversationsListState extends State<ConversationsList> {
  final String currentUserId = Auth().curUserData!.uid;
  final UserService userService = UserService();

  // Initialize with an empty stream
  String? convoID;
  String? receiverImgUrl;
  String? senderImgUrl;

  @override
  void initState() {
    super.initState();
  }

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

                  // SetMatchDP(userSnapData['username']);
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: userService.fetchDPbyUsername(user['username']),
                    builder: (context, supabaseSnapshot) {
                      if (supabaseSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return ListTile(
                          title: Text('Loading...'),
                        );
                      }

                      if (supabaseSnapshot.hasError) {
                        return ListTile(
                          title: Text(
                              'Error fetching data from Supabase: ${supabaseSnapshot.error}'),
                        );
                      }
                      var supabaseUserData = supabaseSnapshot.data!;
                      // print(supabaseUserData);
                      return Container(
                        margin: EdgeInsets.only(left: 30),
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              supabaseUserData.isNotEmpty
                                  ? supabaseUserData['file_url']
                                  : 'empty',
                            ),
                            radius: 25,
                          ),
                          title: Text(receiverName),
                          onTap: () {
                            // Navigate to chat screen or perform desired action
                            print("Tapped on conversation with $receiverName");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Chat(user: userSnapData)));
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        navx: 2,
      ),
    );
  }
}
