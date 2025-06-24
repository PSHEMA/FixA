import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_my_area/models/booking_model.dart';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final UserModel provider;

  const BookingScreen({super.key, required this.provider});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final BookingService _bookingService = BookingService();
  final AuthService _authService = AuthService();

  String? _selectedService;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-select the first service if available
    if (widget.provider.services.isNotEmpty) {
      _selectedService = widget.provider.services.first;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }
  
  Future<void> _submitBooking() async {
  if (!_formKey.currentState!.validate() || _selectedDate == null || _selectedTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields and select a date/time.')),
    );
    return;
  }

  setState(() => _isLoading = true);

  // Fetch current user details to get their name
  final currentUser = await _authService.getUserDetails();
  if (currentUser == null) {
    setState(() => _isLoading = false);
    return;
  }

  final bookingDateTime = DateTime(
    _selectedDate!.year, _selectedDate!.month, _selectedDate!.day,
    _selectedTime!.hour, _selectedTime!.minute
  );

  // We create a temporary booking model without an ID, as Firestore provides it.
  final newBooking = BookingModel(
    id: '', // Firestore will generate this
    customerId: currentUser.uid,
    customerName: currentUser.name, // Pass customer name
    providerId: widget.provider.uid,
    providerName: widget.provider.name, // Pass provider name
    service: _selectedService!,
    bookingTime: bookingDateTime,
    description: _descriptionController.text,
    status: 'pending',
    createdAt: Timestamp.now(),
    isReviewed: false, // Default to false
  );

  try {
    await _bookingService.createBooking(newBooking);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking request sent successfully!')),
    );
    // Pop back two screens to the main scaffold
    Navigator.of(context).popUntil((route) => route.isFirst);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to send booking: ${e.toString()}')),
    );
  } finally {
    if(mounted) setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book ${widget.provider.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select a Service', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedService,
                items: widget.provider.services.map((String service) {
                  return DropdownMenuItem<String>(value: service, child: Text(service));
                }).toList(),
                onChanged: (newValue) => setState(() => _selectedService = newValue),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                validator: (v) => v == null ? 'Please select a service' : null,
              ),
              const SizedBox(height: 24),

              Text('Choose Date & Time', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
                        child: Text(_selectedDate == null ? 'Select Date' : DateFormat.yMMMd().format(_selectedDate!)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Time', border: OutlineInputBorder()),
                        child: Text(_selectedTime == null ? 'Select Time' : _selectedTime!.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text('Describe the Issue (Optional)', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'e.g., "My kitchen sink is leaking under the cabinet."',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitBooking,
                      child: const Text('Send Booking Request'),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
