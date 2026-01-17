import 'package:flutter/material.dart';

Future<DateTime?> datePicker(DateTime? initialDate, BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
      initialDate: initialDate,
    );

    return pickedDate;
  }