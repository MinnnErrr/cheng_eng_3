import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:cheng_eng_3/core/services/point_history_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'customer_point_history_notifier.g.dart';

@riverpod
class PointHistoryNotifier extends _$PointHistoryNotifier {
  PointHistoryService get _pointHistoryService =>
      ref.read(pointHistorytServiceProvider);

  @override
  FutureOr<List<PointHistory>> build(String userId) async {
    final records = await _pointHistoryService.getAllUserPoints(userId);
    final now = DateTime.now();

    // Compute initial balance manually
    int balance = records.fold(0, (sum, r) => sum + r.points);

    for (final record in records) {
      if (record.type == PointType.earn &&
          record.expiredAt != null &&
          record.expiredAt!.isBefore(now)) {
        if (balance <= 0) {
          // No deduction
          await updateType(id: record.id, type: PointType.earnExpired);
          continue;
        }

        // Deduction cannot exceed balance
        final deduction = balance >= record.points ? record.points : balance;

        if (deduction > 0) {
          await addRecord(
            userId: userId,
            points: -deduction,
            type: PointType.expire,
            reason: "Points expired",
            isIssuedByStaff: false,
          );

          // Update running balance
          balance -= deduction;
        }

        // Mark original earn record as expired
        await updateType(
          id: record.id,
          type: PointType.earnExpired,
        );
      }
    }

    return records;
  }

  // void refresh() => ref.invalidateSelf();

  Future<Message> addRecord({
    required String userId,
    required int? points,
    required PointType type,
    required String reason,
    required bool isIssuedByStaff,
  }) async {
    final records = await _pointHistoryService.getAllUserPoints(userId);
    //get user balance
    int balance = records.fold(0, (sum, r) => sum + r.points);

    final recordId = Uuid().v4();

    DateTime? expiredAt;
    DateTime now = DateTime.now();

    if (points == null) {
      return Message(isSuccess: false, message: 'Invalid amount');
    }

    if (type == PointType.earn) {
      expiredAt = DateTime(
        now.year + 1,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second,
        now.millisecond,
        now.microsecond,
      );
    }

    if (type == PointType.use) {
      if (points > balance) {
        return Message(
          isSuccess: false,
          message: "Cannot deduct more than user's current balance",
        );
      }
    }

    final record = PointHistory(
      id: recordId,
      createdAt: DateTime.now(),
      expiredAt: expiredAt,
      reason: reason,
      points: type == PointType.earn ? points : -points,
      type: type,
      isIssuedByStaff: isIssuedByStaff,
      userId: userId,
    );

    try {
      await _pointHistoryService.create(record);

      return Message(isSuccess: true, message: 'Point history updated');
    } catch (e) {
      return Message(
        isSuccess: false,
        message: 'Failed to update point history',
      );
    }
  }

  Future<Message> updateType({
    required String id,
    required PointType type,
  }) async {
    try {
      await _pointHistoryService.updateType(type, id);

      return Message(isSuccess: true, message: 'Expired points updated');
    } catch (e) {
      return Message(
        isSuccess: false,
        message: 'Failed to updated expired points',
      );
    }
  }
}

final totalPointsProvider = FutureProvider.family<int, String>((ref, userId) async {
  final records = await ref.watch(pointHistoryProvider(userId).future); 

  return records.fold<int>(0, (sum, r) => sum + r.points);
});


final nearestExpiryProvider =
    FutureProvider.family<({DateTime date, int points})?, String>(
        (ref, userId) async {
  final records = await ref.watch(pointHistoryProvider(userId).future);
  final now = DateTime.now();

  DateTime? nearest;
  int expiringPoints = 0;

  for (final r in records) {
    if (r.type == PointType.earn &&
        r.expiredAt != null &&
        r.expiredAt!.isAfter(now)) {
      if (nearest == null) {
        nearest = r.expiredAt;
        expiringPoints = r.points;
      } else {
        if (r.expiredAt!.isBefore(nearest)) {
          nearest = r.expiredAt;
          expiringPoints = r.points;
        } else if (r.expiredAt!.isAtSameMomentAs(nearest)) {
          expiringPoints += r.points;
        }
      }
    }
  }

  if (nearest == null) return null;

  return (
    date: nearest,
    points: expiringPoints,
  );
});

