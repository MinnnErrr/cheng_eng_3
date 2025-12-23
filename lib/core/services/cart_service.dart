import 'package:cheng_eng_3/core/models/cart_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'cart_service.g.dart';

@Riverpod(keepAlive: true)
CartService cartService(Ref ref) {
  return CartService();
}

class CartService {
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

  Future<CartItem> getByItemId(String id) async {
    final data = await supabase
        .from('cart_items')
        .select()
        .eq('id', id)
        .single();
    return CartItem.fromJson(data);
  }

  Future<void> create(CartItem cartItem) async {
    await supabase.from('cart_items').insert(cartItem.toJson());
  }

  Future<void> updateQuantity(int quantity, String cartItemId) async {
    await supabase
        .from('cart_items')
        .update({'quantity': quantity})
        .eq('id', cartItemId);
  }

  Future<void> delete(String id) async {
    await supabase
        .from('cart_items')
        .update({'deletedAt': DateTime.now().toIso8601String()})
        .eq('id', id);
  }

  Future<void> clearCart(String userId) async {
    await supabase.from('cart_items').delete().eq('userId', userId);
  }
}
