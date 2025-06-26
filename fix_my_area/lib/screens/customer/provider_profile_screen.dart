import 'package:fix_my_area/chat/chat_screen.dart';
import 'package:fix_my_area/models/review_model.dart';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/customer/booking_screen.dart';
import 'package:fix_my_area/screens/customer/widgets/review_card.dart';
import 'package:fix_my_area/services/review_service.dart';
import 'package:flutter/material.dart';

class ProviderProfileScreen extends StatefulWidget {
  final UserModel provider;

  const ProviderProfileScreen({super.key, required this.provider});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  final ReviewService _reviewService = ReviewService();
  late Stream<List<ReviewModel>> _reviewsStream;

  @override
  void initState() {
    super.initState();
    // Start listening to the stream of reviews for this provider
    _reviewsStream = _reviewService.getReviewsForProvider(widget.provider.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.provider.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The header now uses a StreamBuilder to display live rating data
            _buildHeader(context),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About Me', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.provider.bio, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[700])),
                  const SizedBox(height: 24),
                  Text('My Services', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildServicesList(),
                  const SizedBox(height: 24),
                  Text('Reviews', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  // The review list is also built from the stream
                  _buildReviewsSection(),
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
    return StreamBuilder<List<ReviewModel>>(
      stream: _reviewsStream,
      builder: (context, snapshot) {
        // Calculate average rating and count
        double avgRating = 0;
        int reviewCount = 0;
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          reviewCount = snapshot.data!.length;
          avgRating = snapshot.data!.map((r) => r.rating).reduce((a, b) => a + b) / reviewCount;
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          color: Theme.of(context).primaryColor.withOpacity(0.05),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: widget.provider.photoUrl.isNotEmpty ? NetworkImage(widget.provider.photoUrl) : null,
                child: widget.provider.photoUrl.isEmpty ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
              ),
              const SizedBox(height: 12),
              Text(widget.provider.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${avgRating.toStringAsFixed(1)} (${reviewCount} Reviews)',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    // Pass the entire provider object now
                    builder: (_) => ChatScreen(receiver: widget.provider),
                  ),
                ),
                icon: const Icon(Icons.message_outlined),
                label: const Text('Message Provider'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServicesList() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.provider.services.map((service) => Chip(
        label: Text(service),
        backgroundColor: Colors.grey.shade200,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      )).toList(),
    );
  }
  
  Widget _buildReviewsSection() {
    return StreamBuilder<List<ReviewModel>>(
      stream: _reviewsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No reviews yet. Be the first!'));
        }
        final reviews = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return ReviewCard(review: reviews[index]);
          },
        );
      },
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
              Text(widget.provider.rate, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingScreen(provider: widget.provider))),
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }
}
