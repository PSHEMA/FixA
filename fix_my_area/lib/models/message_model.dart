import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final Timestamp timestamp;
  final String type;
  final String? imageUrl;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.type,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp,
      'type': type,
      'imageUrl': imageUrl,
    };
  }
}
