import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/customer/booking_screen.dart'; // Import new screen
import 'package:flutter/material.dart';

class ProviderProfileScreen extends StatelessWidget {
  final UserModel provider;

  const ProviderProfileScreen({super.key, required this.provider});

  // ... (No changes to build, _buildHeader, or _buildServicesList)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About Me', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(provider.bio, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
                  const SizedBox(height: 24),
                  Text('My Services', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildServicesList(),
                  const SizedBox(height: 24),
                   Text('Reviews', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                   const SizedBox(height: 12),
                   const Center(child: Text('Reviews will be shown here.', style: TextStyle(color: Colors.grey))),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBookingBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: provider.photoUrl.isNotEmpty ? NetworkImage(provider.photoUrl) : null,
            child: provider.photoUrl.isEmpty ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
          ),
          const SizedBox(height: 12),
          Text(provider.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 4),
              Text('4.8 (120 Reviews)', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: provider.services.map((service) => Chip(
        label: Text(service),
        backgroundColor: Colors.grey.shade200,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      )).toList(),
    );
  }

  Widget _buildBookingBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
        border: Border(top: BorderSide(color: Colors.grey.shade200))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Starting Rate', style: TextStyle(color: Colors.grey)),
              Text(provider.rate, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // ** NAVIGATION LOGIC HERE **
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookingScreen(provider: provider),
                ),
              );
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }
}
