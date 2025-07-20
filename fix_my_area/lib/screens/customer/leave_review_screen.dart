import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proci/models/booking_model.dart';
import 'package:proci/models/review_model.dart';
import 'package:proci/services/auth_service.dart';
import 'package:proci/services/review_service.dart';
import 'package:flutter/material.dart';

class LeaveReviewScreen extends StatefulWidget {
  final BookingModel booking;
  const LeaveReviewScreen({super.key, required this.booking});

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  final ReviewService _reviewService = ReviewService();
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isLoading = false;

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a star rating.')));
      return;
    }

    setState(() => _isLoading = true);

    final currentUser = await AuthService().getUserDetails();
    if (currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    final newReview = ReviewModel(
      id: '',
      providerId: widget.booking.providerId,
      customerId: currentUser.uid,
      customerName: currentUser.name,
      rating: _rating,
      comment: _commentController.text,
      createdAt: Timestamp.now(),
    );

    try {
      await _reviewService.submitReview(newReview, widget.booking.id);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your review!')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leave a Review')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How was your experience with ${widget.booking.providerName}?'),
            const SizedBox(height: 8),
            Text(widget.booking.service, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                    onPressed: () => setState(() => _rating = index + 1),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Add a written review (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 32),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitReview,
                      child: const Text('Submit Review'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
