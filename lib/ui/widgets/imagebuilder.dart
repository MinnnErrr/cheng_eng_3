import 'package:flutter/material.dart';

// Widget imageBuilder(
//   String? imageUrl, {
//   required double width,
//   required double height,
//   required Icon icon,
// }) {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(10),
//     child: Container(
//       width: width,
//       height: height,
//       color: Colors.grey[300],
//       child: imageUrl == null
//           ? Center(child: icon)
//           : Image.network(
//               imageUrl,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) => Center(
//                 child: const Icon(Icons.image_not_supported),
//               ),
//               loadingBuilder: (context, child, loadingProgress) =>
//                   loadingProgress == null
//                   ? child
//                   : Center(
//                       child: CircularProgressIndicator(
//                         strokeWidth: 3,
//                       ),
//                     ),
//             ),
//     ),
//   );
// }

Widget imageBuilder({
  String? url,
  required double containerWidth,
  required double containerHeight,
  required Widget noImageContent,
  required BuildContext context,
}) {
  Widget imageContent;

  url != null
      ? imageContent = Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: const Icon(Icons.image_not_supported),
          ),
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null
              ? child
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
        )
      : imageContent = noImageContent;

  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      height: containerHeight,
      width: containerWidth,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: imageContent,
    ),
  );
}
