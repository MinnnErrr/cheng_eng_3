import 'package:flutter/material.dart';

Color getMaintenanceStatusColor(String status, BuildContext context) {
  switch (status.toLowerCase()) {
    case 'complete':
      return Colors.green;
    case 'incomplete':
    default:
      return Theme.of(context).colorScheme.error;
  }
}

Color getTowingStatusColor(String status, BuildContext context) {
  switch (status.toLowerCase()) {
    case 'complete':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'accepted':
      return Colors.blue;
    case 'cancelled':
    case 'declined':
    default:
      return Theme.of(context).colorScheme.error;
  }
}

Color getProductAvailabilityColor(String status, int? quantity, BuildContext context) {
  switch (status.toLowerCase()) {
    case 'ready stock':
      return quantity! > 0 ? Colors.green : Theme.of(context).colorScheme.error;
    case 'preorder':
      return Colors.orange;
    default:
      return Theme.of(context).colorScheme.error;
  }
}

