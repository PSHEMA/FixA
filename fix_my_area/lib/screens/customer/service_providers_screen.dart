import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/customer/provider_profile_screen.dart';
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
    _loadProviders();
  }
  
  void _loadProviders() {
    setState(() {
      _providersFuture = _authService.getProvidersByCategory(widget.categoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: FutureBuilder<List<UserModel>>(
        future: _providersFuture,
        builder: (context, snapshot) {
          // 1. While waiting for data, show a loading spinner.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. THE FIX: If there's an error, display it instead of a blank screen.
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: ${snapshot.error}\n\nThis usually means a Firestore index is missing. Please create it in your Firebase console.'),
              ),
            );
          }

          // 3. If there's no data, show a clear message.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No providers found for this category yet.'));
          }
          
          // 4. If everything is successful, show the list.
          final providers = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: provider.photoUrl.isNotEmpty ? NetworkImage(provider.photoUrl) : null,
                    child: provider.photoUrl.isEmpty ? const Icon(Icons.person) : null,
                  ),
                  title: Text(provider.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Location: ${provider.sector}, ${provider.district}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderProfileScreen(provider: provider))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
