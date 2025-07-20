import 'package:proci/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Proci')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.build_circle, size: 80, color: AppTheme.primaryColor),
              const SizedBox(height: 20),
              Text('Proci', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 10),
              const Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              const Text(
                'Connecting communities with trusted local service providers in Kigali.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              const Text('Developed as a Capstone Project by:', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              const Text('Placide SHEMA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('BSc. in Software Engineering, ALU', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
