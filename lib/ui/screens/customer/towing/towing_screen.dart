import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towing_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/towing/customer_towing_details_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/towing/towing_map_screen.dart';
import 'package:cheng_eng_3/ui/widgets/towing_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TowingScreen extends ConsumerWidget {
  const TowingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final towingList = ref.watch(customerTowingProvider(user!.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Towing'),
      ),
      body: towingList.when(
        data: (towings) {
          return towings.isEmpty
              ? const Center(
                  child: Text('No towing record found'),
                )
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ListView.builder(
                      itemCount: towings.length,
                      itemBuilder: (context, index) {
                        final towing = towings[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TowingListItem(
                            towing: towing,
                            tapAction: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CustomerTowingDetailsScreen(
                                  towingId: towing.id,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
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
