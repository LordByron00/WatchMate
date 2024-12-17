import 'package:WatchMate/services/conversationService.dart';
import 'package:WatchMate/services/sendMessage.dart';
import 'package:WatchMate/utils/auth.dart';
import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final Map<String, dynamic> user;

  // Constructor to accept the parameter
  const Chat({super.key, required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<Chat> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // Initialize with an empty stream
  String? convoID;

  @override
  void initState() {
    super.initState();
    createConvo();
  }

  Future<void> createConvo() async {
    convoID =
        await ConversationService().createConversation(widget.user['username']);
    setState(() {});
  }

  // List of messages
  // final List<Map<String, dynamic>> messages = [];

  // Text editing controller for the input field
  final TextEditingController _controller = TextEditingController();

  // Method to add a new message
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      print(widget.user['username'] + " ${_controller.text}");

      // setState(() {
      //   messages.add({'text': _controller.text.trim(), 'isSender': true});
      // });

      if (convoID!.isNotEmpty) {
        SendMessageService()
            .sendMessage(convoID!, _controller.text, widget.user['username']);
      }
      _controller.clear(); // Clear the text field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.user.isNotEmpty ? widget.user['name'] : 'user not found'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Show loading until yID is set
          Expanded(
            child: (convoID == null)
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: _db
                        .collection('conversations')
                        .doc(convoID)
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      // print(snapshot.data!.docs[0].data());

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No messages yet.'));
                      }

                      final snapmessages = snapshot.data!.docs;

                      return ListView.builder(
                        reverse: true, // Show newest messages at the bottom
                        itemCount: snapmessages.length,
                        itemBuilder: (context, index) {
                          final messageData = snapmessages[index].data()
                              as Map<String, dynamic>;
                          final isSender = messageData['sender_id'] ==
                              Auth().currentUser!.uid;

                          return MessageBubble(
                            text: messageData['message'] ?? '',
                            isSender: isSender,
                          );
                        },
                      );
                    },
                  ),
          ),
          // Input area
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed:
                      _sendMessage, // Call _sendMessage when button is pressed
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(navx: 2),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSender;

  const MessageBubble({
    required this.text,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender)
            CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/hanni.jpg'),
            ),
          if (!isSender) SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: const EdgeInsets.symmetric(vertical: 5),
            constraints: BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: isSender ? Colors.blue.shade100 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          if (isSender) SizedBox(width: 10),
          if (isSender)
            CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage('assets/lord.jpg'),
            ),
        ],
      ),
    );
  }
}
