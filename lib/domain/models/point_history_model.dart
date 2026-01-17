import 'package:freezed_annotation/freezed_annotation.dart';

part 'point_history_model.g.dart';
part 'point_history_model.freezed.dart';

enum PointType {
  earn,
  use,
  expire,
  earnExpired
}

@freezed
sealed class PointHistory with _$PointHistory {
  const factory PointHistory({
    required String id,
    required DateTime createdAt,
    required DateTime? expiredAt,
    required String reason,
    required int points,
    required bool isIssuedByStaff,
    required PointType type,
    required String userId,
  }) = _PointHistory;

  factory PointHistory.fromJson(Map<String, dynamic> json) =>
      _$PointHistoryFromJson(json);
}
