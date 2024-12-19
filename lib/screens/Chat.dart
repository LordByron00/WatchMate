import 'package:WatchMate/services/conversationService.dart';
import 'package:WatchMate/services/getAuthUID.dart';
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
  final UserService userService = UserService();

  // Initialize with an empty stream
  String? convoID;
  String? receiverImgUrl;
  String? senderImgUrl;

  @override
  void initState() {
    super.initState();
    createConvo();
    SetMatchDP(widget.user['username']);
    SetMatchDP(Auth().curUserData?.uid);
  }

  Future<String?> getUID(username) async {
    String? x = await userService.getUserIdFromUsername(username);
    return x;
  }

  Future<void> SetMatchDP(username) async {
    bool sender = true;
    String? fbid;

    if (username != Auth().curUserData?.uid) {
      fbid = await getUID(username);
      sender = false;
    } else {
      fbid = username;
    }

    Map<String, dynamic>? response = await userService.fetchDPbyID(fbid);

    if (response != null) {
      setState(() {
        sender
            ? senderImgUrl = response['file_url']
            : receiverImgUrl = response['file_url'];
      });
      // Handle the retrieved data
      print('ID: ${response['fbid']}');
      print('Name: ${response['name']}');
      print('file_url: ${response['file_url']}');
    } else {
      setState(() {
        sender ? senderImgUrl = 'not found' : receiverImgUrl = 'not found';
      });
    }
  }

  Future<void> createConvo() async {
    convoID =
        await ConversationService().createConversation(widget.user['username']);
    setState(() {});
  }

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
            child: (convoID == null ||
                    receiverImgUrl == null ||
                    senderImgUrl == null)
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
                            dp: receiverImgUrl,
                            senderImg: senderImgUrl,
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
  final String? dp;
  final String? senderImg;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isSender,
    required this.dp,
    required this.senderImg,
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
              backgroundImage: NetworkImage(dp!),
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
              backgroundImage: NetworkImage(senderImg!),
            ),
        ],
      ),
    );
  }
}
