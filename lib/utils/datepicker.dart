import 'package:flutter/material.dart';

Future<DateTime?> datePicker(BuildContext context, {
  DateTime? initialDate,
  DateTime? firstDate
}) async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: DateTime(2200),
      initialDate: initialDate ?? DateTime.now(),
    );

    return pickedDate;
  }