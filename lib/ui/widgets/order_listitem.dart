import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/ui/extensions/order_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _timeFormatter = DateFormat('dd/MM/yyyy').add_jm();

class OrderListitem extends ConsumerWidget {
  const OrderListitem({
    super.key,
    required this.order,
    required this.isStaff,
    required this.tapAction,
  });

  final Order order;
  final GestureTapCallback tapAction;
  final bool isStaff;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get the "Lead Item" (First item in the list)
    // Note: This relies on your Order model having the 'items' list populated
    final leadItem = (order.items != null && order.items!.isNotEmpty)
        ? order.items!.first
        : null;

    final otherItemCount = (order.items?.length ?? 0) - 1;

    return Card(
      child: InkWell(
        onTap: tapAction,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // --- ROW 1: HEADER (ID & DATE) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${order.id.substring(0, 10)}...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    _timeFormatter.format(order.createdAt),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Divider(height: 16),

              // --- ROW 2: BODY (IMAGE & SUMMARY) ---
              Row(
                children: [
                  // THUMBNAIL
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      image:
                          leadItem?.photoPaths != null &&
                              leadItem!.photoPaths.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(leadItem.photoPaths[0]),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: leadItem == null
                        ? const Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // TEXT SUMMARY
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leadItem?.productName ?? 'Unknown Items',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (otherItemCount > 0)
                          Text(
                            '+ $otherItemCount other items',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        const SizedBox(height: 4),
                        // DELIVERY METHOD ICON
                        Row(
                          children: [
                            Icon(
                              order.deliveryMethod == DeliveryMethod.delivery
                                  ? Icons.local_shipping_outlined
                                  : Icons.store_outlined,
                              size: 14,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order.deliveryMethod.label,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // PRICE
                  Text(
                    'RM ${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // --- ROW 3: FOOTER (CONTACT & STATUS) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CONTACT (Staff Only)
                  if (isStaff)
                    Row(
                      children: [
                        const Icon(Icons.call, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          order.deliveryPhoneNum == null
                              ? '${order.deliveryDialCode}${order.deliveryPhoneNum}'
                              : '${order.userDialCode}${order.userPhoneNum}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    )
                  else
                    const SizedBox(), // Spacer for customers
                  // STATUS CHIP
                  Chip(
                    label: Text(
                      order.status.label,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: order.status.color,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize
                        .shrinkWrap, // Removes extra padding
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
