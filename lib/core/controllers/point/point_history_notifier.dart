import 'package:cheng_eng_3/core/controllers/point/total_points_provider.dart';
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:cheng_eng_3/core/services/point_history_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'point_history_notifier.g.dart';

@riverpod
class PointHistoryNotifier extends _$PointHistoryNotifier {
  PointHistoryService get _pointHistoryService =>
      ref.read(pointHistorytServiceProvider);

  @override
  FutureOr<List<PointHistory>> build(String userId) async {
    final records = await _pointHistoryService.getAllUserPoints(userId);

    return records;
  }

  // void refresh() => ref.invalidateSelf();

  Future<Message> earnPoints({
    required String userId,
    required int points, // e.g. 100
    required String reason,
    required bool isIssuedByStaff,
  }) async {
    if (points <= 0) {
      return Message(isSuccess: false, message: "Points must be positive");
    }

    final record = PointHistory(
      id: const Uuid().v4(),
      userId: userId,
      points: points, // POSITIVE
      type: PointType.earn,
      reason: reason,
      isIssuedByStaff: isIssuedByStaff,
      createdAt: DateTime.now(),
      // Set Expiry: 1 Year from today (Or whatever your business rule is)
      expiredAt: DateTime.now().add(const Duration(days: 365)),
    );

    try {
      await _pointHistoryService.create(record);
      ref.invalidateSelf();
      return Message(isSuccess: true, message: 'Points added successfully');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to add points: $e');
    }
  }

  Future<Message> usePoints({
    required String userId,
    required int pointsToUse, // e.g. 50 (Positive input)
    required String reason,
    required bool isIssuedByStaff,
  }) async {
    if (pointsToUse <= 0) {
      return Message(isSuccess: false, message: "Amount must be positive");
    }

    // 1. Get current list from state
    final currentHistory = state.value ?? [];

    // 2. Calculate sum locally
    final currentBalance = currentHistory.fold<int>(
      0,
      (sum, item) => sum + item.points,
    );

    if (currentBalance < pointsToUse) {
      return Message(
        isSuccess: false,
        message: 'Insufficient balance. Current: $currentBalance pts',
      );
    }

    // 2. Create the Deduction Record
    // NOTICE: We do NOT loop through old records or update their status.
    // We simply insert a negative record. The SQL job handles the rest.
    final record = PointHistory(
      id: const Uuid().v4(),
      userId: userId,
      points: -pointsToUse, // NEGATIVE
      type: PointType.use,
      reason: reason,
      isIssuedByStaff: isIssuedByStaff,
      createdAt: DateTime.now(),
      expiredAt: null, // Deduction records don't expire
    );

    try {
      await _pointHistoryService.create(record);
      ref.invalidateSelf();
      return Message(isSuccess: true, message: 'Points redeemed successfully');
    } catch (e) {
      return Message(isSuccess: false, message: 'Transaction failed: $e');
    }
  }
}
