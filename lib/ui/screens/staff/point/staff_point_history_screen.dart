
import 'package:cheng_eng_3/core/controllers/point/staff_point_history_provider.dart';
import 'package:cheng_eng_3/ui/screens/staff/point/staff_add_point_history.dart';
import 'package:cheng_eng_3/ui/widgets/point_history_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffPointsHistoryScreen extends ConsumerWidget {
  const StaffPointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointState = ref.watch(staffPointHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Points History'),
      ),
      body: pointState.when(
        data: (records) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: records.isEmpty
                  ? Center(
                      child: Text('No points history recorded'),
                    )
                  : ListView.separated(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return PointHistoryListitem(
                          record: record,
                          isStaff: true,
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                    ),
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const StaffAddPointHistoryScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
