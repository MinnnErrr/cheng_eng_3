import 'package:cheng_eng_3/core/models/order_item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.g.dart';
part 'order_model.freezed.dart';

enum OrderStatus{
  unpaid,
  pending,
  processing,
  ready,
  delivered,
  completed,
  cancelled
}

enum DeliveryMethod{
  selfPickup,
  delivery
}

enum MalaysiaState{
  johor,
  kedah,
  kelantan,
  melaka,
  negeriSembilan,
  pahang,
  pulauPinang,
  perak,
  perlis,
  selangor,
  terengganu,
  sabah,
  sarawak,
  kualaLumpur,
  labuan,
  putrajaya
}

@freezed
sealed class Address with _$Address {
  const factory Address({
    required String firstName,
    required String lastName,
    required String countryCode,
    required String dialCode,
    required String phoneNum,
    required String line1,
    required String? line2,
    required String postcode,
    required String city,
    required MalaysiaState state,
    required String country,
  }) = _Address;
}

@freezed
sealed class Order with _$Order {
  const Order._();

  const factory Order({
    required String id,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required double subtotal,
    required double? deliveryFee,
    required double total,
    required int points,
    required String username,
    required String userPhoneNum,
    required String userDialCode,
    required String userEmail,
    required DeliveryMethod deliveryMethod,
    required String? deliveryFirstName,
    required String? deliveryLastName,
    required String? deliveryDialCode,
    required String? deliveryPhoneNum,
    required String? deliveryAddressLine1,
    required String? deliveryAddressLine2,
    required String? deliveryPostcode,
    required String? deliveryCity,
    required MalaysiaState? deliveryState,
    required String? deliveryCountry,
    required OrderStatus status,
    required String userId,

    @JsonKey(name: 'order_items', includeToJson: false) 
    List<OrderItem>? items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) =>
      _$OrderFromJson(json);

  bool get isFullyReady {
    if (items == null || items!.isEmpty) return false;
    return items!.every((item) => item.isReady);
  }
}
