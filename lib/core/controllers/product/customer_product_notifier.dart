
import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/core/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_product_notifier.g.dart';

@riverpod
class CustomerProductNotifier extends _$CustomerProductNotifier {
  ProductService get _productService => ref.read(productServiceProvider);

  @override
  FutureOr<List<Product>> build() async {
    return await _productService.getActiveProducts();
  }

  // void refresh() => ref.invalidateSelf();

}

final customerProductByIdProvider = Provider.family<AsyncValue<Product>, String>((
  ref,
  productId,
) {
  final productList = ref.watch(customerProductProvider);

  return productList.when(
    data: (list) {
      final product = list.firstWhere(
        (p) => p.id == productId,
        orElse: () => throw Exception('Product not found'),
      );
      return AsyncValue.data(product);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, st) => AsyncValue.error(err, st),
  );
});
