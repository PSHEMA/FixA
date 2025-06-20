import 'package:flutter/material.dart';
import 'package:fix_my_area/screens/login_screen.dart';
import 'package:fix_my_area/theme/app_theme.dart';

// Import Firebase Core and the generated options file
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Make the main function async to await Firebase initialization
Future<void> main() async {
  // Ensure that Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FixMyAreaApp());
}

// This widget is the root of your application.
class FixMyAreaApp extends StatelessWidget {
  const FixMyAreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixMyArea',
      theme: AppTheme.theme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
