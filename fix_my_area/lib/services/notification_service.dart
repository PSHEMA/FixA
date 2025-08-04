import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proci/models/notification_model.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final CollectionReference _notificationsCollection = FirebaseFirestore.instance.collection('notifications');

  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    String? type,
    String? referenceId,
  }) async {
    try {
      await _notificationsCollection.add({
        'userId': userId,
        'title': title,
        'body': body,
        'isRead': false,
        'createdAt': Timestamp.now(),
        'type': type,
        'referenceId': referenceId,
      });
    } catch (e) {
      debugPrint("Error creating notification: $e");
    }
  }

  Stream<List<NotificationModel>> getNotifications(String userId) {
    return _notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(30)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromFirestore(doc)).toList());
  }

  Future<void> markAllAsRead(String userId) async {
    final querySnapshot = await _notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}
