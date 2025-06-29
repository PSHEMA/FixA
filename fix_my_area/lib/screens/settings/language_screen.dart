import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Settings')),
      body: ListView(
        children: [
          RadioListTile<String>(
            title: const Text('English'),
            value: 'English',
            groupValue: _selectedLanguage,
            onChanged: (value) => setState(() => _selectedLanguage = value!),
          ),
          RadioListTile<String>(
            title: const Text('Kinyarwanda'),
            value: 'Kinyarwanda',
            groupValue: _selectedLanguage,
            onChanged: (value) => setState(() => _selectedLanguage = value!),
          ),
        ],
      ),
    );
  }
}
