import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fix_my_area/screens/home_screen.dart';
import 'package:fix_my_area/screens/login_screen.dart';
import 'package:fix_my_area/services/auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder listens to the authentication state
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        // If the snapshot is still waiting for data, show a loading spinner
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // If the user is logged in (snapshot has data)
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // If the user is not logged in (snapshot has no data)
        return const LoginScreen();
      },
    );
  }
}

