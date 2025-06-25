import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_my_area/models/review_model.dart';
import 'package:flutter/foundation.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _reviewsCollection = FirebaseFirestore.instance.collection('reviews');
  final CollectionReference _bookingsCollection = FirebaseFirestore.instance.collection('bookings');

  // Submit a review and mark the booking as reviewed in one transaction
  Future<void> submitReview(ReviewModel review, String bookingId) async {
    try {
      // Use a batch write to perform multiple operations atomically
      WriteBatch batch = _firestore.batch();

      // 1. Add the new review
      DocumentReference reviewRef = _reviewsCollection.doc();
      batch.set(reviewRef, review.toMap());

      // 2. Mark the corresponding booking as reviewed
      DocumentReference bookingRef = _bookingsCollection.doc(bookingId);
      batch.update(bookingRef, {'isReviewed': true});

      // Commit the batch
      await batch.commit();
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
