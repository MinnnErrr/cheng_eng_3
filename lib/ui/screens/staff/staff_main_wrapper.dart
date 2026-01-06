import 'package:cheng_eng_3/ui/screens/profile_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/claim_reward/staff_claim_reward_screen.dart';
import 'package:cheng_eng_3/ui/screens/staff/point/staff_add_point_history.dart';
import 'package:cheng_eng_3/ui/screens/staff/staff_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffMainWrapper extends ConsumerStatefulWidget {
  const StaffMainWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffMainWrapperState();
}

class _StaffMainWrapperState extends ConsumerState<StaffMainWrapper> {
  int _index = 0;

  final _screens = [
    const StaffHome(),
    const StaffAddPointHistoryScreen(),
    const StaffClaimRewardScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() {
          _index = value;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.stars), label: 'Add'),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Claim',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
