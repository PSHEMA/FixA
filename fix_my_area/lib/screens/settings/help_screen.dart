import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & FAQs')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExpansionTile(
            title: Text('How do I book a service?'),
            children: [
              ListTile(
                title: Text('1. Navigate to the Home screen and select a service category.'),
              ),
              ListTile(
                title: Text('2. Browse the list of available providers and tap on one to view their profile.'),
              ),
               ListTile(
                title: Text('3. Tap the "Book Now" button, fill in the required details, and send your request.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How do I cancel or reschedule a booking?'),
            children: [
               ListTile(
                title: Text('Navigate to the "My Bookings" tab. Here you will find options to cancel or reschedule any upcoming appointments.'),
              ),
            ],
          ),
           ExpansionTile(
            title: Text('How do I become a service provider?'),
            children: [
               ListTile(
                title: Text('During the sign-up process, make sure to toggle the "Are you a Service Provider?" switch. You will then be guided through setting up your services and location.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
