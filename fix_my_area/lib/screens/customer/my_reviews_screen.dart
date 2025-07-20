import 'package:proci/models/review_model.dart';
import 'package:proci/screens/customer/widgets/review_card.dart';
import 'package:proci/services/auth_service.dart';
import 'package:proci/services/review_service.dart';
import 'package:flutter/material.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? customerId = AuthService().currentUser?.uid;
    
    // Debug: Print the customer ID
    print('Current customer ID: $customerId');
    
    return Scaffold(
      appBar: AppBar(title: const Text('My Reviews')),
      body: customerId == null
          ? const Center(child: Text('Please log in.'))
          : StreamBuilder<List<ReviewModel>>(
              stream: ReviewService().getReviewsForCustomer(customerId),
              builder: (context, snapshot) {
                // debug information
                print('Stream state: ${snapshot.connectionState}');
                print('Has data: ${snapshot.hasData}');
                print('Data length: ${snapshot.data?.length ?? 0}');
                print('Has error: ${snapshot.hasError}');
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const MyReviewsScreen()),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final reviews = snapshot.data;
                if (reviews == null || reviews.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.rate_review_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'You have not written any reviews.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) => ReviewCard(review: reviews[index]),
                );
              },
            ),
    );
  }
}