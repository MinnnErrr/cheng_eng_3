import 'package:cheng_eng_3/core/controllers/point/point_history_notifier.dart';
import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nearestExpiryProvider =
    FutureProvider.family<({DateTime date, int points})?, String>(
        (ref, userId) async {
  // 1. WATCH the provider to stay reactive to Realtime changes
  final records = await ref.watch(pointHistoryProvider(userId).future);
  final now = DateTime.now();

  // 2. Calculate Total Used Points (The "Debt" we need to clear from old records)
  int totalUsed = records
      .where((r) => r.type == PointType.use || r.type == PointType.expire)
      .fold(0, (sum, r) => sum + r.points.abs());

  // 3. Get only future expiring records and SORT them by nearest expiry date
  final activeEarnRecords = records
      .where((r) =>
          r.type == PointType.earn &&
          r.expiredAt != null &&
          r.expiredAt!.isAfter(now))
      .toList()
    ..sort((a, b) => a.expiredAt!.compareTo(b.expiredAt!));

  // 4. Walk through the records (FIFO Logic)
  for (final record in activeEarnRecords) {
    if (totalUsed >= record.points) {
      // This entire bucket of points has already been spent.
      // Pay off the "debt" and move to the next bucket.
      totalUsed -= record.points;
    } else {
      // We found the first bucket that has NOT been fully spent!
      // The remaining balance in this bucket is what's expiring next.
      final remainingPoints = record.points - totalUsed;

      return (
        date: record.expiredAt!,
        points: remainingPoints,
      );
    }
  }

  // If loop finishes, it means all earn records were covered by usage.
  // Nothing is expiring soon.
  return null;
});