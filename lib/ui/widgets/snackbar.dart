import 'package:flutter/material.dart';

void showAppSnackBar({
  required BuildContext context,
  required String content,
  bool isError = false,
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,

    margin: const EdgeInsets.all(16),

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),

    backgroundColor: isError ? colorScheme.error : Colors.green.shade700,

    duration: const Duration(seconds: 4),

    content: Row(
      children: [
        Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
          color: Colors.white,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
