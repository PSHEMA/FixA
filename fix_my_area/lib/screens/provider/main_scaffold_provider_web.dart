import 'package:proci/screens/provider/dashboard_screen.dart';
import 'package:proci/screens/provider/jobs_screen.dart';
import 'package:proci/screens/provider/messages_screen.dart';
import 'package:proci/screens/provider/profile_screen.dart';
import 'package:proci/services/auth_service.dart';
import 'package:flutter/material.dart';

class MainScaffoldProviderWeb extends StatefulWidget {
  const MainScaffoldProviderWeb({super.key});

  @override
  State<MainScaffoldProviderWeb> createState() => _MainScaffoldProviderWebState();
}

class _MainScaffoldProviderWebState extends State<MainScaffoldProviderWeb> {
  int _selectedIndex = 0;
  bool _isExtended = false;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    JobsScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  static const List<String> _appBarTitles = ['Dashboard', 'My Jobs', 'Messages', 'My Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _isExtended = !_isExtended;
            });
          },
        ),
        actions: [
          const Center(child: Text("Provider Dashboard")),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () {
              AuthService().signOut();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.none,
            extended: _isExtended,
            leading: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Proxi',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.work_outline),
                selectedIcon: Icon(Icons.work),
                label: Text('Jobs'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.chat_bubble_outline),
                selectedIcon: Icon(Icons.chat_bubble),
                label: Text('Messages'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
