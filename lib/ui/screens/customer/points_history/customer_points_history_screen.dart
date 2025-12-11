import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/customer_point_history_notifier.dart';
import 'package:cheng_eng_3/main.dart';
import 'package:cheng_eng_3/ui/widgets/point_history_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerPointsHistoryScreen extends ConsumerWidget {
  const CustomerPointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(authProvider).value;

    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Main(),
        ),
        (route) => false,
      );
    }

    final pointState = ref.watch(pointHistoryProvider(user!.id));
    final totalPoints = ref.watch(totalPointsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Points History'),
      ),
      body: pointState.when(
        data: (records) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'You have',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '$totalPoints pts',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  Text(
                    'History',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  records.isEmpty
                      ? Center(
                          child: Text('No points history recorded'),
                        )
                      : ListView.separated(
                          itemCount: records.length,
                          itemBuilder: (context, index) {
                            final record = records[index];
                            return PointHistoryListitem(
                              record: record,
                              isStaff: false,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                        ),
                ],
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
    );
  }
}
