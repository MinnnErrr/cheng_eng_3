import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderSummaryListItem extends ConsumerWidget {
  const OrderSummaryListItem({
    super.key,
    required this.photoPaths,
    required this.brand,
    required this.name,
    required this.model,
    required this.color,
    required this.quantity,
    required this.priceTotal,
    required this.installationTotal,
  });

  final List<String> photoPaths;
  final String brand;
  final String name;
  final String? model;
  final String? color;
  final int quantity;
  final double priceTotal;
  final double? installationTotal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final theme = Theme.of(context);

    String? getUrl() {
      return photoPaths.isNotEmpty
          ? imageService.retrieveImageUrl(photoPaths.first)
          : null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- 1. IMAGE ---
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageBuilder(
              url: getUrl(),
              containerWidth: 80,
              containerHeight: 80,
              noImageContent: Container(
                height: 80,
                width: 80,
                color: theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              context: context,
            ),
          ),
          const SizedBox(width: 16),

          // --- 2. DETAILS ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$brand $name ${model ?? ''}',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (color != null)
                  Text(
                    color!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Qty: $quantity',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // --- 3. PRICE ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'RM ${priceTotal.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (installationTotal != null && installationTotal! > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '+ Install: RM ${installationTotal!.toStringAsFixed(2)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textYellow,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
