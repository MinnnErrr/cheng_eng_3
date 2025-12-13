import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_nearest_date_provider.dart';
import 'package:cheng_eng_3/core/controllers/point/customer_point_history_notifier.dart';
import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:cheng_eng_3/main.dart';
import 'package:cheng_eng_3/ui/screens/customer/cart/cart_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_details_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/product/customer_product_screen.dart';
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
    final user = ref.watch(authProvider).value;

    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Main(),
        ),
        (route) => false,
      );
    }

    final totalPoints = ref.watch(totalPointsProvider(user!.id));
    final nearestMaintenance = ref.watch(maintenanceByNearestDateProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Home',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Navigation buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                      child: Text('Profile'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VehicleScreen(),
                          ),
                        );
                      },
                      child: Text('Vehicles'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TowingScreen(),
                          ),
                        );
                      },
                      child: Text('Towing'),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CustomerProductScreen(),
                          ),
                        );
                      },
                      child: Text('Products'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    ),
                    child: cartIcon(ref, context),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CustomerRewardScreen(),
                          ),
                        );
                      },
                      child: Text('Rewards'),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              // point dashboard
              Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: totalPoints.when(
                  data: (total) {
                    return _pointDashboard(context: context, totalPoints: total);
                  },
                  error: (error, stackTrace) => Text("Error"),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),

              // Maintenance notification
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: nearestMaintenance.when(
                  data: (list) {
                    final nearest = list.maintenances;

                    return _maintenanceNotification(nearest, context);
                  },
                  error: (error, stackTrace) => Text("Error"),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                    builder: (context) => CustomerRewardScreen(),
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

        /// IMAGE ON RIGHT WITH CLIPPING
        Positioned(
          right: 5, // slight overflow for nice effect
          bottom: -17, // will be clipped
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
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),

        nearestMaintenance.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('No upcoming maintenance'),
                ),
              )
            : ListView.separated(
                shrinkWrap: true, // Important: lets it take only needed height
                physics:
                    NeverScrollableScrollPhysics(), // Prevent conflicts with outer scroll
                itemCount: nearestMaintenance.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final m = nearestMaintenance[index];
                  return MaintenanceListItem(
                    maintenance: m,
                    tapAction: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MaintenanceDetailsScreen(
                          maintenanceId: m.id,
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
