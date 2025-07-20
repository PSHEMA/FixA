import 'package:proci/screens/onboarding/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _hasAgreed = false;

  Future<void> _onContinue() async {
    if (!_hasAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the terms and conditions to continue.')),
      );
      return;
    }
    // Mark that the user has seen the full onboarding
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    
    // Navigate to the Welcome Screen, replacing this screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: const [
                    TextSpan(text: 'Welcome to Proci. By using our application, you agree to these terms. \n\n'),
                    TextSpan(text: '1. Service Agreement: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Proci is a platform to connect Customers with Service Providers. We are not a party to any service agreement between users. We do not guarantee the quality, safety, or legality of the services provided.\n\n'),
                    TextSpan(text: '2. User Conduct: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'You agree to provide accurate information and to treat other users with respect. Harassment, spam, and fraudulent activity are strictly prohibited and will result in account termination.\n\n'),
                    TextSpan(text: '3. Reviews: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Reviews must be truthful and based on a completed service. We reserve the right to remove reviews that violate our policies.\n\n'),
                     TextSpan(text: '4. Data Privacy: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Your privacy is important to us. We collect and use your data as described in our Privacy Policy to facilitate services on the platform.'),
                  ],
                ),
              ),
            ),
          ),
          // Agreement Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, -2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _hasAgreed,
                      onChanged: (bool? value) {
                        setState(() {
                          _hasAgreed = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text('I have read and agree to the Terms & Conditions.'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _hasAgreed ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
