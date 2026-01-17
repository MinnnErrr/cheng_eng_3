
import 'package:cheng_eng_3/domain/models/message_model.dart';
import 'package:cheng_eng_3/domain/models/point_history_model.dart';
import 'package:cheng_eng_3/data/services/point_history_service.dart';
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


  Future<Message> addPoints({
    required String userId,
    required int points,
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
    required int pointsToDeduct,
    required String reason,
    required bool isIssuedByStaff,
  }) async {
    if (pointsToDeduct <= 0) {
      return Message(isSuccess: false, message: "Amount must be positive");
    }

    final currentHistory = state.value ?? [];

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
