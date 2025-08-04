import 'package:proci/screens/provider/onboarding_location_screen.dart';
import 'package:proci/services/auth_service.dart';
import 'package:flutter/material.dart';

class OnboardingServicesScreen extends StatefulWidget {
  const OnboardingServicesScreen({super.key});

  @override
  State<OnboardingServicesScreen> createState() => _OnboardingServicesScreenState();
}

class _OnboardingServicesScreenState extends State<OnboardingServicesScreen> {
  final List<String> _allPossibleServices = [
    'Plumbing', 'Electrical', 'Cleaning', 'Tutoring', 'Painting', 
    'Moving', 'Gardening', 'Appliance Repair', 'Carpentry', 'Landscaping'
  ];
  final Set<String> _selectedServices = {};

  void _onNext() {
    if (_selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one service.')));
      return;
    }
    AuthService().updateUserProfile({'services': _selectedServices.toList()});
    Navigator.push(context, MaterialPageRoute(builder: (_) => const OnboardingLocationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 1: Your Services')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Select all the services you offer. You can change these later.', style: TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _allPossibleServices.length,
              itemBuilder: (context, index) {
                final service = _allPossibleServices[index];
                final isSelected = _selectedServices.contains(service);
                return CheckboxListTile(
                  title: Text(service),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedServices.add(service);
                      } else {
                        _selectedServices.remove(service);
                      }
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _onNext,
              child: const Text('Next: Set Location'),
            ),
          )
        ],
      ),
    );
  }
}
