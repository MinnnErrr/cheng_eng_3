
import 'package:cheng_eng_3/domain/models/reward_model.dart';
import 'package:cheng_eng_3/data/services/reward_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final rewardByIdProvider =
    FutureProvider.family<Reward, String>((ref, rewardId) async {
  final rewardService = ref.read(rewardServiceProvider);
  return await rewardService.getByRewardId(rewardId);
});
