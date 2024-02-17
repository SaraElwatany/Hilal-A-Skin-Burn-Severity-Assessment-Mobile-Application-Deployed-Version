
// import 'dart:io';

// import 'package:flutter/material.dart';

class DoctorMessage {

  final String message;
  final bool receiver;
  final String? imageFile;
  

DoctorMessage({
  required this.message,
  required this.receiver,
  required this.imageFile,
  });

  factory DoctorMessage.fromJson(Map<String, dynamic> json) {
    return DoctorMessage(
      message: json['message'] as String,
      receiver: json['receiver'] as bool,
      imageFile: json['imageFile'] as String?,
    );
  }
}
