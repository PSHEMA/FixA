import 'package:fix_my_area/models/booking_model.dart';
import 'package:fix_my_area/models/user_model.dart';
import 'package:fix_my_area/screens/provider/jobs_screen.dart';
import 'package:fix_my_area/screens/provider/manage_services_screen.dart';
import 'package:fix_my_area/screens/provider/my_reviews_screen.dart';
import 'package:fix_my_area/services/auth_service.dart';
import 'package:fix_my_area/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final BookingService bookingService = BookingService();

    return Scaffold(
      appBar: AppBar(title: const Text('My Dashboard')),
      body: FutureBuilder<UserModel?>(
        future: authService.getUserDetails(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) return const Center(child: CircularProgressIndicator());
          final provider = userSnapshot.data!;
          
          return StreamBuilder<List<BookingModel>>(
            stream: bookingService.getBookingsForProvider(provider.uid),
            builder: (context, bookingSnapshot) {
              if (!bookingSnapshot.hasData) return const Center(child: CircularProgressIndicator());
              
              final bookings = bookingSnapshot.data!;
              final double totalEarnings = bookings.where((b) => b.status == 'completed').fold(0, (sum, item) => sum + item.price);
              final int jobsToday = bookings.where((b) => DateFormat.yMd().format(b.bookingTime) == DateFormat.yMd().format(DateTime.now())).length;
              final int pendingJobs = bookings.where((b) => b.status == 'pending').length;

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text('Welcome back, ${provider.name}!', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 24),
                  _buildStatCard('Jobs Today', jobsToday.toString(), Icons.work_history, Colors.orange),
                  _buildStatCard('Total Earnings', '${NumberFormat.currency(symbol: 'RWF ', decimalDigits: 0).format(totalEarnings)}', Icons.attach_money, Colors.green),
                  const SizedBox(height: 24),
                  _buildDashboardAction(context, title: 'My Jobs', subtitle: 'View and manage job requests', icon: Icons.list_alt, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JobsScreen())), trailing: pendingJobs > 0 ? Badge(label: Text('$pendingJobs')) : null),
                  _buildDashboardAction(context, title: 'My Services', subtitle: 'Manage the services you offer', icon: Icons.construction, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageServicesScreen(currentServices: provider.services)))),
                  _buildDashboardAction(context, title: 'My Reviews', subtitle: 'See what customers are saying', icon: Icons.star_border, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MyReviewsScreen(providerId: provider.uid)))),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // ... (helpers remain the same)
   Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],)
          ],
        ),
      ),
    );
  }
  Widget _buildDashboardAction(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap, Widget? trailing}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
