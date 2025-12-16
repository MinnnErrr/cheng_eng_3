import 'package:cheng_eng_3/core/controllers/towing/staff_towings_notifier.dart';
import 'package:cheng_eng_3/ui/screens/staff/towing/staff_towing_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/towing_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Changed to ConsumerWidget (StatefulWidget is overkill here)
class StaffTowingScreen extends ConsumerWidget {
  const StaffTowingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final towingList = ref.watch(staffTowingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Towing'),
      ),
      // 2. RefreshIndicator lets users pull down to retry/reload
      body: RefreshIndicator(
        onRefresh: () async {
          // Invalidate the provider to force a re-fetch
          return ref.refresh(staffTowingsProvider.future);
        },
        child: towingList.when(
          data: (towings) {
            if (towings.isEmpty) {
              // Wrap in ListView so the RefreshIndicator still works on empty screens
              return ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('No towing record found')),
                ],
              );
            }

            return SafeArea(
              // 3. Use ListView.separated for cleaner spacing
              child: ListView.separated(
                // 4. Put padding INSIDE the list view to avoid clipping content while scrolling
                padding: const EdgeInsets.all(20),
                itemCount: towings.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final towing = towings[index];
                  return TowingListItem(
                    towing: towing,
                    tapAction: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => StaffTowingDetailsScreen(
                          towing: towing,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}