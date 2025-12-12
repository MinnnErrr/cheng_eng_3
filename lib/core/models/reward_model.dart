import 'package:freezed_annotation/freezed_annotation.dart';

part 'reward_model.g.dart';
part 'reward_model.freezed.dart';

@freezed
sealed class Reward with _$Reward {
  const factory Reward({
    required String id,
    required DateTime createdAt,
    required String code,
    required String name,
    required String description,
    required String? conditions,
    required int points,
    required int quantity,
    required DateTime? availableUntil,
    required int? validityWeeks,
    required List<String> photoPaths,
    required bool status,
    DateTime? deletedAt,
    DateTime? updatedAt,
  }) = _Reward;

  factory Reward.fromJson(Map<String, dynamic> json) => _$RewardFromJson(json);
}
