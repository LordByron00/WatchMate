class Message {
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  // Factory method to create a Message object from Firestore data
  factory Message.fromFirestore(Map<String, dynamic> data) {
    return Message(
      senderId: data['sender_id'],
      receiverId: data['receiver_id'],
      content: data['content'],
      timestamp: (data['timestamp']).toDate(),
    );
  }
}
