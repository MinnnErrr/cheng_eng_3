import 'dart:math';

import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_nearest_date_provider.dart';
import 'package:cheng_eng_3/core/controllers/point/nearest_expiry_point_provider.dart';
import 'package:cheng_eng_3/core/controllers/point/total_points_provider.dart';
import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:cheng_eng_3/ui/screens/customer/booking/customer_booking_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/order/customer_order_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/product/customer_product_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/redeemed_reward/customer_redeemed_reward_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/reward/customer_reward_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/towing/towing_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/vehicle/vehicle_screen.dart';
import 'package:cheng_eng_3/ui/widgets/customer_home_maintenance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _MenuItem {
  final String label;
  final IconData icon;
  final Widget screen;

  _MenuItem(this.label, this.icon, this.screen);
}

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
    final profileState = ref.watch(profileProvider);

    String name = profileState.isLoading
        ? 'Loading...'
        : (profileState.value == null ? 'User' : profileState.value!.name);

    final expiryPointsInfo = ref.watch(nearestExpiryProvider(user.id));

    String? expiryPoints = expiryPointsInfo.when(
      data: (info) {
        if (info == null) {
          return null;
        } else {
          return 'Expiring: ${info.points} pts';
        }
      },
      loading: () => null,
      error: (error, stackTrace) => null,
    );

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh data when user pulls down
            ref.invalidate(totalPointsProvider(user.id));
            ref.invalidate(maintenanceByNearestDateProvider);
            ref.invalidate(profileProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                Text(
                  'Hello, $name',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 20),

                // Point Dashboard
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: totalPoints.when(
                    data: (total) => _pointDashboard(
                      context: context,
                      totalPoints: total,
                      expiryPoints: expiryPoints,
                    ),
                    // Handle error gracefully with 0 points or error text
                    error: (error, _) => _pointDashboard(
                      context: context,
                      totalPoints: 0,
                      expiryPoints: null,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "Services",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 15),
                _buildMenuGrid(context), // 👈 Replaced the Row with this Grid

                const SizedBox(height: 30),

                // Maintenance Notification
                nearestMaintenance.when(
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    // List of menu items to make code cleaner
    final menuItems = [
      _MenuItem('Vehicles', Icons.directions_car, const VehicleScreen()),
      _MenuItem('Booking', Icons.calendar_month, const CustomerBookingScreen()),
      _MenuItem('Towing', Icons.car_crash, const TowingScreen()),
      _MenuItem('Products', Icons.shopping_bag, const CustomerProductScreen()),
      _MenuItem('Orders', Icons.receipt_long, const CustomerOrderScreen()),
      _MenuItem('Rewards', Icons.card_giftcard, const CustomerRewardScreen()),
    ];

    return GridView.builder(
      shrinkWrap: true, // Vital: Makes grid take only needed space
      physics:
          const NeverScrollableScrollPhysics(), // Disable grid scrolling, let parent scroll
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 👈 3 Buttons per row
        crossAxisSpacing: 30,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return _menuButton(context, menuItems[index]);
      },
    );
  }

  Widget _menuButton(BuildContext context, _MenuItem item) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        // The Icon Circle/Square
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => item.screen),
          ),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              // Use a soft grey background for the button...
              color: colors.primaryContainer,
              // ...or use colors.primaryContainer for a Yellowish tint
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              item.icon,
              size: 28,
              color: colors.onPrimaryContainer, // Yellow Icon (Brand Color)
              // OR use colors.onSurface for Black Icon
            ),
          ),
        ),
        const SizedBox(height: 8),
        // The Label
        Text(
          item.label,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _pointDashboard({
    required BuildContext context,
    required int totalPoints,
    required String? expiryPoints,
  }) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Loyalty Points:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$totalPoints pts',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  if (expiryPoints != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // Use transparent black for better contrast on Yellow
                        color: Colors.black.withValues(alpha: 0.1),
                      ),
                      child: Text(
                        expiryPoints,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary, // Match text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CustomerRedeemedRewardScreen(),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'My Rewards',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        // Image with error handling
        Positioned(
          right: -7,
          bottom: -15,
          child: Opacity(
            opacity: 0.9, // Slight transparency blends it better
            child: SizedBox(
              height: 150, // Slightly bigger
              child: Image.asset(
                'assets/images/reward.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
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
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 10),
        MaintenanceCarousel(maintenanceList: nearestMaintenance),
      ],
    );
  }
}
