

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
    required this.installationTotal
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
          // --- IMAGE ---
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageBuilder(
              url: getUrl(),
              containerWidth: 80,
              containerHeight: 80,
              noImageContent: Container(
                height: 80,
                width: 80,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                ),
              ),
              context: context,
            ),
          ),
          const SizedBox(width: 15),

          // --- DETAILS (Middle) ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$brand $name ${model ?? ''}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (color != null)
                  Text(
                    color!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'x$quantity',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // --- PRICE (Right) ---
          Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'RM ${priceTotal.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (installationTotal != null &&
              installationTotal! > 0) ...[
            const SizedBox(height: 4),
            Text(
              '+ Install',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            ),
            Text(
              'RM ${installationTotal!.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ],
      )
        ],
      ),
    );
  }

  
}
