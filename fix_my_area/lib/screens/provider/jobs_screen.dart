import 'package:fix_my_area/models/booking_model.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final BookingService _bookingService = BookingService();
  final String? _currentUserId = AuthService().currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Jobs')),
      body: _currentUserId == null
          ? const Center(child: Text('Could not find provider information.'))
          : StreamBuilder<List<BookingModel>>(
              stream: _bookingService.getBookingsForProvider(_currentUserId!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('You have no incoming jobs.'));
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
                            Text(booking.service, style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            Text('Customer: ${booking.customerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text('Date: ${DateFormat.yMMMd().add_jm().format(booking.bookingTime)}'),
                            const SizedBox(height: 8),
                            _buildActionButtons(booking), // Use a helper for buttons
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
  
  Widget _buildActionButtons(BookingModel booking) {
    switch (booking.status) {
      case 'pending':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => _bookingService.updateBookingStatus(booking.id, 'cancelled'),
              child: const Text('Decline', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _bookingService.updateBookingStatus(booking.id, 'confirmed'),
              child: const Text('Accept'),
            ),
          ],
        );
      case 'confirmed':
        return Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: () => _bookingService.updateBookingStatus(booking.id, 'completed'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Mark as Completed'),
          ),
        );
      default:
        return Align(
          alignment: Alignment.centerRight,
          child: Chip(
            label: Text(booking.status.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: _getStatusColor(booking.status),
          ),
        );
    }
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
