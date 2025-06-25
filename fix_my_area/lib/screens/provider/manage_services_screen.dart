import 'package:fix_my_area/services/auth_service.dart';
import 'package:flutter/material.dart';

class ManageServicesScreen extends StatefulWidget {
  final List<String> currentServices;
  const ManageServicesScreen({super.key, required this.currentServices});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  // This would typically come from your database, but for now, it's a master list.
  final List<String> _allPossibleServices = [
    'Plumbing', 'Electrical', 'Cleaning', 'Tutoring', 'Painting', 
    'Moving', 'Gardening', 'Appliance Repair', 'Carpentry', 'Landscaping'
  ];

  late Set<String> _selectedServices;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedServices = widget.currentServices.toSet();
  }
  
  Future<void> _saveServices() async {
    setState(() => _isLoading = true);
    try {
      await AuthService().updateUserProfile({'services': _selectedServices.toList()});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Services updated successfully!'))
      );
      Navigator.of(context).pop();
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update services: ${e.toString()}'))
      );
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage My Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _saveServices,
          )
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : ListView.builder(
            itemCount: _allPossibleServices.length,
            itemBuilder: (context, index) {
              final service = _allPossibleServices[index];
              final isSelected = _selectedServices.contains(service);
              return SwitchListTile(
                title: Text(service),
                value: isSelected,
                onChanged: (bool value) {
                  setState(() {
                    if (value) {
                      _selectedServices.add(service);
                    } else {
                      _selectedServices.remove(service);
                    }
                  });
                },
              );
            },
          ),
    );
  }
}
