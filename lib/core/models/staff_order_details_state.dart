import 'package:cheng_eng_3/core/models/order_model.dart';

class StaffOrderDetailState {
  final Order order;

  const StaffOrderDetailState({
    required this.order,
  });

  bool get isTerminal =>
      order.status == OrderStatus.cancelled ||
      order.status == OrderStatus.completed;

  String get primaryButtonLabel {
    switch (order.status) {
      case OrderStatus.unpaid:
        return 'Mark Paid'; 
      case OrderStatus.pending:
        return 'Accept Order';
      case OrderStatus.processing:
        return 'Mark Ready';
      case OrderStatus.ready:
        return order.deliveryMethod == DeliveryMethod.delivery
            ? 'Ship Order'
            : 'Complete Pickup';
      case OrderStatus.delivered:
        return 'Mark Completed';
      default:
        return '';
    }
  }

  bool get canProceed {
    switch (order.status) {
      case OrderStatus.unpaid:
        return true; 
      case OrderStatus.pending:
        return true;
      case OrderStatus.processing:
        return order.isFullyReady; 
      case OrderStatus.ready:
        return true;
      case OrderStatus.delivered:
        return true;
      default:
        return false;
    }
  }

  OrderStatus get nextStatus {
    switch (order.status) {
      case OrderStatus.unpaid:
        return OrderStatus.pending; 
      case OrderStatus.pending:
        return OrderStatus.processing;
      case OrderStatus.processing:
        return OrderStatus.ready;
      case OrderStatus.ready:
        return order.deliveryMethod == DeliveryMethod.delivery
            ? OrderStatus.delivered
            : OrderStatus.completed;
      case OrderStatus.delivered:
        return OrderStatus.completed;
      default:
        return order.status; 
    }
  }

  StaffOrderDetailState copyWith({Order? order, bool? isUpdating}) {
    return StaffOrderDetailState(
      order: order ?? this.order,
    );
  }
}
