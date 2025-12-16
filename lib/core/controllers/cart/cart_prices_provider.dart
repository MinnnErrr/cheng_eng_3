import 'package:cheng_eng_3/core/controllers/cart/cart_item_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/product_by_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 2. Calculate Item Price (Quantity * Product Price)
// FIXED: Changed to FutureProvider to handle async dependencies
final cartItemPriceProvider = FutureProvider.family<double, String>((ref, itemId) async {
  // Await the item first
  final item = await ref.watch(cartItemByIdProvider(itemId).future);

  // Now we have the item, so we can access item.productId to get the product
  final product = await ref.watch(productByIdProvider(item.productId).future);

  return (item.quantity * product.price);
});

// 3. Calculate Installation Fee
// FIXED: Changed to FutureProvider
final cartItemInstallationFeeProvider = FutureProvider.family<double, String>((
  ref,
  itemId,
) async {
  // Await both dependencies
  final item = await ref.watch(cartItemByIdProvider(itemId).future);
  final product = await ref.watch(productByIdProvider(item.productId).future);

  // Perform Logic
  if (product.installation == true && product.installationFee != null) {
    return (product.installationFee! * item.quantity);
  }

  return 0.0;
});

// FIX: Must be FutureProvider because it depends on other FutureProviders
final cartTotalProvider = FutureProvider<double>((ref) async {
  // 1. Wait for the cart list to load
  final cartItems = await ref.watch(cartProvider.future);

  if (cartItems.isEmpty) return 0.0;

  double total = 0.0;

  // 2. Loop through items and await their individual costs
  for (final item in cartItems) {
    // We use .future to get the actual double value
    final price = await ref.watch(cartItemPriceProvider(item.id).future);
    final installFee = await ref.watch(cartItemInstallationFeeProvider(item.id).future);

    total += price + installFee;
  }

  return total;
});

// FIX: Must be FutureProvider because it watches cartTotalProvider
final cartPointProvider = FutureProvider<int>((ref) async {
  // Wait for the total to be calculated
  final cartTotal = await ref.watch(cartTotalProvider.future);
  return cartTotal.round();
});