import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:proci/models/user_model.dart';
import 'package:proci/screens/admin/admin_panel_screen.dart';
import 'package:proci/screens/customer/main_scaffold_customer.dart';
import 'package:proci/screens/provider/main_scaffold_provider.dart';
import 'package:proci/screens/provider/main_scaffold_provider_web.dart';
import 'package:proci/screens/login_screen.dart';
import 'package:proci/services/auth_service.dart';
import 'package:proci/screens/provider/onboarding_services_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        return FutureBuilder<bool>(
          future: authService.isAdmin(),
          builder: (context, adminSnapshot) {
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (adminSnapshot.data == true) {
              return const AdminPanelScreen();
            }

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
                
                // ROLE-BASED REDIRECTION WITH PLATFORM-AWARE LOGIC
                if (user.role == 'provider') {
                  if (user.services.isEmpty) {
                    return const OnboardingServicesScreen();
                  }
                  
                  // ** PLATFORM-AWARE LOGIC FOR PROVIDERS **
                  if (kIsWeb) {
                    return const MainScaffoldProviderWeb();
                  } else {
                    return const MainScaffoldProvider();
                  }
                } else {
                  // Customers always get the mobile scaffold.
                  // If a customer tries to log in on the web, we show the mobile view.
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