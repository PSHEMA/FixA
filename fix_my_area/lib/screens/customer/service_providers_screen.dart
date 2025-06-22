import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/customer/provider_profile_screen.dart'; // Import new screen
import 'package:fix_my_area/services/auth_service.dart';
import 'package:flutter/material.dart';

class ServiceProvidersScreen extends StatefulWidget {
  final String categoryName;

  const ServiceProvidersScreen({super.key, required this.categoryName});

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  final AuthService _authService = AuthService();
  late Future<List<UserModel>> _providersFuture;

  @override
  void initState() {
    super.initState();
    _providersFuture = _authService.getProvidersByCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _providersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No providers found for this category.', style: TextStyle(fontSize: 16)),
            );
          }

          final providers = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    backgroundImage: provider.photoUrl.isNotEmpty ? NetworkImage(provider.photoUrl) : null,
                    child: provider.photoUrl.isEmpty ? const Icon(Icons.person) : null,
                  ),
                  title: Text(provider.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Expert in ${provider.services.first} & more'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // ** NAVIGATION LOGIC HERE **
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProviderProfileScreen(provider: provider),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
