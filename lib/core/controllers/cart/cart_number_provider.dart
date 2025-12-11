
import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartNumberProvider = Provider<int>((ref) {
  final cartAsync = ref.watch(cartProvider);
  final cartItems = cartAsync.asData?.value ?? [];

  if (cartItems.isEmpty) return 0;

  return cartItems.length;
});
