import 'package:cheng_eng_3/core/controllers/point/customer_point_history_notifier.dart';
import 'package:cheng_eng_3/core/controllers/reward/customer_reward_notifier.dart';
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/redeemed_reward_model.dart';
import 'package:cheng_eng_3/core/services/redeemed_reward_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'redeemed_reward_notifier.g.dart';

@riverpod
class RedeemedRewardNotifier extends _$RedeemedRewardNotifier {
  RedeemedRewardService get _redeemedRewardService =>
      ref.read(redeemedRewardServiceProvider);

  @override
  FutureOr<List<RedeemedReward>> build(String userId) async {
    return await _redeemedRewardService.getbyUser(userId);
  }

  // void refresh() => ref.invalidateSelf();

  Future<Message> addRedeemedReward({
    required String rewardId,
    required String userId,
  }) async {
    final reward = await ref.read(customerRewardByIdProvider(rewardId).future);

    final userPoint = await ref.read(totalPointsProvider(userId).future);

    if (userPoint < reward.points) {
      return Message(
        isSuccess: false,
        message: 'Not enough points to redeem this reward',
      );
    }

    final redeemedId = Uuid().v4();
    final now = DateTime.now();

    DateTime? expiryDate;
    if (reward.hasExpiry) {
      expiryDate = DateTime(
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

    final redeemed = RedeemedReward(
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

    try {
      await _redeemedRewardService.create(redeemed);

      return Message(isSuccess: true, message: 'Reward redeemed successfully');
    } catch (e) {
      return Message(
        isSuccess: false,
        message: 'Failed to redeemed reward',
      );
    }
  }

  Future<Message> claimReward({
    required String userId,
    required String redeemedId,
  }) async {
    final redeemed = await ref.watch(
      redeemedRewardByIdProvider((redeemedId: redeemedId, userId: userId)).future,
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

final redeemedRewardByIdProvider =
    FutureProvider.family<RedeemedReward, ({String userId, String redeemedId})>(
      (ref, params) async {
        final list = await ref.watch(
          redeemedRewardProvider(params.userId).future,
        );

        return list.firstWhere(
          (r) => r.id == params.redeemedId,
          orElse: () => throw Exception('Reward not found'),
        );
      },
    );

// final totalPointsProvider = Provider.family<int, String>((ref, userId) {
//   final asyncRecords = ref.watch(pointHistoryProvider(userId));

//   return asyncRecords.maybeWhen(
//     data: (records) => records.fold(0, (sum, r) => sum + r.points),
//     orElse: () => 0,
//   );
// });
