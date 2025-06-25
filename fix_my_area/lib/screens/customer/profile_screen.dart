import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/provider/edit_profile_screen.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fix_my_area/screens/customer/my_reviews_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: authService.getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Could not load profile data.'));
          }
          final user = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 50),
                    ),
                    const SizedBox(height: 12),
                    Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(user.email, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreen(user: user))),
              ),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('My Reviews'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyReviewsScreen())),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Language'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & FAQs'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.logout, color: Theme.of(context).primaryColor),
                title: Text('Sign Out', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                onTap: () => authService.signOut(),
              ),
            ],
          );
        },
      ),
    );
  }
}
