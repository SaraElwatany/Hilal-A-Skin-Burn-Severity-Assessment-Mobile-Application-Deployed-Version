class ChatMessage {
  final String message;
  final bool receiver; // Indicates if the message was received (true) or sent (false)
  final String? imageFile;
  final String? audioUrl;
  final DateTime timestamp;
  bool introMessageDisplayed = false;

  ChatMessage({
    required this.message,
    required this.receiver,
    this.imageFile,
    this.audioUrl,
    DateTime? timestamp,  // Allow timestamp to be optional and provide a default
  }) : this.timestamp = timestamp ?? DateTime.now();  // Default to current time if none provided


  // Factory constructor to create a ChatMessage from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] as String,
      receiver: json['receiver'] as bool,
      imageFile: json['imageFile'] as String?,
      audioUrl: json['audioUrl'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),  // Assuming 'timestamp' is in ISO 8601 format
    );
  }

  // Convert instance back to JSON, useful for sending data back to a server or saving locally
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'receiver': receiver,
      'imageFile': imageFile,
      'audioUrl': audioUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
