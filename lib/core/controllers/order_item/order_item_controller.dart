
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/services/order_item_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_item_controller.g.dart';

@riverpod
class OrderItemNotifier extends _$OrderItemNotifier {
  OrderItemService get _orderItemService => ref.read(orderItemServiceProvider);

  // Use family to pass the orderId
  @override
  FutureOr<void> build() async {}

  Future<Message> updateReady({
    required String orderItemId,
    required bool isReady
  }) async {
    state = const AsyncLoading();

    try{
      await _orderItemService.updateIsReady(isReady, orderItemId);

      state = const AsyncData(null);

      return Message(isSuccess: true, message: isReady ? 'Item marked as ready' : 'Item marked as not ready');
  
     
    }catch(e, st){
      state = AsyncError(e, st);
      return const Message(isSuccess: false, message: 'Failed to update item');
    }
  }
}