import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String providerId;
  final String customerId;
  final String customerName;
  final int rating; // 1 to 5 stars
  final String comment;
  final Timestamp createdAt;

  ReviewModel({
    required this.id,
    required this.providerId,
    required this.customerId,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  // Convert a ReviewModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'providerId': providerId,
      'customerId': customerId,
      'customerName': customerName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }

  // Create a ReviewModel from a Firestore document
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      providerId: data['providerId'] ?? '',
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? 'Anonymous',
      rating: data['rating'] ?? 0,
      comment: data['comment'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
