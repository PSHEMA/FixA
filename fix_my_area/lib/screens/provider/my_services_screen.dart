import 'package:fix_my_area/models/user_model.dart';
import 'package:flutter/material.dart';

class MyServicesScreen extends StatelessWidget {
  final UserModel provider;
  const MyServicesScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Service',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add/Edit feature coming soon!'))
              );
            },
          ),
        ],
      ),
      body: provider.services.isEmpty
          ? const Center(child: Text('You have not added any services yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: provider.services.length,
              itemBuilder: (context, index) {
                final service = provider.services[index];
                return Card(
                  child: ListTile(
                    title: Text(service, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.edit_note),
                  ),
                );
              },
            ),
    );
  }
}
