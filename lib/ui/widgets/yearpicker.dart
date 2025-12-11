import 'package:flutter/material.dart';

void yearPicker(BuildContext context, int? year, Function(DateTime) changeAction) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Select Year"),
        content: SizedBox(
          width: 300,
          height: 300,
          child: YearPicker(
            firstDate: DateTime(1900),
            lastDate: DateTime(2200),
            selectedDate: year == null ? DateTime.now() : DateTime(year),
            onChanged: (value) {
              changeAction(value);
              Navigator.pop(context);
            },
          ),
        ),
      );
    },
  );
}


