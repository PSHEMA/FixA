import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fix_my_area/models/user_model.dart';
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
        // User is not logged in
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // User is logged in, now check their role
        return FutureBuilder<UserModel?>(
          future: authService.getUserDetails(),
          builder: (context, userSnapshot) {
            // Waiting for user details
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            // Error fetching details or no user data
            if (userSnapshot.hasError || !userSnapshot.hasData) {
              // You might want to log them out or show an error screen
              return const LoginScreen();
            }

            final user = userSnapshot.data!;

            // ROLE-BASED REDIRECTION
            if (user.role == 'provider') {
              // If provider hasn't set services yet, send them to onboarding
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
  }
}
