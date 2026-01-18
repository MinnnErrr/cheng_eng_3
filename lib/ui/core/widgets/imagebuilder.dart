import 'package:cheng_eng_3/ui/core/widgets/full_screen_image.dart';
import 'package:flutter/material.dart';

class ImageBuilder extends StatelessWidget {
  final String? url;
  final double width;
  final double height;
  final Widget noImageContent;
  final double borderRadius;
  final bool enableZoom;

  const ImageBuilder({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    required this.noImageContent,
    this.borderRadius = 12.0,
    this.enableZoom = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget imageContent;

    if (url != null) {
      Widget networkImage = Image.network(
        url!,
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
      );

      if (enableZoom) {
        imageContent = GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImageView(imageUrl: url!),
              ),
            );
          },
          child: Hero(
            tag: url!,
            child: networkImage,
          ),
        );
      } else {
        imageContent = networkImage;
      }
    } else {
      imageContent = noImageContent;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: imageContent,
      ),
    );
  }
}
