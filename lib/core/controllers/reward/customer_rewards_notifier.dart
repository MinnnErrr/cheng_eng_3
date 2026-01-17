import 'package:cheng_eng_3/core/models/reward_model.dart';
import 'package:cheng_eng_3/core/services/reward_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_rewards_notifier.g.dart';

@riverpod
class CustomerRewardsNotifier extends _$CustomerRewardsNotifier {
  RewardService get _rewardService => ref.read(rewardServiceProvider);

  @override
  FutureOr<List<Reward>> build() async {
    final data = await _rewardService.getActiveRewards();

    List<Reward> finalData = [];

    final now = DateTime.now();

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
}

