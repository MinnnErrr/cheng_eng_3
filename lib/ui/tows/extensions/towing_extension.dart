import 'package:cheng_eng_3/domain/models/towing_model.dart';
import 'package:flutter/material.dart';

extension TowingStatusExtension on TowingStatus {
  String get label {
    switch (this) {
      case TowingStatus.pending:
        return 'Pending';
      case TowingStatus.accepted:
        return 'Accepted';
      case TowingStatus.declined:
        return 'Declined';
      case TowingStatus.completed:
        return 'Completed';
      case TowingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case TowingStatus.pending:
        return Colors.orange;
      case TowingStatus.accepted:
        return Colors.blue;
      case TowingStatus.declined:
        return Colors.red;
      case TowingStatus.completed:
        return Colors.green;
      case TowingStatus.cancelled:
        return Colors.red;
    }
  }

  IconData get statusIcon {
    switch (this) {
      case TowingStatus.cancelled:
        return Icons.cancel_presentation;
      case TowingStatus.declined:
        return Icons.cancel_presentation;
      case TowingStatus.accepted:
        return Icons.near_me;
      case TowingStatus.completed:
        return Icons.check_circle;
      case TowingStatus.pending:
        return Icons.hourglass_top;
    }
  }

  String get statusMessage {
    switch (this) {
      case TowingStatus.cancelled:
        return 'You cancelled this request';
      case TowingStatus.declined:
        return 'Sorry. Request cannot be fulfilled';
      case TowingStatus.accepted:
        return 'Help is on the way';
      case TowingStatus.completed:
        return 'Thanks for choosing us';
      case TowingStatus.pending:
        return 'Waiting for staff to accept...';
    }
  }
}
