import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:flutter/material.dart';

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

  String get picture {
    switch (this) {
      case BookingServiceType.service1:
        return 'assets/images/service.jpg';
      case BookingServiceType.service2:
        return 'assets/images/service.jpg';
      case BookingServiceType.service3:
        return 'assets/images/service.jpg';
      case BookingServiceType.service4:
        return 'assets/images/service.jpg';
    }
  }
}

extension BookingStatusExtension on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.accepted:
        return Colors.blue;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.green;
    }
  }
}
