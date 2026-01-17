import 'package:cheng_eng_3/core/models/product_model.dart';
import 'package:flutter/material.dart';

extension ProductAvailabilityExtension on ProductAvailability {
  String getlabel(int? quantity) {
    switch (this) {
      case ProductAvailability.ready:
        if (quantity! > 0) {
          if (quantity <= 10) {
            return 'Low Stock';
          }
          return 'Ready Stock';
        } else {
          return 'Sold Out';
        }
      case ProductAvailability.preorder:
        return 'Preorder';
    }
  }

  String get dropDownOption {
    switch (this) {
      case ProductAvailability.ready:
        return 'Ready Stock';
      case ProductAvailability.preorder:
        return 'Preorder';
    }
  }

  Color getcolor(int? quantity) {
    switch (this) {
      case ProductAvailability.ready:
        if (quantity! > 0) {
          if (quantity <= 10) {
            return Colors.orange;
          }
          return Colors.green;
        } else {
          return Colors.red;
        }
      case ProductAvailability.preorder:
        return Colors.blue;
    }
  }
}
