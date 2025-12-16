import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towings_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/towing/customer_towing_details_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/towing/towing_map_screen.dart';
import 'package:cheng_eng_3/ui/widgets/towing_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TowingScreen extends ConsumerWidget {
  const TowingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);
    final user = userState.value;

    // FIX 1: Safety check to prevent crash on 'user!.id'
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user found')),
      );
    }

    final towingList = ref.watch(customerTowingsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Towing'),
      ),
      body: towingList.when(
        data: (towings) {
          // FIX 2: Add RefreshIndicator
          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(customerTowingsProvider(user.id).future),
            child: towings.isEmpty
                // FIX 3: Empty state must be scrollable to allow Refresh
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3),
                      const Center(child: Text('No towing record found')),
                    ],
                  )
                : SafeArea(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: towings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final towing = towings[index];
                        return TowingListItem(
                          towing: towing,
                          tapAction: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerTowingDetailsScreen(
                                towing: towing,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          );
        },
        // Error handling with Retry button
         error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TowingMapScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}