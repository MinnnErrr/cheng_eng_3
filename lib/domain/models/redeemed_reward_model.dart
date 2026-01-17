import 'package:freezed_annotation/freezed_annotation.dart';

part 'redeemed_reward_model.g.dart';
part 'redeemed_reward_model.freezed.dart';

@freezed
sealed class RedeemedReward with _$RedeemedReward {
  const factory RedeemedReward({
    required String id,
    required DateTime createdAt,
    required String code,
    required String name,
    required String description,
    required String? conditions,
    required int points,
    required DateTime? expiryDate,
    required List<String> photoPaths,
    required bool isClaimed,
    required String rewardId,
    required String userId,
    required DateTime? updatedAt,
  }) = _RedeemedReward;

  factory RedeemedReward.fromJson(Map<String, dynamic> json) => _$RedeemedRewardFromJson(json);
}
