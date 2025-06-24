import 'package:fix_my_area/models/booking_model.dart';
import 'package:fix_my_area/screens/customer/leave_review_screen.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final BookingService _bookingService = BookingService();
  final String? _currentUserId = AuthService().currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: _currentUserId == null
          ? const Center(child: Text('Please log in to see your bookings.'))
          : StreamBuilder<List<BookingModel>>(
              stream: _bookingService.getBookingsForCustomer(_currentUserId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('You have no bookings yet.'));
                }
                final bookings = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Flexible(child: Text(booking.service, style: Theme.of(context).textTheme.titleLarge)),
                                 Chip(
                                   label: Text(booking.status.toUpperCase(), style: const TextStyle(color: Colors.white)),
                                   backgroundColor: _getStatusColor(booking.status),
                                 ),
                               ],
                             ),
                            const SizedBox(height: 8),
                            Text('With: ${booking.providerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(DateFormat.yMMMd().add_jm().format(booking.bookingTime)),
                            const SizedBox(height: 8),
                            if(booking.status == 'completed' && !booking.isReviewed)
                              Center(
                                child: TextButton(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LeaveReviewScreen(booking: booking))),
                                  child: const Text('Leave a Review'),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'completed': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }
}
