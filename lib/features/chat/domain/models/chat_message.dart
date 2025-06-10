import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String message;
  final Timestamp createdAt;

  ChatMessage({
    required this.senderId,
    required this.message,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'] as String,
      message: json['message'] as String,
      createdAt: json['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'message': message,
      'createdAt': createdAt,
    };
  }
}