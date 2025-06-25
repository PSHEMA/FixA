import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_my_area/models/booking_model.dart';
import 'package:flutter/foundation.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _bookingsCollection = FirebaseFirestore.instance.collection('bookings');

  // Create a new booking
  Future<void> createBooking(BookingModel booking) async {
    try {
      await _bookingsCollection.add(booking.toMap());
    } catch (e) {
      debugPrint("Error creating booking: $e");
      rethrow;
    }
  }

  // Get a stream of bookings for a specific customer
  Stream<List<BookingModel>> getBookingsForCustomer(String customerId) {
    return _bookingsCollection
        .where('customerId', isEqualTo: customerId)
        .orderBy('bookingTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BookingModel.fromFirestore(doc)).toList();
    });
  }

  // Get a stream of bookings for a specific provider
  Stream<List<BookingModel>> getBookingsForProvider(String providerId) {
    return _bookingsCollection
        .where('providerId', isEqualTo: providerId)
        .orderBy('bookingTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => BookingModel.fromFirestore(doc)).toList();
    });
  }

  // Update the status of a booking
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _bookingsCollection.doc(bookingId).update({'status': status});
    } catch (e) {
      debugPrint("Error updating booking status: $e");
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      // For simplicity, we delete the booking. You could also set a 'cancelled' status.
      await _bookingsCollection.doc(bookingId).delete();
    } catch (e) {
      debugPrint("Error cancelling booking: $e");
      rethrow;
    }
  }
}
