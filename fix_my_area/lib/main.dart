import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:proci/theme/app_theme.dart';
import 'package:proci/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FixMyAreaApp());
}

class FixMyAreaApp extends StatelessWidget {
  const FixMyAreaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proci',
      theme: AppTheme.theme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
