import 'package:cheng_eng_3/core/controllers/towing/staff_towings_notifier.dart';
import 'package:cheng_eng_3/ui/screens/staff/towing/staff_towing_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/towing_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffTowingScreen extends ConsumerWidget {
  const StaffTowingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final towingList = ref.watch(staffTowingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Towing'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(staffTowingsProvider.future);
        },
        child: towingList.when(
          data: (towings) {
            if (towings.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('No towing record found')),
                ],
              );
            }

            return SafeArea(
              child: ListView.separated(
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