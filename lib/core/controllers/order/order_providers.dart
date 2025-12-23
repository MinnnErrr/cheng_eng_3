import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/core/services/order_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final staffOrdersProvider =
    FutureProvider<List<Order>>((ref) async {
  final service = ref.read(orderServiceProvider);
  return await service.getAllOrder();
});

final customerOrdersProvider = FutureProvider.family<List<Order>, String>((ref, userId) async {
  final service = ref.read(orderServiceProvider);
  return await service.getByUser(userId);
});

final orderByIdProvider = FutureProvider.family<Order?, String>((ref, orderId) async {
  final service = ref.read(orderServiceProvider);
  return await service.getByOrderId(orderId);
});
