import 'package:proci/models/booking_model.dart';
import 'package:proci/models/review_model.dart';
import 'package:proci/models/user_model.dart';
import 'package:proci/screens/provider/jobs_screen.dart';
import 'package:proci/screens/provider/manage_services_screen.dart';
import 'package:proci/screens/provider/my_reviews_screen.dart';
import 'package:proci/services/auth_service.dart';
import 'package:proci/services/booking_service.dart';
import 'package:proci/services/review_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proci/screens/provider/manage_availability_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final BookingService bookingService = BookingService();
    final ReviewService reviewService = ReviewService();

    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: authService.getUserDetails(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final provider = userSnapshot.data!;
          
          return Column(
            children: [
              if (!provider.isVerified)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  color: Colors.amber.shade700,
                  child: const Text(
                    'Your account is awaiting verification. You are not visible to customers yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(
                child: StreamBuilder<List<BookingModel>>(
                  stream: bookingService.getBookingsForProvider(provider.uid),
                  builder: (context, bookingSnapshot) {
                    if (!bookingSnapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    
                    final bookings = bookingSnapshot.data!;
                    final double totalEarnings = bookings
                        .where((b) => b.status == 'completed')
                        .fold(0, (sum, item) => sum + item.price);
                    final int jobsToday = bookings
                        .where((b) => DateFormat.yMd().format(b.bookingTime) == 
                            DateFormat.yMd().format(DateTime.now()))
                        .length;
                    final int pendingJobs = bookings
                        .where((b) => b.status == 'pending')
                        .length;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Header
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF1B5E20).withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFF1B1B1B).withOpacity(0.7),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  provider.name,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1B1B1B),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Here\'s what\'s happening with your business today',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF1B1B1B).withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // INTEGRATED RATING CARD - NEW ADDITION
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: StreamBuilder<List<ReviewModel>>(
                              stream: reviewService.getReviewsForProvider(provider.uid),
                              builder: (context, reviewSnapshot) {
                                int reviewCount = 0;
                                double avgRating = 0.0;
                                if (reviewSnapshot.hasData && reviewSnapshot.data!.isNotEmpty) {
                                  reviewCount = reviewSnapshot.data!.length;
                                  avgRating = reviewSnapshot.data!.map((r) => r.rating).reduce((a, b) => a + b) / reviewCount;
                                }
                                return _buildRatingCard(avgRating, reviewCount);
                              }
                            ),
                          ),

                          const SizedBox(height: 24),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Jobs Today',
                                    jobsToday.toString(),
                                    Icons.work_history_outlined,
                                    const Color(0xFFFF8F00),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Total Earnings',
                                    NumberFormat.currency(
                                      symbol: 'RWF ',
                                      decimalDigits: 0,
                                    ).format(totalEarnings),
                                    Icons.attach_money_outlined,
                                    const Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Quick Actions',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1B1B1B),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                _buildDashboardAction(
                                  context,
                                  title: 'My Jobs',
                                  subtitle: 'View and manage job requests',
                                  icon: Icons.list_alt_outlined,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const JobsScreen(),
                                    ),
                                  ),
                                  trailing: pendingJobs > 0
                                      ? Badge(
                                          label: Text('$pendingJobs'),
                                          backgroundColor: Colors.red,
                                          textColor: const Color(0xFFFFFFFF),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 12),
                                _buildDashboardAction(
                                  context,
                                  title: 'My Services',
                                  subtitle: 'Manage the services you offer',
                                  icon: Icons.construction_outlined,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ManageServicesScreen(
                                        currentServices: provider.services,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildDashboardAction(
                                  context,
                                  title: 'My Reviews',
                                  subtitle: 'See what customers are saying',
                                  icon: Icons.star_outline,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MyReviewsScreen(
                                        providerId: provider.uid,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildDashboardAction(
                                  context,
                                  title: 'Manage Availability',
                                  subtitle: 'Set your working hours',
                                  icon: Icons.access_time_outlined,
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageAvailabilityScreen(provider: provider))),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // NEW RATING CARD WIDGET - Integrated from the first file but styled to match your design
  Widget _buildRatingCard(double rating, int reviewCount) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.star,
              size: 24,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Public Rating',
                  style: TextStyle(
                    color: const Color(0xFF1B1B1B).withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reviewCount > 0 
                      ? '${rating.toStringAsFixed(1)} out of 5'
                      : 'No ratings yet',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B1B1B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reviewCount > 0 
                      ? 'Based on $reviewCount review${reviewCount == 1 ? '' : 's'}'
                      : 'Start getting reviews from customers',
                  style: TextStyle(
                    color: const Color(0xFF1B1B1B).withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF1B1B1B).withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B1B1B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardAction(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: const Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: const Color(0xFF1B1B1B).withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing ??
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: const Color(0xFF1B1B1B).withOpacity(0.5),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}