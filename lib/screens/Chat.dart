import 'package:WatchMate/widgets/bottomNavBar.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<Chat> {
  // List of messages
  final List<Map<String, dynamic>> messages = [
    {'text': 'Hi there!', 'isSender': false},
    {'text': 'Hello! How are you?', 'isSender': true},
    {'text': 'I am good, thanks! What about you?', 'isSender': false},
  ];

  // Text editing controller for the input field
  final TextEditingController _controller = TextEditingController();

  // Method to add a new message
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        messages.add({'text': _controller.text.trim(), 'isSender': true});
      });
      _controller.clear(); // Clear the text field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hanni Pham"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubble(
                  text: message['text'],
                  isSender: message['isSender'],
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
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isSender)
          CircleAvatar(
            radius: 20,
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
            radius: 20,
            backgroundImage: AssetImage('assets/lord.jpg'),
          ),
      ],
    );
  }
}
