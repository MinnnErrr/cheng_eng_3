import 'package:cheng_eng_3/data/providers/order/order_providers.dart';
import 'package:cheng_eng_3/domain/models/message_model.dart';
import 'package:cheng_eng_3/domain/models/order_model.dart';
import 'package:cheng_eng_3/ui/orders/notifiers/staff_order_details_state.dart';
import 'package:cheng_eng_3/data/services/order_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_order_details_notifier.g.dart';

@riverpod
class StaffOrderDetailNotifier extends _$StaffOrderDetailNotifier {
  OrderService get _orderService => ref.read(orderServiceProvider);

  @override
  FutureOr<StaffOrderDetailState> build(String orderId) async {
    final order = await ref.watch(orderByIdProvider(orderId).future);
    if (order == null) throw Exception('Order with ID $orderId not found');
    return StaffOrderDetailState(order: order);
  }

  Future<Message> advanceOrder() async {
    final previousState = state;
    final currentStateData = state.value;

    if (currentStateData == null) {
      return const Message(isSuccess: false, message: 'Data not loaded');
    }

    bool isMounted = true;
    ref.onDispose(() => isMounted = false);

    state = const AsyncLoading();

    try {
      await _orderService.updateStatus(
        currentStateData.nextStatus.name,
        currentStateData.order.id,
      );

      return const Message(isSuccess: true, message: 'Status updated');
    } catch (e) {
      if (isMounted) {
        state = previousState;
      }
      return const Message(
        isSuccess: false,
        message: 'Failed to update status',
      );
    }
  }

  Future<Message> cancelOrder() async {
    final previousState = state;
    final currentStateData = state.value;

    if (currentStateData == null) {
      return const Message(isSuccess: false, message: 'Data not loaded');
    }

    bool isMounted = true;
    ref.onDispose(() => isMounted = false);

    state = const AsyncLoading();

    try {
      await _orderService.updateStatus(
        OrderStatus.cancelled.name,
        currentStateData.order.id,
      );

      return const Message(isSuccess: true, message: 'Order cancelled');
    } catch (e) {
      if (isMounted) {
        state = previousState;
      }
      return const Message(isSuccess: false, message: 'Failed to cancel order');
    }
  }
}
