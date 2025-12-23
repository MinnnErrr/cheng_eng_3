import 'package:cheng_eng_3/core/controllers/order/order_controller.dart'; // Import your controller
import 'package:cheng_eng_3/core/controllers/order/order_providers.dart';
import 'package:cheng_eng_3/core/controllers/order/staff_order_details_notifier.dart';
import 'package:cheng_eng_3/core/controllers/order_item/order_item_controller.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/core/models/staff_order_details_state.dart';
import 'package:cheng_eng_3/ui/extensions/order_extension.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:cheng_eng_3/ui/widgets/order_delivery.dart';
import 'package:cheng_eng_3/ui/widgets/order_summary.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Move formatter to global scope for performance
final _timeFormatter = DateFormat('dd/MM/yyyy').add_jm();

class StaffOrderDetailsScreen extends ConsumerWidget {
  const StaffOrderDetailsScreen({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Activate Realtime Listener (Background)
    ref.watch(orderRealTimeProvider);

    // 2. Watch the Staff Detail Notifier
    final stateAsync = ref.watch(staffOrderDetailProvider(order.id));

    // 3. Construct View State (Optimistic)
    // If AsyncValue has data, use it. If loading/null, wrap the 'order' passed in constructor.
    // This ensures buttons/labels appear immediately without waiting for the fetch.
    final viewState = stateAsync.value ?? StaffOrderDetailState(order: order);
    final currentOrder = viewState.order;
    final items = currentOrder.items;

    // 1. For Item Actions (Checkboxes)
    final itemNotifier = ref.read(orderItemProvider.notifier);
    // Watch this to disable checkboxes while one is updating
    final itemState = ref.watch(orderItemProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER SECTION ---
            Text(
              'Order Info',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Order ID',
                    currentOrder.id,
                  ),
                  _buildDetailRow(
                    'Status',
                    currentOrder.status.label,
                    color: currentOrder.status.color,
                  ),
                  _buildDetailRow(
                    'Created at',
                    _timeFormatter.format(currentOrder.createdAt),
                  ),
                  _buildDetailRow(
                    'Updated at',
                    currentOrder.updatedAt != null
                        ? _timeFormatter.format(currentOrder.updatedAt!)
                        : '-',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- COLLAPSIBLE CUSTOMER INFO ---
            // Wrapped in ExpansionTile to hide details if not needed
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
                collapsedShape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
                title: Text(
                  'Customer Info',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                childrenPadding: const EdgeInsets.all(16).copyWith(top: 0),
                children: [
                  _buildDetailRow('Username', currentOrder.username),
                  _buildDetailRow('Email', currentOrder.userEmail),
                  _buildDetailRow(
                    'Phone Number',
                    '${currentOrder.userDialCode}${currentOrder.userPhoneNum}',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // --- COLLAPSIBLE ORDER SUMMARY ---
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
                collapsedShape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
                title: Text(
                  'Order Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                childrenPadding: const EdgeInsets.all(16).copyWith(top: 0),
                children: [
                  OrderSummary(
                    subtotal: currentOrder.subtotal,
                    total: currentOrder.total,
                    items: items,
                    points: null,
                    deliveryFee: currentOrder.deliveryFee,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- DELIVERY INFO (Conditional) ---
            if (currentOrder.deliveryMethod == DeliveryMethod.delivery)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Info',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  OrderDelivery(
                    firstName: currentOrder.deliveryFirstName!,
                    lastName: currentOrder.deliveryLastName!,
                    addressLine1: currentOrder.deliveryAddressLine1!,
                    addressLine2: currentOrder.deliveryAddressLine2,
                    city: currentOrder.deliveryCity!,
                    country: currentOrder.deliveryCountry!,
                    dialCode: currentOrder.deliveryDialCode!,
                    phoneNum: currentOrder.deliveryPhoneNum!,
                    postcode: currentOrder.deliveryPostcode!,
                    state:
                        currentOrder.deliveryState!, // Assuming enum has .label
                  ),
                  const SizedBox(height: 24),
                ],
              ),

            // --- CHECKLIST SECTION (Only if Processing) ---
            if (currentOrder.status == OrderStatus.processing && items != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item Checklist',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      // Helper text to show progress
                      Text(
                        "${items.where((i) => i.isReady).length}/${items.length} Ready",
                        style: TextStyle(
                          color: items.every((i) => i.isReady)
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Checklist Container
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: items.map((item) {
                        final isUpdating = itemState.isLoading;
                        final imageUrl = item.photoPaths.isNotEmpty
                            ? item.photoPaths.first
                            : '';

                        return CheckboxListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          secondary: imageBuilder(
                            url: imageUrl,
                            containerWidth: 50,
                            containerHeight: 50,
                            noImageContent: const Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey,
                              size: 24,
                            ),
                            context: context,
                          ),
                          title: Text(
                            [
                              item.productBrand,
                              item.productName,
                              item.productModel ?? '', // Handle null safely
                            ].join(' ').trim(), // Removes extra spaces
                            // 2. LIMIT LINES (Optional but recommended)
                            // For staff, maybe allow 2 lines so they can read the full model number.
                            overflow: TextOverflow
                                .ellipsis, // Adds "..." if it's still too long
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ), // Make title slightly bold
                          ),
                          subtitle: Text('x${item.quantity}'),
                          value: item.isReady,
                          activeColor: Colors.green,
                          onChanged: isUpdating
                              ? null
                              : (bool? newValue) async {
                                  if (newValue == null) return;

                                  await itemNotifier.updateReady(
                                    orderItemId: item.id,
                                    isReady: newValue,
                                  );
                                },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
          ],
        ),
      ),

      // --- FIXED BOTTOM UPDATE BAR ---
      bottomNavigationBar: viewState.isTerminal
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
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
                      child: OutlinedButton(
                        onPressed: stateAsync.isLoading
                            ? null
                            : () async {
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
                        child: const Text('Cancel Order'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        // Disable if Processing AND not all items are ready
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
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            // Logic: Ask State "What is my label?"
                            : Text(viewState.primaryButtonLabel),
                      ),
                    ),
                  ],
                ),
              ),
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
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: Text(
              textAlign: TextAlign.right,
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
