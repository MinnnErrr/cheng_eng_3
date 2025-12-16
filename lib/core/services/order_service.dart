
import 'package:cheng_eng_3/core/models/order_model.dart';
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
        .select()
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Order>((o) => Order.fromJson(o)).toList();
  }

  Future<List<Order>> getByUser(String userId) async {
    final data = await supabase
        .from('orders')
        .select()
        .eq('userId', userId)
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Order>((o) => Order.fromJson(o)).toList();
  }

  Future<Order> getByOrderId(String id) async {
    final data = await supabase.from('orders').select().eq('id', id).single();
    return Order.fromJson(data);
  }

  Future<void> create(Order order) async {
    await supabase.from('orders').insert(order.toJson());
  }

  Future<void> update(Order order) async {
    await supabase
        .from('orders')
        .update(order.toJson())
        .eq('id', order.id);
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
