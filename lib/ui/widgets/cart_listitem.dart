import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
import 'package:cheng_eng_3/core/models/cart_entry_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartListitem extends ConsumerWidget {
  const CartListitem({
    super.key,
    required this.entry,
    required this.incrementAction,
    required this.decrementAction,
    required this.deleteAction,
  });

  final CartEntry entry;
  final VoidCallback incrementAction;
  final VoidCallback decrementAction;
  final VoidCallback deleteAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final theme = Theme.of(context);
    final product = entry.product;
    final item = entry.item;

    // --- 1. HANDLE DELETED/INVALID PRODUCT ---
    if (product == null) {
      return Card(
        color: theme.colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: theme.colorScheme.onErrorContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Item unavailable',
                  style: TextStyle(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: deleteAction,
                icon: Icon(
                  Icons.delete,
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // --- 2. NORMAL PRODUCT ---
    final isSoldOut = entry.isSoldOut;
    final isMaxStock = entry.isMaxStock;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // CONTENT
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // A. Image (Square)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageBuilder(
                    url: product.photoPaths.isNotEmpty
                        ? imageService.retrieveImageUrl(
                            product.photoPaths.first,
                          )
                        : null,
                    containerWidth: 90,
                    containerHeight: 90,
                    noImageContent: Container(
                      width: 90,
                      height: 90,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    context: context,
                  ),
                ),
                const SizedBox(width: 12),

                // B. Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row (Name + Delete)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${product.brand} ${product.name} ${product.model ?? ''}',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: deleteAction,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Attributes (Color / Install Tag)
                      Wrap(
                        spacing: 8,
                        children: [
                          if (product.colour != null)
                            Text(
                              product.colour!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          if (entry.hasInstallation)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "+ Installation",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Footer Row (Pricing + Stepper)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Price Breakdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RM ${entry.priceTotal.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // ✅ INSTALLATION PRICE DISPLAY (Requested Feature)
                              if (entry.installationTotal > 0)
                                Text(
                                  '+ Install: RM ${entry.installationTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: textYellow,
                                  ),
                                ),
                            ],
                          ),

                          // Quantity Stepper
                          Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                _StepperButton(
                                  icon: Icons.remove,
                                  onTap: decrementAction,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _StepperButton(
                                  icon: Icons.add,
                                  onTap: (isSoldOut || isMaxStock)
                                      ? null
                                      : incrementAction,
                                  color: (isSoldOut || isMaxStock)
                                      ? Colors.grey
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // C. Sold Out Overlay
          if (isSoldOut)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.5),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'SOLD OUT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Small helper for the stepper buttons
class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, this.onTap, this.color});
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Icon(icon, size: 16, color: color ?? Colors.black87),
      ),
    );
  }
}
