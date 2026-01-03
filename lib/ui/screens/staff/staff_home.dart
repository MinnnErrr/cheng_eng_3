import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
import 'package:cheng_eng_3/ui/screens/staff/booking/staff_booking_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/claim_reward/staff_claim_reward_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/order/staff_order_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/point/staff_point_history_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/product/staff_product_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/reward/staff_reward_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/towing/staff_towing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data Class to organize the buttons
class _StaffMenuItem {
  final String label;
  final IconData icon;
  final Widget screen;
  final Color? color; // Optional override color for high-priority items

  _StaffMenuItem({
    required this.label,
    required this.icon,
    required this.screen,
    this.color,
  });
}

class StaffHome extends ConsumerWidget {
  const StaffHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    String name = profileState.isLoading
        ? 'Loading...'
        : (profileState.value == null
              ? 'Hello! User'
              : 'Hello! ${profileState.value!.name}');

    // Access theme colors
    final colorScheme = Theme.of(context).colorScheme;

    // Define the menu items here to keep the build method clean
    final List<_StaffMenuItem> menuItems = [
      _StaffMenuItem(
        label: 'Bookings',
        icon: Icons.calendar_month_outlined,
        screen: const StaffBookingScreen(),
        color: Colors.blueAccent, // Optional: Color coding for urgency
      ),
      _StaffMenuItem(
        label: 'Orders',
        icon: Icons.receipt_long_outlined,
        screen: const StaffOrderScreen(),
        color: Colors.orangeAccent,
      ),
      _StaffMenuItem(
        label: 'Towing Requests',
        icon: Icons.car_crash_outlined,
        screen: const StaffTowingScreen(),
        color: Colors.redAccent,
      ),
      _StaffMenuItem(
        label: 'Product Inventory',
        icon: Icons.inventory_2_outlined,
        screen: const StaffProductScreen(),
        color: textYellow,
      ),
      _StaffMenuItem(
        label: 'Manage Points',
        icon: Icons.stars,
        screen: const StaffPointsHistoryScreen(),
        color: textYellow,
      ),
      _StaffMenuItem(
        label: 'Reward Catalog',
        icon: Icons.card_giftcard,
        screen: const StaffRewardScreen(),
        color: textYellow,
      ),
      _StaffMenuItem(
        label: 'Claim Reward',
        icon: Icons.qr_code_scanner_outlined,
        screen: const StaffClaimRewardScreen(),
        color: textYellow,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Center(
                child: Column(
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant, // Grey Text
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Staff Dashboard',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w800, // Bold and Thick
                            color: colorScheme.onSurface, // Black Text
                            letterSpacing:
                                -0.5, // Tighter letters for modern look
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Text(
                "Manage Operations",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 15),

              // THE GRID DASHBOARD
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 Columns
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1, // Wider than tall cards
                  ),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return _buildDashboardCard(context, item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, _StaffMenuItem item) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHigh, // Light Grey Background
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => item.screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Circle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (item.color ?? theme.colorScheme.primary).withValues(
                    alpha: 0.15,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 32,
                  color:
                      item.color ??
                      theme.colorScheme.primary, // Custom color or Brand Yellow
                ),
              ),
              const SizedBox(height: 12),
              // Label
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
