import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fix_my_area/auth_gate.dart';
import 'package:fix_my_area/theme/app_theme.dart';

// The main function must be async to wait for Firebase to initialize.
Future<void> main() async {
  // These two lines are the crucial setup for Firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Now we can run the app.
  runApp(const FixMyAreaApp());
}

class FixMyAreaApp extends StatelessWidget {
  const FixMyAreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixMyArea',
      theme: AppTheme.theme,
      // And this is the second critical fix: using AuthGate as the home.
      // AuthGate will now correctly manage showing the LoginScreen or HomeScreen.
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
