import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:flutter/material.dart';

class ManageAvailabilityScreen extends StatefulWidget {
  final UserModel provider;
  const ManageAvailabilityScreen({super.key, required this.provider});

  @override
  State<ManageAvailabilityScreen> createState() => _ManageAvailabilityScreenState();
}

class _ManageAvailabilityScreenState extends State<ManageAvailabilityScreen> {
  late Map<String, dynamic> _workingHours;
  late List<Timestamp> _daysOff;

  @override
  void initState() {
    super.initState();
    _workingHours = Map<String, dynamic>.from(widget.provider.workingHours);
    _daysOff = List<Timestamp>.from(widget.provider.daysOff);
  }

  Future<void> _addDayOff() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _daysOff.add(Timestamp.fromDate(picked));
      });
    }
  }

  Future<void> _saveAvailability() async {
    await AuthService().updateUserProfile({
      'workingHours': _workingHours,
      'daysOff': _daysOff,
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Availability updated!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveAvailability)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Set Your Days Off', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _daysOff.map((ts) => Chip(
              label: Text(MaterialLocalizations.of(context).formatShortDate(ts.toDate())),
              onDeleted: () => setState(() => _daysOff.remove(ts)),
            )).toList(),
          ),
          TextButton.icon(icon: const Icon(Icons.add), label: const Text('Add a Day Off'), onPressed: _addDayOff),
        ],
      ),
    );
  }
}
