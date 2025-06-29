import 'package:fix_my_area/auth_gate.dart';
import 'package:fix_my_area/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(Icons.build_circle_outlined, size: 100, color: Theme.of(context).primaryColor),
              const SizedBox(height: 20),
              const Text('Welcome to FixMyArea', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('Your one-stop solution for trusted local services.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                child: const Text('I\'m New, Create Account'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                 onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthGate())),
                child: const Text('I Already Have an Account'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
