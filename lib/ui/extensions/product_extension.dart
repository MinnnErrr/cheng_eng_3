

import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:flutter/material.dart';

extension ProductAvailabilityExtension on ProductAvailability {
  String get label {
    switch (this) {
      case ProductAvailability.ready:
        return 'Ready Stock';
      case ProductAvailability.preorder:
        return 'Preorder';
    }
  }

  Color get color {
    switch (this) {
      case ProductAvailability.ready:
        return Colors.green; // Ready stock → green
      case ProductAvailability.preorder:
        return Colors.orange; // Preorder → orange
    }
  }
}



