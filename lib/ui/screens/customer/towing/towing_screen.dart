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

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    final towingList = ref.watch(customerTowingsProvider(user.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Towing Requests')),
      body: towingList.when(
        data: (towings) {
          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(customerTowingsProvider(user.id).future),
            child: towings.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.no_crash_outlined,
                              size: 60,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            const Text('No towing requests found'),
                          ],
                        ),
                      ),
                    ],
                  )
                : SafeArea(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: towings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12), 
                      itemBuilder: (context, index) {
                        final towing = towings[index];
                        return TowingListItem(
                          towing: towing,
                          tapAction: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CustomerTowingDetailsScreen(towing: towing),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              Text('Error: $error'),
              TextButton(
                onPressed: () => ref.refresh(customerTowingsProvider(user.id)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const TowingMapScreen(),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Request'),
      ),
    );
  }
}
