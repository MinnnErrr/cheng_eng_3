import 'package:cheng_eng_3/domain/models/order_item_model.dart';
import 'package:cheng_eng_3/domain/models/order_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'order_service.g.dart';

@Riverpod(keepAlive: true)
OrderService orderService(Ref ref) {
  return OrderService();
}

class OrderService {
  final supabase = Supabase.instance.client;

  Future<List<Order>> getAllOrder() async {
    final data = await supabase
        .from('orders')
        .select('*, order_items(*)')
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Order>((o) => Order.fromJson(o)).toList();
  }

  Future<List<Order>> getByUser(String userId) async {
    final data = await supabase
        .from('orders')
        .select('*, order_items(*)')
        .eq('userId', userId)
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Order>((o) => Order.fromJson(o)).toList();
  }

  Future<Order?> getByOrderId(String id) async {
    final data = await supabase
        .from('orders')
        .select('*, order_items(*)')
        .eq('id', id)
        .maybeSingle();
    return data == null ? null : Order.fromJson(data);
  }

  Future<void> createOrder(Order order, List<OrderItem> items) async {
    await supabase.from('orders').insert(order.toJson());

    // 2. Prepare items JSON
    final itemsJson = items.map((e) => e.toJson()).toList();

    // 3. Bulk Insert Items
    await supabase.from('order_items').insert(itemsJson);
  }

  Future<void> update(Order order) async {
    await supabase.from('orders').update(order.toJson()).eq('id', order.id);
  }

  Future<void> updateStatus(
    String status,
    String orderId,
  ) async {
    await supabase
        .from('orders')
        .update({
          'status': status,
          'updatedAt': DateTime.now().toIso8601String(),
        })
        .eq('id', orderId);
  }
}
