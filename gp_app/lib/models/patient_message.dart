
// class ChatMessage {


//   final String message;
//   final bool receiver;
//   bool introMessageDisplayed = false;

// ChatMessage({required this.message,required this.receiver});
// }

class ChatMessage {
  final String message;
  final bool receiver;
  final String? audioUrl;  // Optional field for audio messages
  final DateTime timestamp;  // Timestamp for when the message was sent or received
  bool introMessageDisplayed = false;

  // Constructor
  ChatMessage({
    required this.message,
    required this.receiver,
    this.audioUrl,
    DateTime? timestamp,  // Allow timestamp to be optional and provide a default
  }) : this.timestamp = timestamp ?? DateTime.now();  // Default to current time if none provided

  // Optional: Add a method to format the timestamp
  String get formattedTimestamp => "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
}
