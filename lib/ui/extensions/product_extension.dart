import 'dart:io';

import 'package:cheng_eng_3/core/models/booking_model.dart';
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

extension BookingServiceExtension on BookingServiceType {
  String get serviceName {
    switch (this) {
      case BookingServiceType.service1:
        return 'service 1';
      case BookingServiceType.service2:
        return 'service 2';
      case BookingServiceType.service3:
        return 'service 3';
      case BookingServiceType.service4:
        return 'service 4';
    }
  }

  String get picture{
    switch(this){
      case BookingServiceType.service1:
        return 'assets/images/cheng_eng_logo.png';
      case BookingServiceType.service2:
        return 'assets/images/cheng_eng_logo.png';
      case BookingServiceType.service3:
        return 'assets/images/cheng_eng_logo.png';
      case BookingServiceType.service4:
        return 'assets/images/cheng_eng_logo.png';
    }
  }
}
