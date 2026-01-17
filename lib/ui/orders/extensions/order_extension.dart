import 'package:cheng_eng_3/domain/models/order_model.dart';
import 'package:flutter/material.dart';

extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.unpaid:
        return 'Unpaid';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatus.unpaid:
        return Colors.red;
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String getMessage(DeliveryMethod method) {
    // We use a "Switch Expression" on a Record (tuple) logic
    return switch ((this, method)) {
      (OrderStatus.unpaid, _) => 'Please complete payment to proceed.',

      (OrderStatus.pending, _) =>
        "Your order is submitted. Waiting for staff confirmation.",

      (OrderStatus.processing, _) =>
        'Your order has been accepted and is being processed.',

      // SPECIFIC LOGIC: Status is Ready + Method is Pickup
      (OrderStatus.ready, DeliveryMethod.selfPickup) =>
        'Your items are ready for pickup at the workshop.',

      // SPECIFIC LOGIC: Status is Ready + Method is Delivery
      (OrderStatus.ready, DeliveryMethod.delivery) =>
        'Your order is packed and will be shipped out soon.',

      (OrderStatus.delivered, _) =>
        'Your order has been delivered successfully.',

      (OrderStatus.completed, _) =>
        'Order completed. Thank you for shopping with us!',

      (OrderStatus.cancelled, _) =>
        'This order was cancelled. We apologize for any inconvenience.',
    };
  }
}

extension DeliveryMethodExtension on DeliveryMethod {
  String get label {
    switch (this) {
      case DeliveryMethod.delivery:
        return 'Delivery';
      case DeliveryMethod.selfPickup:
        return 'Self-Pickup';
    }
  }
}

extension StateExtension on MalaysiaState {
  String get label {
    switch (this) {
      case MalaysiaState.johor:
        return 'Johor';
      case MalaysiaState.kedah:
        return 'Kedah';
      case MalaysiaState.kelantan:
        return 'Kelantan';
      case MalaysiaState.kualaLumpur:
        return 'Kuala Lumpur';
      case MalaysiaState.labuan:
        return 'Labuan';
      case MalaysiaState.melaka:
        return 'Melaka';
      case MalaysiaState.negeriSembilan:
        return 'Negeri Sembilan';
      case MalaysiaState.pahang:
        return 'Pahang';
      case MalaysiaState.perak:
        return 'Perak';
      case MalaysiaState.perlis:
        return 'Perlis';
      case MalaysiaState.pulauPinang:
        return 'Pulau Pinang';
      case MalaysiaState.putrajaya:
        return 'Putrajaya';
      case MalaysiaState.sabah:
        return 'Sabah';
      case MalaysiaState.sarawak:
        return 'Sarawak';
      case MalaysiaState.selangor:
        return 'Selangor';
      case MalaysiaState.terengganu:
        return 'Terengganu';
    }
  }
}
