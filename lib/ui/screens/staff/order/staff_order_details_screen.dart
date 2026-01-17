import 'package:cheng_eng_3/core/controllers/order/staff_order_details_notifier.dart';
import 'package:cheng_eng_3/core/controllers/order_item/order_item_controller.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/core/models/staff_order_details_state.dart';
import 'package:cheng_eng_3/ui/extensions/order_extension.dart';
import 'package:cheng_eng_3/ui/widgets/order_summary.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _timeFormatter = DateFormat('dd MMM yyyy, h:mm a');

class StaffOrderDetailsScreen extends ConsumerWidget {
  const StaffOrderDetailsScreen({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(orderRealTimeProvider);

    final stateAsync = ref.watch(staffOrderDetailProvider(order.id));
    final viewState = stateAsync.value ?? StaffOrderDetailState(order: order);
    final currentOrder = viewState.order;
    final items = currentOrder.items;
    final theme = Theme.of(context);
    final itemNotifier = ref.read(orderItemProvider.notifier);
    final itemState = ref.watch(orderItemProvider);

    final fullAddress = [
      currentOrder.deliveryAddressLine1,
      currentOrder.deliveryAddressLine2,
      '${currentOrder.deliveryPostcode} ${currentOrder.deliveryCity}',
      '${currentOrder.deliveryState!.label}, ${currentOrder.deliveryCountry}',
    ].where((s) => s != null && s.trim().isNotEmpty).join(', ');

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: currentOrder.status.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: currentOrder.status.color.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'CURRENT STATUS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: currentOrder.status.color,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentOrder.status.label.toUpperCase(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: currentOrder.status.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#${currentOrder.id.toUpperCase()}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 2. TIMELINE DETAILS ---
            _SectionHeader(title: "Timeline"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    'Created',
                    _timeFormatter.format(currentOrder.createdAt),
                  ),
                  const Divider(height: 24),
                  _buildDetailRow(
                    context,
                    'Last Update',
                    currentOrder.updatedAt != null
                        ? _timeFormatter.format(currentOrder.updatedAt!)
                        : '-',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- 3. CUSTOMER INFO ---
            _SectionHeader(title: "Customer Information"),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  _buildDetailRow(context, 'Name', currentOrder.username),
                  const Divider(height: 24),
                  _buildDetailRow(context, 'Email', currentOrder.userEmail),
                  const Divider(height: 24),
                  _buildDetailRow(
                    context,
                    'Phone',
                    '${currentOrder.userDialCode} ${currentOrder.userPhoneNum}',
                  ),
                ],
              ),
            ),

            // --- 4. CHECKLIST (If Processing) ---
            if (currentOrder.status == OrderStatus.processing &&
                items != null) ...[
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionHeader(
                    title: "Preparation Checklist",
                    padding: 0,
                  ),
                  // Progress Chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: items.every((i) => i.isReady)
                          ? Colors.green
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${items.where((i) => i.isReady).length}/${items.length} Ready",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Checklist Items
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  children: items.map((item) {
                    final isUpdating = itemState.isLoading;
                    return Column(
                      children: [
                        CheckboxListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          title: Text(
                            "${item.productBrand} ${item.productName}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "Model: ${item.productModel ?? '-'} • Qty: ${item.quantity}",
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),

                          value: item.isReady,
                          onChanged: isUpdating
                              ? null
                              : (val) async {
                                  if (val == null) return;
                                  await itemNotifier.updateReady(
                                    orderItemId: item.id,
                                    isReady: val,
                                  );
                                },
                        ),
                        if (item != items.last) const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 30),

            // --- 5. ORDER SUMMARY ---
            _SectionHeader(title: "Order Summary"),
            OrderSummary(
              subtotal: currentOrder.subtotal,
              total: currentOrder.total,
              items: items,
              points: null,
              deliveryFee: currentOrder.deliveryFee,
            ),

            // --- 6. DELIVERY ADDRESS (Separated) ---
            if (currentOrder.deliveryMethod == DeliveryMethod.delivery) ...[
              const SizedBox(height: 30),
              _SectionHeader(title: "Delivery Details"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      'Name',
                      '${currentOrder.deliveryFirstName} ${currentOrder.deliveryLastName}',
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      'Phone',
                      '${currentOrder.deliveryDialCode} ${currentOrder.deliveryPhoneNum}',
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      'Address',
                      fullAddress,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 50), 
          ],
        ),
      ),

      // --- BOTTOM ACTION BAR ---
      bottomNavigationBar: viewState.isTerminal
          ? null
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 54,
                        child: OutlinedButton(
                          onPressed: stateAsync.isLoading
                              ? null
                              : () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text("Cancel Order?"),
                                      content: const Text(
                                        "This action cannot be undone.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text("Back"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          child: Text(
                                            "Confirm Cancel",
                                            style: TextStyle(
                                              color: theme.colorScheme.error,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm != true) return;

                                  final notifier = ref.read(
                                    staffOrderDetailProvider(order.id).notifier,
                                  );
                                  final msg = await notifier.cancelOrder();
                                  if (context.mounted && !msg.isSuccess) {
                                    showAppSnackBar(
                                      context: context,
                                      content: msg.message,
                                      isError: true,
                                    );
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: theme.colorScheme.outline,
                            ),
                            foregroundColor: theme.colorScheme.onSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("CANCEL"),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: FilledButton(
                        onPressed: stateAsync.isLoading || !viewState.canProceed
                            ? null
                            : () async {
                                final notifier = ref.read(
                                  staffOrderDetailProvider(order.id).notifier,
                                );
                                final msg = await notifier.advanceOrder();
                                if (context.mounted) {
                                  showAppSnackBar(
                                    context: context,
                                    content: msg.message,
                                    isError: !msg.isSuccess,
                                  );
                                }
                              },

                        child: stateAsync.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.black, 
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                viewState.primaryButtonLabel.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SelectableText(
            textAlign: TextAlign.right,
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

// Header Helper
class _SectionHeader extends StatelessWidget {
  final String title;
  final double padding;
  const _SectionHeader({required this.title, this.padding = 12});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
