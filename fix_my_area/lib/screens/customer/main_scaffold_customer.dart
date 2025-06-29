import 'package:fix_my_area/screens/customer/bookings_screen.dart';
import 'package:fix_my_area/screens/customer/home_screen.dart';
import 'package:fix_my_area/screens/customer/messages_screen.dart';
import 'package:fix_my_area/screens/customer/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScaffoldCustomer extends StatefulWidget {
  const MainScaffoldCustomer({super.key});

  @override
  State<MainScaffoldCustomer> createState() => _MainScaffoldCustomerState();
}

class _MainScaffoldCustomerState extends State<MainScaffoldCustomer> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BookingsScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() { _selectedIndex = index; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // THE FIX: Removing the unnecessary Center widget solves the layout bug.
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), activeIcon: Icon(Icons.list_alt), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey, // Add this for better contrast
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
        onTap: _onItemTapped,
      ),
    );
  }
}
