import 'package:fix_my_area/models/review_model.dart';
import 'package:fix_my_area/screens/customer/widgets/review_card.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/services/review_service.dart';
import 'package:flutter/material.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? customerId = AuthService().currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('My Reviews')),
      body: customerId == null
          ? const Center(child: Text('Please log in.'))
          : StreamBuilder<List<ReviewModel>>(
              // We need a new function in ReviewService for this
              stream: ReviewService().getReviewsForCustomer(customerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('You have not written any reviews.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => ReviewCard(review: snapshot.data![index]),
                );
              },
            ),
    );
  }
}
