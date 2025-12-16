
import 'package:cheng_eng_3/core/models/redeemed_reward_model.dart';
import 'package:cheng_eng_3/core/services/redeemed_reward_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final redeeemdRewardByIdProvider =
    FutureProvider.family<RedeemedReward, String>((ref, redeemedId) async {
  final service = ref.read(redeemedRewardServiceProvider);
  return await service.getById(redeemedId);
});
