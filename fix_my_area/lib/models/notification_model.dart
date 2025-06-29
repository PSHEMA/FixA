import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId; 
  final String title;
  final String body;
  final bool isRead;
  final Timestamp createdAt;
  final String? type;
  final String? referenceId;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.type,
    this.referenceId,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'],
      title: data['title'],
      body: data['body'],
      isRead: data['isRead'],
      createdAt: data['createdAt'],
      type: data['type'],
      referenceId: data['referenceId'],
    );
  }
}
