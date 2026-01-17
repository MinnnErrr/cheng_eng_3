import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.g.dart';
part 'product_model.freezed.dart';

enum ProductAvailability {
  ready,
  preorder,
}

enum ProductSorting {
  newest('Newest'),
  oldest('Oldest'),
  highestPrice('Highest Price'),
  lowestPrice('Lowest Price');

  const ProductSorting(this.title);
  final String title;
} 

@freezed
sealed class Product with _$Product {
  const factory Product({
    required String id,
    required DateTime createdAt,
    required String name,
    required String category,
    required String brand,
    String? model,
    String? colour,
    required String description,
    required bool status,
    required ProductAvailability availability,
    int? quantity,
    required bool installation,
    double? installationFee,
    required List<String> photoPaths,
    DateTime? deletedAt,
    DateTime? updatedAt,
    String? remarks,
    required double price,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
