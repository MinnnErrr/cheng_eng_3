import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/customer_product_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//item price (quantity * product price)
final cartItemPriceProvider = Provider.family<double, String>((ref, itemId) {
  final itemAsync = ref.watch(cartItemByIdProvider(itemId));
  final item = itemAsync.asData?.value;

  if (item == null) return 0;

  final productAsync = ref.watch(customerProductByIdProvider(item.productId));
  final product = productAsync.asData?.value;

  if (product == null) return 0;

  return (item.quantity * product.price);
});

//installation fee (quantity * installation price)
final cartItemInstallationFeeProvider = Provider.family<double, String>((
  ref,
  itemId,
) {
  final itemAsync = ref.watch(cartItemByIdProvider(itemId));
  final item = itemAsync.asData?.value;

  if (item == null) return 0;

  final productAsync = ref.watch(customerProductByIdProvider(item.productId));
  final product = productAsync.asData?.value;

  if (product == null) return 0;

  if (product.installation == true && product.installationFee != null) {
    return (product.installationFee! * item.quantity);
  }

  return 0;
});

//GRAND TOTAL
final cartTotalProvider = Provider<double>((ref) {
  final cartAsync = ref.watch(cartProvider);
  final cartItems = cartAsync.asData?.value ?? [];

  if (cartItems.isEmpty) return 0;

  double total = 0;

  for (final item in cartItems) {
    final price = ref.watch(cartItemPriceProvider(item.id));
    final installFee = ref.watch(cartItemInstallationFeeProvider(item.id));

    total += price + installFee;
  }

  return total;
});

final cartPointProvider = Provider<int>((ref) {
  final cartTotal = ref.watch(cartTotalProvider);

  return cartTotal.round();
});
