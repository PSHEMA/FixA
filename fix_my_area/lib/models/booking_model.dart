import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String customerId;
  final String customerName;
  final String providerId;
  final String providerName;
  final String service;
  final DateTime bookingTime;
  final String description;
  final String status;
  final Timestamp createdAt;
  final bool isReviewed; // New field

  BookingModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.providerId,
    required this.providerName,
    required this.service,
    required this.bookingTime,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.isReviewed, // Add to constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'providerId': providerId,
      'providerName': providerName,
      'service': service,
      'bookingTime': Timestamp.fromDate(bookingTime),
      'description': description,
      'status': status,
      'createdAt': createdAt,
      'isReviewed': isReviewed, // Add to map
    };
  }

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'] ?? 'Unknown Customer',
      providerId: data['providerId'] ?? '',
      providerName: data['providerName'] ?? 'Unknown Provider',
      service: data['service'] ?? 'Unknown Service',
      bookingTime: (data['bookingTime'] as Timestamp).toDate(),
      description: data['description'] ?? '',
      status: data['status'] ?? 'unknown',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      isReviewed: data['isReviewed'] ?? false, // Read from map
    );
  }
}
