import 'package:proci/models/notification_model.dart';
import 'package:proci/screens/notifications/notifications_screen.dart';
import 'package:proci/screens/provider/dashboard_screen.dart';
import 'package:proci/screens/provider/jobs_screen.dart';
import 'package:proci/screens/provider/messages_screen.dart';
import 'package:proci/screens/provider/profile_screen.dart';
import 'package:proci/services/auth_service.dart';
import 'package:proci/services/notification_service.dart';
import 'package:flutter/material.dart';

class MainScaffoldProvider extends StatefulWidget {
  const MainScaffoldProvider({super.key});

  @override
  State<MainScaffoldProvider> createState() => _MainScaffoldProviderState();
}

class _MainScaffoldProviderState extends State<MainScaffoldProvider> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    JobsScreen(),
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
    final List<String> appBarTitles = ['Dashboard', 'My Jobs', 'Messages', 'My Profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[_selectedIndex]),
        automaticallyImplyLeading: false,
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
           if (_selectedIndex == 3)
             IconButton(icon: Icon(Icons.logout), onPressed: () => AuthService().signOut()),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), activeIcon: Icon(Icons.work), label: 'Jobs'),
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
