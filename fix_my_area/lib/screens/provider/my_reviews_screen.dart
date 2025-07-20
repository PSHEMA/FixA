import 'package:proci/models/review_model.dart';
import 'package:proci/screens/customer/widgets/review_card.dart';
import 'package:proci/services/review_service.dart';
import 'package:flutter/material.dart';

class MyReviewsScreen extends StatelessWidget {
  final String providerId;
  const MyReviewsScreen({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Customer Reviews')),
      body: StreamBuilder<List<ReviewModel>>(
        stream: ReviewService().getReviewsForProvider(providerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have no reviews yet.'));
          }
          final reviews = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ReviewCard(review: reviews[index]);
            },
          );
        },
      ),
    );
  }
}
