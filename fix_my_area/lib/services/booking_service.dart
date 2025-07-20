// ignore_for_file: unused_field

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proci/models/booking_model.dart';
import 'package:proci/services/notification_service.dart';
import 'package:flutter/foundation.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _bookingsCollection = FirebaseFirestore.instance.collection('bookings');
  final NotificationService _notificationService = NotificationService();

  // Create a new booking
  Future<void> createBooking(BookingModel booking) async {
    try {
      await _bookingsCollection.add(booking.toMap());
      await _notificationService.createNotification(
        userId: booking.providerId,
        title: 'New Job Request!',
        body: '${booking.customerName} has requested your ${booking.service} service.',
        type: 'booking',
        referenceId: booking.id,
      );
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
      if (status == 'confirmed') {
        final bookingDoc = await _bookingsCollection.doc(bookingId).get();
        await _notificationService.createNotification(
          userId: bookingDoc['customerId'],
          title: 'Booking Confirmed!',
          body: '${bookingDoc['providerName']} has confirmed your booking.',
        );
      }
    } catch (e) {
      debugPrint("Error updating booking status: $e");
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _bookingsCollection.doc(bookingId).delete();
    } catch (e) {
      debugPrint("Error cancelling booking: $e");
      rethrow;
    }
  }

  Future<void> completeBooking(String bookingId, double price) async {
    try {
      await _bookingsCollection.doc(bookingId).update({
        'status': 'completed',
        'price': price,
      });
    } catch (e) {
      debugPrint("Error completing booking: $e");
      rethrow;
    }
  }

  updateBookingTime(String id, DateTime newDateTime) {}
}
