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
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Flexible(child: Text(booking.service, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
                                 Chip(
                                   label: Text(booking.status, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                   backgroundColor: _getStatusColor(booking.status),
                                   padding: const EdgeInsets.symmetric(horizontal: 8),
                                 ),
                               ],
                             ),
                            const Divider(height: 20),
                            Text('With: ${booking.providerName}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(DateFormat.yMMMd().add_jm().format(booking.bookingTime), style: TextStyle(color: Colors.grey.shade700)),
                            if (booking.status == 'completed' && !booking.isReviewed)
                              Center(
                                child: TextButton(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LeaveReviewScreen(booking: booking))),
                                  child: const Text('Leave a Review'),
                                ),
                              ),
                            if (booking.status == 'pending' || booking.status == 'confirmed')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      // Show a confirmation dialog
                                      final bool? confirm = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Cancel Booking?'),
                                          content: const Text('Are you sure you want to cancel this booking?'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
                                            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Yes, Cancel')),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await BookingService().cancelBooking(booking.id);
                                      }
                                    },
                                    child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Show date/time picker to reschedule
                                      final newDateTime = await _showRescheduleDialog(context, booking.bookingTime);
                                      if (newDateTime != null) {
                                        await BookingService().updateBookingTime(booking.id, newDateTime);
                                      }
                                    },
                                    child: const Text('Reschedule'),
                                  ),
                                ],
                              ),
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

  // Helper method for reschedule dialog
  Future<DateTime?> _showRescheduleDialog(BuildContext context, DateTime initialDate) async {
    final newDate = await showDatePicker(
      context: context, 
      initialDate: initialDate, 
      firstDate: DateTime.now(), 
      lastDate: DateTime.now().add(const Duration(days: 90))
    );
    if (newDate == null) return null;

    final newTime = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.fromDateTime(initialDate)
    );
    if (newTime == null) return null;

    return DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
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