import 'package:fix_my_area/data/kigali_locations.dart';
import 'package:fix_my_area/screens/provider/main_scaffold_provider.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:flutter/material.dart';

class OnboardingLocationScreen extends StatefulWidget {
  const OnboardingLocationScreen({super.key});
  @override
  State<OnboardingLocationScreen> createState() => _OnboardingLocationScreenState();
}

class _OnboardingLocationScreenState extends State<OnboardingLocationScreen> {
  String? _selectedDistrict;
  String? _selectedSector;
  List<String> _sectors = [];

  void _onDistrictChanged(String? newValue) {
    setState(() {
      _selectedDistrict = newValue;
      _selectedSector = null; // Reset sector when district changes
      _sectors = kigaliLocations[newValue!]!;
    });
  }

  Future<void> _finishOnboarding() async {
    if (_selectedDistrict == null || _selectedSector == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select your location.')));
      return;
    }
    await AuthService().updateUserProfile({
      'district': _selectedDistrict,
      'sector': _selectedSector,
    });
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScaffoldProvider()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 2: Business Location')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              hint: const Text('Select District'),
              items: kigaliLocations.keys.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: _onDistrictChanged,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedSector,
              hint: const Text('Select Sector'),
              items: _sectors.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _selectedSector = val),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _finishOnboarding,
              child: const Text('Finish Setup'),
            ),
          ],
        ),
      ),
    );
  }
}
