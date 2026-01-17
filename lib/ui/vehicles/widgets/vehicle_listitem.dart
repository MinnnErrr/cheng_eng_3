import 'package:cheng_eng_3/data/services/image_service.dart';
import 'package:cheng_eng_3/ui/core/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleListitem extends ConsumerWidget {
  const VehicleListitem({
    super.key,
    required this.make,
    required this.model,
    required this.regNum,
    this.description,
    this.year,
    this.colour,
    this.photoPath,
    this.icon,
    this.onTap,
  });

  final String make;
  final String model;
  final String regNum;
  final String? description;
  final int? year;
  final String? colour;
  final String? photoPath;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final List<String> footerDetails = [];
    if (year != null) footerDetails.add(year.toString());
    if (colour != null) footerDetails.add(colour!);
    final footerText = footerDetails.join(" | ");

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              //picture
              imageBuilder(
                url: photoPath != null
                    ? imageService.retrieveImageUrl(photoPath!)
                    : null,
                containerWidth: 80,
                containerHeight: 80,
                noImageContent: Container(
                  color: theme.surfaceContainerHigh,
                  child: Icon(
                    Icons.directions_car_filled_outlined,
                    color: theme.onSurfaceVariant,
                    size: 30,
                  ),
                ),
                context: context,
              ),

              const SizedBox(
                width: 16,
              ),

              //details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (description != null && description!.isNotEmpty) ...[
                      Text(
                        description!,
                        style: textTheme.labelMedium?.copyWith(
                          color: const Color(0xFF9E7C00),
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Registration (Title)
                    Text(
                      regNum.toUpperCase(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: theme.onSurface, 
                      ),
                    ),

                    // Make & Model (Subtitle)
                    Text(
                      '$make $model',
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.onSurface, 
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (footerText.isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        footerText,
                        style: textTheme.labelMedium?.copyWith(
                          color: theme.onSurfaceVariant, 
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (icon != null) ...[
                const SizedBox(width: 8),
                icon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
