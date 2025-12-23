import 'package:cheng_eng_3/core/controllers/order/order_controller.dart';
import 'package:cheng_eng_3/core/controllers/order/order_providers.dart';
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/core/models/staff_order_details_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_order_details_notifier.g.dart';

@riverpod
class StaffOrderDetailNotifier extends _$StaffOrderDetailNotifier {
  @override
  FutureOr<StaffOrderDetailState> build(String orderId) async {
    // 1. Listen to Source
    final order = await ref.watch(orderByIdProvider(orderId).future);

    // 2. Handle Null (If order not found)
    if (order == null) {
      // Throwing here automatically sets the provider state to AsyncError
      throw Exception('Order with ID $orderId not found'); 
    }
    
    // 3. Wrap
    return StaffOrderDetailState(order: order);
  }

  /// Unified Action to advance the order to the next step
  Future<Message> advanceOrder() async {
    // 1. Capture State
    final previousState = state; // Keep full AsyncValue to revert if needed
    final currentStateData = state.value; // Extract actual data

    // Safety check: Can't advance if we don't have data loaded
    if (currentStateData == null) {
       return const Message(isSuccess: false, message: 'Data not loaded');
    }

    // 2. Trigger Loading Manually
    state = const AsyncLoading();

    try {
      final orderController = ref.read(orderControllerProvider.notifier);
      
      final result = await orderController.updateStatus(
        orderId: currentStateData.order.id, // Get ID from state, not arguments
        newStatus: currentStateData.nextStatus // Logic from your State Model
      );

      // 3. Revert on Logic Failure (API returns false)
      if (!result.isSuccess) {
         state = previousState; 
      }
      
      // Note: On Success, we DON'T set state manually.
      // We wait for Realtime -> orderByIdProvider -> build() to fire.
      
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      return Message(isSuccess: false, message: 'Failed to update status');
    }
  }

  Future<Message> cancelOrder() async {
    final previousState = state;
    final currentStateData = state.value;
    
    if (currentStateData == null) {
      return const Message(isSuccess: false, message: 'Data not loaded');
    }

    state = const AsyncLoading();

    try {
      final orderController = ref.read(orderControllerProvider.notifier);
      
      final result = await orderController.updateStatus(
        orderId: currentStateData.order.id,
        newStatus: OrderStatus.cancelled,
      );

      if (!result.isSuccess) state = previousState;
      
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      return Message(isSuccess: false, message: 'Failed to cancel order');
    }
  }
}