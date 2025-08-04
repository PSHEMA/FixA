import 'package:proci/chat/chat_screen.dart';
import 'package:proci/models/review_model.dart';
import 'package:proci/models/user_model.dart';
import 'package:proci/screens/customer/booking_screen.dart';
import 'package:proci/screens/customer/widgets/review_card.dart';
import 'package:proci/services/review_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
    _reviewsStream = _reviewService.getReviewsForProvider(widget.provider.uid);
  }

  Widget _buildRatingRow(double avgRating, int reviewCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 4),
          Text(
            '${avgRating.toStringAsFixed(1)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    String? label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: label != null
          ? ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: isPrimary ? Theme.of(context).primaryColor : Colors.white,
                foregroundColor: isPrimary ? Colors.white : Theme.of(context).primaryColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isPrimary ? BorderSide.none : BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                ),
              ),
            )
          : IconButton(
              onPressed: onPressed,
              icon: Icon(icon),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(12),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.provider.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.grey[50],
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
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
                  // About Section
                  _buildSectionHeader('About Me'),
                  _buildInfoCard(
                    child: Text(
                      widget.provider.bio.isNotEmpty 
                          ? widget.provider.bio 
                          : 'No bio available.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Services Section
                  _buildSectionHeader('My Services'),
                  _buildInfoCard(child: _buildServicesList()),
                  const SizedBox(height: 32),

                  // Reviews Section
                  _buildSectionHeader('Reviews'),
                  _buildReviewsSection(),
                  const SizedBox(height: 100),
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
        double avgRating = 0;
        int reviewCount = 0;
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          reviewCount = snapshot.data!.length;
          avgRating = snapshot.data!.map((r) => r.rating).reduce((a, b) => a + b) / reviewCount;
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          color: Colors.grey[50],
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: widget.provider.photoUrl.isNotEmpty 
                    ? NetworkImage(widget.provider.photoUrl) 
                    : null,
                child: widget.provider.photoUrl.isEmpty 
                    ? Icon(Icons.person, size: 50, color: Colors.grey[600])
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      widget.provider.name, 
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (widget.provider.isVerified) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, color: Colors.blue, size: 24),
                  ]
                ],
              ),
              const SizedBox(height: 4),
              _buildRatingRow(avgRating, reviewCount),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => ChatScreen(receiver: widget.provider))
                ),
                icon: const Icon(Icons.message_outlined),
                label: const Text('Message Provider'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServicesList() {
    if (widget.provider.services.isEmpty) {
      return Text(
        'No services listed.',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
      );
    }

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: widget.provider.services.map((service) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          service,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
            fontSize: 14,
          ),
        ),
      )).toList(),
    );
  }
  
  Widget _buildReviewsSection() {
    return StreamBuilder<List<ReviewModel>>(
      stream: _reviewsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(40),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildInfoCard(
            child: Column(
              children: [
                Icon(
                  Icons.star_outline,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No reviews yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to leave a review!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        final reviews = snapshot.data!;
        return Column(
          children: reviews.map((review) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ReviewCard(review: review),
          )).toList(),
        );
      },
    );
  }

  Widget _buildBookingBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Rate Information
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Starting Rate',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.provider.rate,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Action Buttons
            Expanded(
              child: Row(
                children: [
                  // Call Button
                  _buildActionButton(
                    icon: Icons.call_outlined,
                    onPressed: () async {
                      final Uri launchUri = Uri(scheme: 'tel', path: widget.provider.phone);
                      if (await canLaunchUrl(launchUri)) {
                        await launchUrl(launchUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not make the call.'))
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  
                  // Book Now Button
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.calendar_month_outlined,
                      label: 'Book Now',
                      isPrimary: true,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingScreen(provider: widget.provider),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}