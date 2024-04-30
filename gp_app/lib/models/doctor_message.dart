
// import 'dart:io';

// import 'package:flutter/material.dart';

// class DoctorMessage {

//   final String message;
//   final bool receiver;
//   final String? imageFile;
  

// DoctorMessage({
//   required this.message,
//   required this.receiver,
//   required this.imageFile,
//   });

//   factory DoctorMessage.fromJson(Map<String, dynamic> json) {
//     return DoctorMessage(
//       message: json['message'] as String,
//       receiver: json['receiver'] as bool,
//       imageFile: json['imageFile'] as String?,
//     );
//   }
// }

class DoctorMessage {
  final String message;
  final bool receiver;
  final String? imageFile;
  final String? audioUrl;  // Optional field for audio messages
  final DateTime timestamp;  // Timestamp for when the message was created or received

  DoctorMessage({
    required this.message,
    required this.receiver,
    this.imageFile,
    this.audioUrl,
    required this.timestamp,
  });

  factory DoctorMessage.fromJson(Map<String, dynamic> json) {
    return DoctorMessage(
      message: json['message'] as String,
      receiver: json['receiver'] as bool,
      imageFile: json['imageFile'] as String?,
      audioUrl: json['audioUrl'] as String?,  // Handle audio URLs
      timestamp: DateTime.parse(json['timestamp'] as String),  // Assuming 'timestamp' is in ISO 8601 format
    );
  }

  // Optionally, create a method to convert instance back to JSON, useful for sending data back to a server or saving locally
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