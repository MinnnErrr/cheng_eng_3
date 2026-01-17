import 'package:cheng_eng_3/core/controllers/point/point_history_notifier.dart';
import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nearestExpiryProvider =
    FutureProvider.family<({DateTime date, int points})?, String>((
      ref,
      userId,
    ) async {
      final records = await ref.watch(pointHistoryProvider(userId).future);
      final now = DateTime.now();
      
      int totalUsed = records
          .where((r) => r.type == PointType.use || r.type == PointType.expire)
          .fold(0, (sum, r) => sum + r.points.abs());

      final activeEarnRecords =
          records
              .where(
                (r) =>
                    r.type == PointType.earn &&
                    r.expiredAt != null &&
                    r.expiredAt!.isAfter(now),
              )
              .toList()
            ..sort((a, b) => a.expiredAt!.compareTo(b.expiredAt!));

      for (final record in activeEarnRecords) {
        if (totalUsed >= record.points) {
          totalUsed -= record.points;
        } else {
          final remainingPoints = record.points - totalUsed;

          return (
            date: record.expiredAt!,
            points: remainingPoints,
          );
        }
      }

      return null;
    });
