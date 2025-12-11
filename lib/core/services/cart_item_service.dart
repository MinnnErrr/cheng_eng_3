import 'package:cheng_eng_3/core/models/cart_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'cart_item_service.g.dart';

@Riverpod(keepAlive: true)
CartItemService cartItemService(Ref ref) {
  return CartItemService();
}

class CartItemService {
  final supabase = Supabase.instance.client;

  Future<List<CartItem>> getCartItems(String userId) async {
    final data = await supabase
        .from('cart_items')
        .select()
        .eq('userId', userId)
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: true);
    return data.map<CartItem>((p) => CartItem.fromJson(p)).toList();
  }

  Future<CartItem> create(CartItem cartItem) async {
    final data = await supabase
        .from('cart_items')
        .insert(cartItem.toJson())
        .select()
        .single();
    return CartItem.fromJson(data);
  }

  Future<CartItem> updateQuantity(int quantity, String cartItemId) async {
    final data = await supabase
        .from('cart_items')
        .update({'quantity': quantity})
        .eq('id', cartItemId)
        .select()
        .single();
    return CartItem.fromJson(data);
  }

  Future<void> delete(String id) async {
    await supabase
        .from('cart_items')
        .update({'deletedAt': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
