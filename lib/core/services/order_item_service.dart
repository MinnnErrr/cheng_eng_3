
import 'package:cheng_eng_3/core/models/order_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'order_item_service.g.dart';

@Riverpod(keepAlive: true)
OrderItemService orderItemService(Ref ref) {
  return OrderItemService();
}

class OrderItemService {
  final supabase = Supabase.instance.client;

  Future<void> create(OrderItem orderItem) async {
    await supabase.from('order_items').insert(orderItem.toJson());
  }

  Future<void> updateIsReady(bool isReady, String orderItemId) async {
    await supabase
        .from('order_items')
        .update({'isReady': isReady, 'updatedAt': DateTime.now().toIso8601String(),})
        .eq('id', orderItemId);
  }
}
