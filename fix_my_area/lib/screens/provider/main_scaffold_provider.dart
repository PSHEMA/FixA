import 'package:fix_my_area/screens/provider/dashboard_screen.dart';
import 'package:fix_my_area/screens/provider/jobs_screen.dart';
import 'package:fix_my_area/screens/provider/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScaffoldProvider extends StatefulWidget {
  const MainScaffoldProvider({super.key});

  @override
  State<MainScaffoldProvider> createState() => _MainScaffoldProviderState();
}

class _MainScaffoldProviderState extends State<MainScaffoldProvider> {
  int _selectedIndex = 0;

  // We'll add the "My Services" screen later
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    JobsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), activeIcon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed, // Good for 3+ items
        onTap: _onItemTapped,
      ),
    );
  }
}
