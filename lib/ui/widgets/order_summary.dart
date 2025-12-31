import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
import 'package:cheng_eng_3/core/models/order_item_model.dart';
import 'package:cheng_eng_3/ui/widgets/order_summary_listitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderSummary extends ConsumerWidget {
  const OrderSummary({
    super.key,
    required this.subtotal,
    this.deliveryFee,
    this.points,
    required this.total,
    required this.items,
  });

  final List<OrderItem>? items;
  final double subtotal;
  final double? deliveryFee;
  final int? points;
  final double total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: items == null
          ? const Center(child: Text('Error loading items'))
          : Column(
              children: [
                // 1. ITEMS LIST
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items!.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: theme.colorScheme.outlineVariant),
                  itemBuilder: (context, index) {
                    final item = items![index];
                    return OrderSummaryListItem(
                      photoPaths: item.photoPaths,
                      brand: item.productBrand,
                      name: item.productName,
                      model: item.productModel,
                      color: item.productColour,
                      quantity: item.quantity,
                      priceTotal: item.totalPrice,
                      installationTotal: item.totalInstallationFee,
                    );
                  },
                ),

                const Divider(
                  height: 40,
                ),

                // 2. TOTALS SECTION
                _buildDetailRow(
                  context,
                  'Subtotal',
                  'RM ${subtotal.toStringAsFixed(2)}',
                ),

                if (deliveryFee != null && deliveryFee! > 0)
                  _buildDetailRow(
                    context,
                    'Delivery Fee',
                    'RM ${deliveryFee!.toStringAsFixed(2)}',
                  ),

                const SizedBox(height: 10),

                // 3. GRAND TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Pay',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'RM ${total.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textYellow,
                      ),
                    ),
                  ],
                ),

                // 4. POINTS EARNED (Badge Style)
                if (points != null && points! > 0) ...[
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.7,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: theme.colorScheme.primary),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.stars,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '+ $points Points Earned',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  // Helper Widget for consistent styling
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface, // Dark Grey in light mode
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface, // Black/White
            ),
          ),
        ],
      ),
    );
  }
}
