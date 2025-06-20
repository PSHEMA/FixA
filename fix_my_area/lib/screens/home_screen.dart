import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FixMyArea - Home'),
        automaticallyImplyLeading: false, // Removes back button
      ),
      body: const Center(
        // We will build this out later with service categories and a map view.
        // The user's location is critical here.
        child: Text(
          'Home Screen - Services & Map will be here!',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
