import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/product_by_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isCartValidProvider = FutureProvider<bool>((ref) async {
  final cartItems = await ref.watch(cartProvider.future);

  // 1. Fetch ALL products at the same time (Parallel)
  final products = await Future.wait(
    cartItems.map((item) => ref.watch(productByIdProvider(item.productId).future))
  );

  // 2. Check validity
  for (final product in products) {
    // If quantity is null (Preorder), this check is skipped (Valid)
    // If quantity exists (Ready Stock) and is <= 0, return false (Invalid)
    if (product.quantity != null && product.quantity! <= 0) {
      return false;
    }
  }

  return true;
});