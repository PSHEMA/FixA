import 'package:proci/models/user_model.dart';
import 'package:proci/services/auth_service.dart';
import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel - Verification'),
        actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () => authService.signOut())],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: authService.getUnverifiedProviders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No providers awaiting verification.'));
          }
          final providers = snapshot.data!;
          return ListView.builder(
            itemCount: providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(backgroundImage: NetworkImage(provider.photoUrl)),
                  title: Text(provider.name),
                  subtitle: Text(provider.email),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await authService.verifyProvider(provider.uid);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${provider.name} has been verified.'))
                      );
                    },
                    child: const Text('Verify'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
