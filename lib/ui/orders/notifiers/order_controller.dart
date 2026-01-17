import 'package:cheng_eng_3/domain/models/message_model.dart';
import 'package:cheng_eng_3/domain/models/order_model.dart';
import 'package:cheng_eng_3/data/services/order_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_controller.g.dart';

@riverpod
class OrderController extends _$OrderController {
  OrderService get _orderService => ref.read(orderServiceProvider);

  @override
  FutureOr<void> build() {}

  Future<Message> updateStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    state = const AsyncLoading();

    try {
      await _orderService.updateStatus(newStatus.name, orderId);
      state = const AsyncData(null);
      return const Message(isSuccess: true, message: 'Order status updated');
    } catch (e, st) {
      state = AsyncError(e, st);
      return Message(isSuccess: false, message: 'Failed to update status: $e');
    }
  }
}
