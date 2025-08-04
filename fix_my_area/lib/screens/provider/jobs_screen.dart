import 'package:proci/models/booking_model.dart';
import 'package:proci/services/auth_service.dart';
import 'package:proci/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proci/chat/chat_screen.dart';
import 'package:proci/models/user_model.dart';

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
                            TextButton.icon(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                final tempReceiver = UserModel(
                                    uid: booking.customerId,
                                    name: booking.customerName,
                                    email: '', phone: '', role: '', services: [], bio: '', rate: '', photoUrl: '', workingHours: {}, daysOff: [], isVerified: false
                                  );
                                Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(receiver: tempReceiver)));
                              },
                              icon: const Icon(Icons.message_outlined, size: 16),
                              label: const Text('Message Customer'),
                            ),
                            const SizedBox(height: 8),
                            _buildActionButtons(booking),
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
          onPressed: () async {
            final price = await _showPriceDialog();
            if (price != null) {
              await _bookingService.completeBooking(booking.id, price);
            }
          },
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

  Future<double?> _showPriceDialog() {
  final controller = TextEditingController();
  return showDialog<double>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Enter Final Price'),
      content: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(prefixText: 'RWF '),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.of(context).pop(double.tryParse(controller.text)), child: const Text('Confirm')),
      ],
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
