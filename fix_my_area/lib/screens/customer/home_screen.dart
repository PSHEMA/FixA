import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/customer/service_providers_screen.dart'; // Import new screen
import 'package:fix_my_area/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  Future<UserModel?>? _userDetailsFuture;

  final List<Map<String, dynamic>> serviceCategories = [
    {'name': 'Plumbing', 'icon': Icons.plumbing},
    {'name': 'Electrical', 'icon': Icons.electrical_services},
    {'name': 'Cleaning', 'icon': Icons.cleaning_services},
    {'name': 'Tutoring', 'icon': Icons.school},
    {'name': 'Painting', 'icon': Icons.format_paint},
    {'name': 'Moving', 'icon': Icons.local_shipping},
    {'name': 'Gardening', 'icon': Icons.local_florist},
    {'name': 'More', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    _userDetailsFuture = _authService.getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    // The main scaffold is now in main_scaffold_customer.dart
    // This screen no longer needs its own Scaffold or AppBar.
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        FutureBuilder<UserModel?>(
          future: _userDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return Text('Hi, ${snapshot.data!.name}!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold));
            }
            return const Text('Welcome!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
          },
        ),
        const SizedBox(height: 8),
        Text('What service do you need today?', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 24),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search for a service...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey[200],
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.9,
          ),
          itemCount: serviceCategories.length,
          itemBuilder: (context, index) {
            final category = serviceCategories[index];
            return GestureDetector(
              onTap: () {
                // ** NAVIGATION LOGIC HERE **
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceProvidersScreen(categoryName: category['name']),
                  ),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 5)],
                    ),
                    child: Icon(category['icon'], size: 32, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        const Text("Map view will be implemented here soon!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
