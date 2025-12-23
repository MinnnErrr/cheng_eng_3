import 'package:cheng_eng_3/core/models/order_model.dart';

class StaffOrderDetailState {
  final Order order;
  // final bool isUpdating; // Tracks if we are currently calling API

  const StaffOrderDetailState({
    required this.order,
    // this.isUpdating = false,
  });

  // --- LOGIC HELPERS (Moved from View) ---

  /// Is the order Cancelled or Completed? (Hide Bottom Bar)
  bool get isTerminal =>
      order.status == OrderStatus.cancelled ||
      order.status == OrderStatus.completed;

  /// Logic for the Main Action Button Label
  String get primaryButtonLabel {
    switch (order.status) {
      case OrderStatus.unpaid:
        return 'Mark Paid'; // Scenario B implementation
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

  /// Logic for enabling/disabling the Main Action Button
  bool get canProceed {
    switch (order.status) {
      case OrderStatus.unpaid:
        return true; // Staff can always manually mark as paid
      case OrderStatus.pending:
        return true; // Staff can always accept
      case OrderStatus.processing:
        return order.isFullyReady; // Only if checklist complete
      case OrderStatus.ready:
        return true;
      case OrderStatus.delivered:
        return true;
      default:
        return false;
    }
  }

  /// Helper to calculate the NEXT status automatically
  OrderStatus get nextStatus {
    switch (order.status) {
      case OrderStatus.unpaid:
        return OrderStatus.pending; // Unpaid -> Pending
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
        return order.status; // No change
    }
  }

  StaffOrderDetailState copyWith({Order? order, bool? isUpdating}) {
    return StaffOrderDetailState(
      order: order ?? this.order,
      // isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}
