
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:cheng_eng_3/core/services/point_history_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'point_history_notifier.g.dart';

@riverpod
class PointHistoryNotifier extends _$PointHistoryNotifier {
  PointHistoryService get _pointHistoryService =>
      ref.read(pointHistoryServiceProvider);

  @override
  FutureOr<List<PointHistory>> build(String userId) async {
    final records = await _pointHistoryService.getAllUserPoints(userId);

    return records;
  }

  // void refresh() => ref.invalidateSelf();

  Future<Message> addPoints({
    required String userId,
    required int points, // e.g. 100
    required String reason,
    required bool isIssuedByStaff,
  }) async {
    if (points <= 0) {
      return Message(isSuccess: false, message: "Points must be positive");
    }

    try {
      await _pointHistoryService.addPoints(
        userId,
        points,
        reason,
        isIssuedByStaff,
      );
      ref.invalidateSelf();
      return Message(isSuccess: true, message: 'Points added successfully');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to add points: $e');
    }
  }

  Future<Message> deductPoints({
    required String userId,
    required int pointsToDeduct, // e.g. 50 (Positive input)
    required String reason,
    required bool isIssuedByStaff,
  }) async {
    if (pointsToDeduct <= 0) {
      return Message(isSuccess: false, message: "Amount must be positive");
    }

    // 1. Get current list from state
    final currentHistory = state.value ?? [];

    // 2. Calculate sum locally
    final currentBalance = currentHistory.fold<int>(
      0,
      (sum, item) => sum + item.points,
    );

    if (currentBalance < pointsToDeduct) {
      return Message(
        isSuccess: false,
        message: 'Insufficient balance. Current: $currentBalance pts',
      );
    }

    try {
      await _pointHistoryService.deductPoints(
        userId,
        pointsToDeduct,
        reason,
        isIssuedByStaff,
      );
      ref.invalidateSelf();
      return Message(isSuccess: true, message: 'Points redeemed successfully');
    } catch (e) {
      return Message(isSuccess: false, message: 'Transaction failed: $e');
    }
  }
}
