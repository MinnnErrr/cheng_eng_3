import 'package:cheng_eng_3/ui/screens/profile_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/claim_reward/staff_claim_reward_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/point/staff_point_history_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/product/staff_product_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/reward/staff_reward_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/towing/staff_towing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffHome extends ConsumerWidget {
  const StaffHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('staff home'),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              ),
              child: Text('Profile'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StaffTowingScreen(),
                  ),
                );
              },
              child: Text('Towing Management'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StaffProductScreen(),
                  ),
                );
              },
              child: Text('Product Management'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StaffRewardScreen(),
                  ),
                );
              },
              child: Text('Reward Management'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StaffPointsHistoryScreen(),
                  ),
                );
              },
              child: Text('Point Management'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StaffClaimRewardScreen(),
                  ),
                );
              },
              child: Text('Redeemed Reward Management'),
            ),
          ],
        ),
      ),
    );
  }
}
