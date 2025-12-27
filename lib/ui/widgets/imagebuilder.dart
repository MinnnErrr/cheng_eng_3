import 'package:flutter/material.dart';

Widget imageBuilder({
  String? url,
  required double containerWidth,
  required double containerHeight,
  required Widget noImageContent,
  required BuildContext context,
}) {
  Widget imageContent;
  final theme = Theme.of(context);

  url != null
      ? imageContent = Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: theme.colorScheme.error,
            ),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          },
        )
      : imageContent = noImageContent;

  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: imageContent,
    ),
  );
}
