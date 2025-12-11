import 'package:flutter/material.dart';

void showAppSnackBar({
  required BuildContext context,
  required String content,
  bool isError = false,
}) {
  final snackBar = SnackBar(
    padding: const EdgeInsets.all(10),
    duration: const Duration(seconds: 4),
    content: Text(
      content,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor:
        isError ? Theme.of(context).colorScheme.error : Colors.green,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
