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
  final double price;
  final bool isReviewed;

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
    required this.price,
    required this.isReviewed,
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
      'isReviewed': isReviewed,
      'price': price, 
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
      isReviewed: data['isReviewed'] ?? false,
      price: (data['price'] ?? 0.0).toDouble(),
    );
  }
}
