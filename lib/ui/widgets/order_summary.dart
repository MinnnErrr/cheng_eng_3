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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: items == null
          ? const Center(child: Text('Error loading items'))
          : Column(
              children: [
                // 3. CRITICAL LAYOUT FIX: shrinkWrap + NeverScrollable
                ListView.separated(
                  shrinkWrap: true, // Takes only needed height
                  physics:
                      const NeverScrollableScrollPhysics(), // Disables inner scroll
                  itemCount: items!.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 24),
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

                const Divider(height: 32),

                // Totals Section
                _buildDetailRow(
                  'Subtotal',
                  'RM ${subtotal.toStringAsFixed(2)}',
                ),
                if (deliveryFee != null && deliveryFee != 0)
                  _buildDetailRow(
                    'Delivery Fee',
                    'RM ${deliveryFee!.toStringAsFixed(2)}',
                  ),

                const SizedBox(height: 8),

                // Grand Total (Bold)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'RM ${total.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Points (Subtle)
                if (points != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$points Points Earned',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
