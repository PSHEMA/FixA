import 'package:proci/models/notification_model.dart';
import 'package:proci/screens/customer/bookings_screen.dart';
import 'package:proci/screens/customer/home_screen.dart';
import 'package:proci/screens/customer/messages_screen.dart';
import 'package:proci/screens/customer/profile_screen.dart';
import 'package:proci/screens/notifications/notifications_screen.dart';
import 'package:proci/services/auth_service.dart';
import 'package:proci/services/notification_service.dart';
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
    final String? userId = AuthService().currentUser?.uid;
    final NotificationService notificationService = NotificationService();
    final List<String> appBarTitles = ['Proci', 'My Bookings', 'Messages', 'My Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[_selectedIndex]),
        automaticallyImplyLeading: false,
        elevation: _selectedIndex == 0 ? 0 : 4,
        backgroundColor: _selectedIndex == 0 ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          StreamBuilder<List<NotificationModel>>(
            stream: userId != null ? notificationService.getNotifications(userId) : null,
            builder: (context, snapshot) {
              final unreadCount = snapshot.data?.where((n) => !n.isRead).length ?? 0;
              return IconButton(
                icon: Badge(
                  label: Text('$unreadCount'),
                  isLabelVisible: unreadCount > 0,
                  child: const Icon(Icons.notifications_outlined),
                ),
                onPressed: () {
                  if (userId != null) {
                    notificationService.markAllAsRead(userId);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                  }
                },
              );
            },
          ),
        ],
      ),
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
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
