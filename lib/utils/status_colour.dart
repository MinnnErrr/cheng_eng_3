import 'package:cheng_eng_3/core/models/product_model.dart';
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

Color getProductAvailabilityColor(
  ProductAvailability availability,
  int? quantity,
  BuildContext context,
) {
  switch (availability) {
    case ProductAvailability.ready:
      return quantity! > 0 ? Colors.green : Theme.of(context).colorScheme.error;
    case ProductAvailability.preorder:
      return Colors.orange;
  }
}

String getProductAvailabilityName(
  ProductAvailability availability,
  int? quantity,
  BuildContext context,
) {
  switch (availability) {
    case ProductAvailability.ready:
      return quantity! > 0 ? 'In Stock': 'Sold Out';
    case ProductAvailability.preorder:
      return 'Preorder';
  }
}

Color getRedeemedRewardStatusColor(bool isClaimed, BuildContext context) {
  switch (isClaimed) {
    case true:
      return Colors.grey;
    case false:
      return Colors.green;
  }
}
