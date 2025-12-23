import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_nearest_date_provider.dart';
import 'package:cheng_eng_3/core/controllers/point/total_points_provider.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/cart/cart_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_details_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/order/customer_order_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/product/customer_product_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/redeemed_reward/customer_redeemed_reward_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/reward/customer_reward_screen.dart';
import 'package:cheng_eng_3/ui/screens/profile_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/towing/towing_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/vehicle/vehicle_screen.dart';
import 'package:cheng_eng_3/ui/widgets/cart_icon.dart';
import 'package:cheng_eng_3/ui/widgets/maintenance_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerHome extends ConsumerWidget {
  const CustomerHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);
    final user = userState.value;

    // Handle loading or null user gracefully in UI while listener redirects
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user found')),
      );
    }

    final totalPoints = ref.watch(totalPointsProvider(user.id));
    final nearestMaintenance = ref.watch(maintenanceByNearestDateProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh data when user pulls down
            ref.invalidate(totalPointsProvider(user.id));
            ref.invalidate(maintenanceByNearestDateProvider);
            // Optional: wait a bit to show the loading spinner
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Home',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Navigation buttons
                Row(
                  children: [
                    Expanded(
                      child: _navButton(
                        context,
                        'Profile',
                        const ProfileScreen(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _navButton(
                        context,
                        'Vehicles',
                        const VehicleScreen(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _navButton(
                        context,
                        'Towing',
                        const TowingScreen(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _navButton(
                        context,
                        'Products',
                        const CustomerProductScreen(),
                      ),
                    ),
                    Expanded(
                      child: _navButton(
                        context,
                        'My Rewards',
                        const CustomerRedeemedRewardScreen(),
                      ),
                    ),
                    Expanded(
                      child: _navButton(
                        context,
                        'Booking',
                        const CustomerBookingScreen(),
                      ),
                    ),
                    Expanded(
                      child: _navButton(
                        context,
                        'Orders',
                        const CustomerOrderScreen(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Second Row for Cart & Rewards (Optional cleanup to prevent overcrowding)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CustomerRewardScreen(),
                            ),
                          );
                        },
                        child: const Text('Rewards'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      ),
                      child: CartIconBadge(),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Point Dashboard
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: totalPoints.when(
                    data: (total) => _pointDashboard(
                      context: context,
                      totalPoints: total,
                    ),
                    // Handle error gracefully with 0 points or error text
                    error: (error, _) =>
                        _pointDashboard(context: context, totalPoints: 0),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Maintenance Notification
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: nearestMaintenance.when(
                    data: (list) {
                      // Assuming your provider returns an object with a .maintenances list
                      final nearest = list.maintenances;
                      return _maintenanceNotification(nearest, context);
                    },
                    error: (error, stackTrace) => Center(
                      child: Text("Error loading maintenance: $error"),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for cleaner buttons
  Widget _navButton(BuildContext context, String label, Widget screen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 5), // Prevent overflow
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _pointDashboard({
    required BuildContext context,
    required int totalPoints,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Loyalty Points:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              Text(
                '$totalPoints pts',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CustomerRewardScreen(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'View Rewards',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        // Image with error handling
        Positioned(
          right: 5,
          bottom: -17,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.18,
            child: Image.asset(
              'assets/images/reward.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _maintenanceNotification(
    List<Maintenance> nearestMaintenance,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Maintenance',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        nearestMaintenance.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('No upcoming maintenance'),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: nearestMaintenance.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final m = nearestMaintenance[index];
                  return MaintenanceListItem(
                    maintenance: m,
                    tapAction: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MaintenanceDetailsScreen(
                          maintenance: m,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
