// import 'package:flutter/material.dart';

class ChatMessage {
  final int senderId;
  final int receiverId;
  final int? burnId;
  final String message;
  final String? image;
  final String? voiceNote; 
  final bool? receiver;
  final DateTime timestamp;
  // Variables Related to the Location
  final double? latitude; // Add latitude
  final double? longitude; // Add longitude
  final String? hospitalNameEn;
  final String? hospitalNameAr;
  final List<Map<String, String>>? hospitalDetails;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    this.burnId,
    required this.message,
    required this.receiver,
    this.image,
    this.voiceNote,
    required this.timestamp,
    // Variables Related to the Location
    this.latitude, // Initialize latitude
    this.longitude, // Initialize longitude
    this.hospitalNameEn,
    this.hospitalNameAr,
    this.hospitalDetails,
  });

  // Factory constructor to create a ChatMessage from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['sender_id'] as int,
      receiverId: json['receiver_id'] as int,
      burnId: json['burn_id'] as int,
      message: json['message'] as String? ?? '',
      image: json['image'] as String?,
      voiceNote: json['voice_note'] as String?,
      receiver: json['receiver'] as bool?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Convert instance back to JSON, useful for sending data back to a server or saving locally
  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'burn_id': burnId,
      'message': message,
      'image': image,
      'voice_note': voiceNote,
      'receiver': receiver,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
