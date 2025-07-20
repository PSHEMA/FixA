import 'package:proci/models/notification_model.dart';
import 'package:proci/services/auth_service.dart';
import 'package:proci/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = AuthService().currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: userId == null
          ? const Center(child: Text('Please log in.'))
          : StreamBuilder<List<NotificationModel>>(
              stream: NotificationService().getNotifications(userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                if (snapshot.data!.isEmpty) return const Center(child: Text('You have no notifications.'));
                
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final notification = snapshot.data![index];
                    return ListTile(
                      leading: CircleAvatar(child: _getIconForType(notification.type)),
                      title: Text(notification.title, style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold)),
                      subtitle: Text(notification.body),
                      trailing: Text(DateFormat.yMd().format(notification.createdAt.toDate())),
                      onTap: () {
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  Icon _getIconForType(String? type) {
    switch (type) {
      case 'booking': return const Icon(Icons.calendar_today);
      case 'chat': return const Icon(Icons.message);
      case 'review': return const Icon(Icons.star);
      default: return const Icon(Icons.notifications);
    }
  }
}
