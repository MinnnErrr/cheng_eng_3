
import 'package:cheng_eng_3/core/controllers/point/total_points_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/reward/reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/point_history_model.dart';
import 'package:cheng_eng_3/core/models/redeemed_reward_model.dart';
import 'package:cheng_eng_3/core/services/point_history_service.dart';
import 'package:cheng_eng_3/core/services/redeemed_reward_service.dart';
import 'package:cheng_eng_3/core/services/reward_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'redeemed_reward_notifier.g.dart';

@riverpod
class RedeemedRewardNotifier extends _$RedeemedRewardNotifier {
  RedeemedRewardService get _redeemedRewardService =>
      ref.read(redeemedRewardServiceProvider);
  // 1. Inject RewardService to handle stock updates
  RewardService get _rewardService => ref.read(rewardServiceProvider);

  // 2. Inject PointHistoryService to handle point deduction
  PointHistoryService get _pointHistoryService =>
      ref.read(pointHistorytServiceProvider);

  @override
  FutureOr<List<RedeemedReward>> build(String userId) async {
    return await _redeemedRewardService.getbyUser(userId);
  }

  // void refresh() => ref.invalidateSelf();

  Future<Message> addRedeemedReward({
    required String rewardId,
    required String userId,
  }) async {
    // 1. Fetch Reward Data
    final reward = await ref.read(rewardByIdProvider(rewardId).future);

    // 2. Check Stock (New Logic)
    if (reward.quantity <= 0) {
      return Message(
        isSuccess: false,
        message: 'Reward is out of stock',
      );
    }

    // 3. Check Points Balance
    final userPoint = await ref.read(totalPointsProvider(userId).future);
    if (userPoint < reward.points) {
      return Message(
        isSuccess: false,
        message: 'Not enough points to redeem this reward',
      );
    }

    // --- Prepare Data Objects ---
    final redeemedId = const Uuid().v4();
    final now = DateTime.now();

    // Validity Logic
    DateTime? expiryDate;
    if (reward.validityWeeks != null) {
      // Cleaner DateTime calculation
      expiryDate = now.add(Duration(days: reward.validityWeeks! * 7));
    }

    final redeemedReward = RedeemedReward(
      id: redeemedId,
      createdAt: now,
      code: reward.code,
      name: reward.name,
      description: reward.description,
      conditions: reward.conditions,
      points: reward.points,
      expiryDate: expiryDate,
      photoPaths: reward.photoPaths,
      isClaimed: false,
      rewardId: rewardId,
      userId: userId,
      updatedAt: null,
    );

    // Points Deduction Record
    final pointDeduction = PointHistory(
      id: const Uuid().v4(),
      userId: userId,
      points: -reward.points, // Negative Value
      type: PointType.use,
      reason: 'Redeemed: ${reward.name}',
      isIssuedByStaff: false,
      createdAt: now,
      expiredAt: null,
    );

    // --- Execute Transaction ---
    try {
      // A. Create the "Voucher"
      await _redeemedRewardService.create(redeemedReward);

      // B. Deduct the Stock (RPC Call)
      await _rewardService.decreaseQuantity(rewardId);

      // C. Deduct the Points (Wallet Update)
      await _pointHistoryService.create(pointDeduction);

      return Message(isSuccess: true, message: 'Reward redeemed successfully');
    } catch (e) {
      return Message(
        isSuccess: false,
        message: 'Failed to redeem reward: $e',
      );
    }
  }

  Future<Message> claimReward({
    required String redeemedId,
  }) async {
    final redeemed = await ref.watch(
      redeeemdRewardByIdProvider(redeemedId).future,
    );

    if (redeemed.isClaimed == true) {
      return Message(isSuccess: false, message: 'The reward is claimed');
    }

    try {
      await _redeemedRewardService.updateStatus(true, redeemedId);

      return Message(isSuccess: true, message: 'Reward successfully claimed');
    } catch (e) {
      return Message(
        isSuccess: false,
        message: 'Failed to claim reward',
      );
    }
  }
}
