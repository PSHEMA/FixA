import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;
  final String customerId;
  final String providerId;
  final String service;
  final DateTime bookingTime;
  final String description;
  final String status; // e.g., 'pending', 'confirmed', 'completed', 'cancelled'
  final Timestamp createdAt;

  BookingModel({
    this.id,
    required this.customerId,
    required this.providerId,
    required this.service,
    required this.bookingTime,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  // Method to convert a BookingModel instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'providerId': providerId,
      'service': service,
      'bookingTime': bookingTime,
      'description': description,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
