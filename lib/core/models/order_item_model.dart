import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_model.g.dart';
part 'order_item_model.freezed.dart';

@freezed
sealed class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required int quantity,
    required List<String> photoPaths,
    required String productBrand,
    required String productName,
    required String? productModel,
    required String? productColour,
    required double productPrice,
    required double? productInstallationFee,
    required double totalPrice,
    required double? totalInstallationFee,
    required bool isReady,
    required String productId,
    required String orderId,
    required DateTime? updatedAt
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}
