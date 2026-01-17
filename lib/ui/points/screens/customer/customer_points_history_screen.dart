
import 'package:cheng_eng_3/ui/auth/notifiers/auth_notifier.dart';
import 'package:cheng_eng_3/data/providers/point/nearest_expiry_point_provider.dart';
import 'package:cheng_eng_3/ui/points/notifiers/point_history_notifier.dart';
import 'package:cheng_eng_3/data/providers/point/total_points_provider.dart';
import 'package:cheng_eng_3/data/providers/realtime_provider.dart';
import 'package:cheng_eng_3/ui/points/widgets/point_history_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomerPointsHistoryScreen extends ConsumerWidget {
  const CustomerPointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);
    final user = userState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    ref.watch(pointHistoryRealTimeProvider);

    final pointState = ref.watch(pointHistoryProvider(user.id));
    final totalPointsAsync = ref.watch(totalPointsProvider(user.id));
    final expiryPointsInfo = ref.watch(nearestExpiryProvider(user.id));
    final theme = Theme.of(context);

    String? expiryText = expiryPointsInfo.when(
      data: (info) => info != null
          ? '${info.points} pts expiring on ${DateFormat('dd/MM/yyyy').format(info.date)}'
          : null,
      loading: () => null,
      error: (_, __) => null,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Points History')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // --- 1. HEADER  ---
              Center(
                child: Column(
                  children: [
                    Text(
                      'TOTAL BALANCE',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8), 
                    totalPointsAsync.when(
                      data: (points) => RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$points',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                height: 1.0,
                              ),
                            ),
                            const WidgetSpan(child: SizedBox(width: 4)),
                            TextSpan(
                              text: 'pts',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      loading: () => const SizedBox(
                        height: 42,
                        width: 42,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (_, __) => const Text('---'),
                    ),

                    // Expiry Warning
                    if (expiryText != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer.withValues(
                            alpha: 0.3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: theme.colorScheme.error,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              expiryText,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- 2. HISTORY TITLE ---
              Text(
                'Recent Activity',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),

              // --- 3. HISTORY LIST ---
              Expanded(
                child: pointState.when(
                  data: (records) {
                    if (records.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async =>
                            ref.refresh(pointHistoryProvider(user.id).future),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long,
                                    size: 48,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'No transactions yet',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await Future.wait([
                          ref.refresh(totalPointsProvider(user.id).future),
                          ref.refresh(pointHistoryProvider(user.id).future),
                        ]);
                      },
                      child: ListView.separated(
                        itemCount: records.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return PointHistoryListitem(
                            record: records[index],
                            isStaff: false,
                          );
                        },
                      ),
                    );
                  },
                  error: (e, _) => Center(child: Text('Error: $e')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
