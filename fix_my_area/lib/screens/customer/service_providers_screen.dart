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
  int _selectedFilterIndex = 0; // 0: All, 1: Top Rated

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }
  
  void _loadProviders() {
    setState(() {
      // TODO: Add different query logic for 'Top Rated' and 'Nearby'
      _providersFuture = _authService.getProvidersByCategory(widget.categoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: FutureBuilder<List<UserModel>>(
              future: _providersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No providers found.'));
                
                final providers = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: providers.length,
                  itemBuilder: (context, index) {
                    final provider = providers[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: const Icon(Icons.person)),
                        title: Text(provider.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Expert in ${provider.services.first} & more'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProviderProfileScreen(provider: provider))),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedFilterIndex == 0,
            onSelected: (selected) => setState(() => _selectedFilterIndex = 0),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Top Rated'),
            selected: _selectedFilterIndex == 1,
            onSelected: (selected) {
              setState(() => _selectedFilterIndex = 1);
              // In a real app, you'd call a different service method here
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filtering by rating coming soon!')));
            },
          ),
        ],
      ),
    );
  }
}
