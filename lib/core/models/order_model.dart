import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.g.dart';
part 'order_model.freezed.dart';

enum OrderStatus{
  unpaid,
  pending,
  processing,
  ready,
  delivered,
  completed
}

enum State{
  johor,
  kedah,
  kelantan,
  melaka,
  negeriSembilan,
  pahang,
  pulauPinanag,
  perak,
  perlis,
  selangor,
  terengganu,
  sabah,
  sarawak,
  kualaLumpur,
  labuah,
  putrajaya
}

@freezed
sealed class Order with _$Order {
  const factory Order({
    required String id,
    required DateTime createAt,
    required DateTime? updatedAt,
    required double subtotal,
    required double? deliveryFee,
    required double total,
    required int points,
    required String? firstName,
    required String? lastName,
    required String? phoneNum,
    required String? addressLine1,
    required String? addressLine2,
    required String? poscode,
    required String? city,
    required State state,
    required String? country,
    required OrderStatus status,
    required String userId
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) =>
      _$OrderFromJson(json);
}
