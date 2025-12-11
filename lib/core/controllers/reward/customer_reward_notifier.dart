import 'package:cheng_eng_3/core/models/reward_model.dart';
import 'package:cheng_eng_3/core/services/reward_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_reward_notifier.g.dart';

@riverpod
class CustomerRewardNotifier extends _$CustomerRewardNotifier {
  RewardService get _rewardService => ref.read(rewardServiceProvider);

  @override
  FutureOr<List<Reward>> build() async {
    final data = await _rewardService.getActiveRewards();

    List<Reward> finalData = [];

    final now = DateTime.now();

    //keep available rewards only
    for (final reward in data) {
      if (reward.availableUntil == null) {
        finalData.add(reward);
        continue;
      }

      if (now.isBefore(reward.availableUntil!) ||
          now.isAtSameMomentAs(reward.availableUntil!)) {
        finalData.add(reward);
      }
    }

    return finalData;
  }

  // void refresh() => ref.invalidateSelf();
}

final customerRewardByIdProvider =
    FutureProvider.family<Reward, String>((ref, rewardId) async {
  final rewards = await ref.watch(customerRewardProvider.future);

  final reward = rewards.firstWhere(
    (r) => r.id == rewardId,
    orElse: () => throw Exception('Reward not found'),
  );

  return reward;
});

