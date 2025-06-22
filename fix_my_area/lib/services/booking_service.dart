import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_my_area/models/booking_model.dart';
import 'package:flutter/foundation.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new booking in Firestore
  Future<void> createBooking(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toMap());
    } catch (e) {
      debugPrint("Error creating booking: $e");
      // Rethrow the exception to be handled by the UI
      rethrow;
    }
  }

  // More functions will be added here later, e.g., to get bookings
  // for a customer or a provider.
}
