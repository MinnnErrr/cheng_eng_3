import 'package:cheng_eng_3/core/controllers/towing/staff_towings_notifier.dart';
import 'package:cheng_eng_3/ui/screens/staff/towing/staff_towing_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/towing_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffTowingScreen extends ConsumerStatefulWidget {
  const StaffTowingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _StaffTowingScreenState();
}

class _StaffTowingScreenState extends ConsumerState<StaffTowingScreen> {
  @override
  Widget build(BuildContext context) {
    final towingList = ref.watch(staffTowingsProvider);

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
                                builder: (context) => StaffTowingDetailsScreen(
                                  towing: towing,
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
    );
  }
}
