
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productByIdProvider =
    FutureProvider.family<Product?, String>((ref, productId) async {
  final productService = ref.read(productServiceProvider);
  return await productService.getByProductId(productId);
});
