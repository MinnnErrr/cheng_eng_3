import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/point_history_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/total_points_provider.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/ui/widgets/point_history_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomerPointsHistoryScreen extends ConsumerWidget {
  const CustomerPointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Use 'watch' so UI reacts to logout, and handle null safely
    final userState = ref.watch(authProvider);
    final user = userState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    ref.watch(pointHistoryRealTimeProvider);

    final pointState = ref.watch(pointHistoryProvider(user.id));
    // 2. Total points is likely an AsyncValue, handle it properly
    final totalPointsAsync = ref.watch(totalPointsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Points History'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- HEADER SECTION ---
              Center(
                child: Column(
                  children: [
                    Text(
                      'You have',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    // Handle AsyncValue for points display
                    totalPointsAsync.when(
                      data: (points) => Text(
                        '$points pts',
                        style: Theme.of(context).textTheme.headlineLarge!
                            .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      loading: () => const SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(),
                      ),
                      error: (_, __) => const Text('Error loading points'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'History',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // --- HISTORY LIST ---
              // 3. CRITICAL FIX: Use Expanded to prevent layout overflow
              Expanded(
                child: pointState.when(
                  data: (records) {
                    if (records.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async => Future.wait([
                          ref.refresh(totalPointsProvider(user.id).future),
                          ref.refresh(pointHistoryProvider(user.id).future),
                        ]),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            const Center(
                              child: Text('No points history recorded'),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () {
                        // Refresh both providers
                        return Future.wait([
                          // Access .future to get the "loading task"
                          ref.refresh(totalPointsProvider(user.id).future),
                          ref.refresh(pointHistoryProvider(user.id).future),
                        ]);
                      },
                      child: ListView.separated(
                        itemCount: records.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final record = records[index];
                          return PointHistoryListitem(
                            record: record,
                            isStaff: false,
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
