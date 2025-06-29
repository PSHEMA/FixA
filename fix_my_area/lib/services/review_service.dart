import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_my_area/models/review_model.dart';
import 'package:flutter/foundation.dart';
import 'package:fix_my_area/services/notification_service.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _reviewsCollection = FirebaseFirestore.instance.collection('reviews');
  final CollectionReference _bookingsCollection = FirebaseFirestore.instance.collection('bookings');
  final NotificationService _notificationService = NotificationService();

  // Submit a review and mark the booking as reviewed in one transaction
  Future<void> submitReview(ReviewModel review, String bookingId) async {
    try {
      WriteBatch batch = _firestore.batch();

      DocumentReference reviewRef = _reviewsCollection.doc();
      batch.set(reviewRef, review.toMap());

      DocumentReference bookingRef = _bookingsCollection.doc(bookingId);
      batch.update(bookingRef, {'isReviewed': true});

      await batch.commit();
      await _notificationService.createNotification(
        userId: review.providerId,
        title: 'You Have a New Review!',
        body: '${review.customerName} left you a ${review.rating}-star review.',
      );
    } catch (e) {
      debugPrint("Error submitting review: $e");
      rethrow;
    }
  }

  // Get all reviews for a specific provider
  Stream<List<ReviewModel>> getReviewsForProvider(String providerId) {
    return _reviewsCollection
        .where('providerId', isEqualTo: providerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    });
  }

  Stream<List<ReviewModel>> getReviewsForCustomer(String customerId) {
    return _reviewsCollection
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    });
  }
}
