import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:cheng_eng_3/ui/extensions/product_extension.dart';
import 'package:flutter/material.dart';

// Color getProductAvailabilityColor(
//   ProductAvailability availability,
//   int? quantity,
//   BuildContext context,
// ) {
//   switch (availability) {
//     case ProductAvailability.ready:
//       if (quantity! > 0) {
//         if (quantity <= 10) {
//           return Colors.orange;
//         }
//         return availability.color;
//       } else {
//         return Colors.red;
//       }
//     case ProductAvailability.preorder:
//       return availability.color;
//   }
// }

// String getProductAvailabilityName(
//   ProductAvailability availability,
//   int? quantity,
//   BuildContext context,
// ) {
//   switch (availability) {
//     case ProductAvailability.ready:
//       if (quantity! > 0) {
//         if (quantity <= 10) {
//           return 'Low Stock';
//         }
//         return availability.label;
//       } else {
//         return 'Sold Out';
//       }
//     case ProductAvailability.preorder:
//       return availability.label;
//   }
// }

// Color getRedeemedRewardStatusColor(bool isClaimed, BuildContext context) {
//   switch (isClaimed) {
//     case true:
//       return Colors.grey;
//     case false:
//       return Colors.green;
//   }
// }
