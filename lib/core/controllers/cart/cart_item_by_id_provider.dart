
import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/core/models/cart_item_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartItemByIdProvider = FutureProvider.family<CartItem, String>(
  (ref, itemId) async {
    final items = await ref.watch(cartProvider.future);

    final item = items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => throw Exception('Towing not found'),
    );

    return item;
  },
);