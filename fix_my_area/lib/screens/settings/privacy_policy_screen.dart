import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy for FixMyArea', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            const Text(
              'Effective Date: June 2025\n\n'
              '1. Introduction\n'
              'Welcome to FixMyArea. We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about our policy, or our practices with regards to your personal information, please contact us.\n\n'
              '2. Information We Collect\n'
              'We collect personal information that you voluntarily provide to us when you register on the application, express an interest in obtaining information about us or our products and services, when you participate in activities on the application or otherwise when you contact us. The personal information we collect includes: Name, Phone Number, Email Address, and for providers, service offerings and business location.\n\n'
              '3. How We Use Your Information\n'
              'We use personal information collected via our application for a variety of business purposes, including to facilitate account creation, manage user bookings, request feedback, and to enable user-to-user communications.\n\n'
              '4. Will Your Information Be Shared?\n'
              'We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations. Your contact information is shared between a customer and a provider only after a booking is confirmed to facilitate the service.\n\n'
            ),
          ],
        ),
      ),
    );
  }
}
