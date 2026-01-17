import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item_model.g.dart';
part 'cart_item_model.freezed.dart';

@freezed
sealed class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required int quantity,
    bool? installation,
    required String productId,
    required String userId,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
