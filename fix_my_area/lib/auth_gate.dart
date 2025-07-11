import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/admin/admin_panel_screen.dart';
import 'package:fix_my_area/screens/customer/main_scaffold_customer.dart';
import 'package:fix_my_area/screens/provider/main_scaffold_provider.dart';
import 'package:fix_my_area/screens/login_screen.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/screens/provider/onboarding_services_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // User is logged in, now check their role
        return FutureBuilder<bool>(
          // First, check if they are an admin
          future: authService.isAdmin(),
          builder: (context, adminSnapshot) {
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            // If they are an admin, go to the admin panel
            if (adminSnapshot.data == true) {
              return const AdminPanelScreen();
            }

            // If not an admin, check their user details like before
            return FutureBuilder<UserModel?>(
              future: authService.getUserDetails(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (userSnapshot.hasError || !userSnapshot.hasData) {
                  return const LoginScreen();
                }
                final user = userSnapshot.data!;
                // ROLE-BASED REDIRECTION
                if (user.role == 'provider') {
                  if (user.services.isEmpty) {
                    return const OnboardingServicesScreen();
                  }
                  return const MainScaffoldProvider();
                } else {
                  return const MainScaffoldCustomer();
                }
              },
            );
          },
        );
      },
    );
  }
}