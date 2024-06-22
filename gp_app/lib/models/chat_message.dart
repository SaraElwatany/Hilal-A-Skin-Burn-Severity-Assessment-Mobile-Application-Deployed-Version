class ChatMessage {
  final String senderId;
  final String receiverId;
  final String message;
  final String? image;
  final bool receiver;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.receiver,
    this.image,
    required this.timestamp,
  });


  // Factory constructor to create a ChatMessage from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] as String,
      receiver: json['receiver'] as bool,
      image: json['image'] as String?,  
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),  // Assuming 'timestamp' is in ISO 8601 format
    );
  }

  // Convert instance back to JSON, useful for sending data back to a server or saving locally
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'receiver': receiver,
      'image': image,
       'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

}

