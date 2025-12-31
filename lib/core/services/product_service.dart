import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'product_service.g.dart';

@Riverpod(keepAlive: true)
ProductService productService(Ref ref) {
  return ProductService();
}

class ProductService {
  final supabase = Supabase.instance.client;

  Future<List<Product>> getAllProducts() async {
    final data = await supabase
        .from('products')
        .select()
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Product>((p) => Product.fromJson(p)).toList();
  }

  Future<List<Product>> getActiveProducts() async {
    final data = await supabase
        .from('products')
        .select()
        .isFilter('deletedAt', null)
        .eq('status', true)
        .order('createdAt', ascending: false);
    return data.map<Product>((p) => Product.fromJson(p)).toList();
  }

  Future<Product?> getByProductId(String id) async {
    final data = await supabase
        .from('products')
        .select()
        .eq('id', id)
        .maybeSingle();
    return data == null ? null : Product.fromJson(data);
  }

  Future<void> create(Product product) async {
    await supabase.from('products').insert(product.toJson());
  }

  Future<void> update(Product product) async {
    await supabase
        .from('products')
        .update(product.toJson())
        .eq('id', product.id);
  }

  Future<void> updateQuantity(int quantity, String productId) async {
    await supabase
        .from('products')
        .update({'quantity': quantity, 'updatedAt': DateTime.now()})
        .eq('id', productId);
  }

  Future<void> decreaseQuantity(String productId, int amount) async {
    await supabase.rpc(
      'decrease_product_quantity',
      params: {
        'p_id': productId,
        'amount': amount,
      },
    );
  }

  Future<void> updateStatus(bool isActive, String productId) async {
    await supabase
        .from('products')
        .update({
          'status': isActive,
          'updatedAt': DateTime.now().toIso8601String(),
        })
        .eq('id', productId);
  }

  Future<void> delete(String id) async {
    await supabase
        .from('products')
        .update({'deletedAt': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
