import 'package:cheng_eng_3/core/controllers/point/staff_point_history_provider.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/ui/screens/staff/point/staff_add_point_history.dart';
import 'package:cheng_eng_3/ui/widgets/point_history_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffPointsHistoryScreen extends ConsumerWidget {
  const StaffPointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pointHistoryRealTimeProvider);

    final pointState = ref.watch(staffPointHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Points History'),
      ),
      body: pointState.when(
        data: (records) {
          return SafeArea(
            child: RefreshIndicator(
              // Allows user to pull down to refresh the list
              onRefresh: () async {
                return ref.refresh(staffPointHistoryProvider.future);
              },
              child: records.isEmpty
                  ? const Center(
                      child: Text('No points history recorded'),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return PointHistoryListitem(
                          record: record,
                          isStaff: true,
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const StaffAddPointHistoryScreen(),
          ),
        ),
        icon: const Icon(Icons.swap_vert),
        label: const Text("Transaction"),
      ),
    );
  }
}
