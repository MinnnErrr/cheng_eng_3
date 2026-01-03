import 'package:cheng_eng_3/core/controllers/order/order_providers.dart';
import 'package:cheng_eng_3/core/controllers/payment/payment_notifier.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart';
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/ui/extensions/order_extension.dart';
import 'package:cheng_eng_3/ui/widgets/order_delivery.dart';
import 'package:cheng_eng_3/ui/widgets/order_summary.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cheng_eng_3/core/services/payment_service.dart';

final _timeFormatter = DateFormat('dd MMM yyyy, h:mm a');

class CustomerOrderDetailsScreen extends ConsumerStatefulWidget {
  const CustomerOrderDetailsScreen({super.key, this.order, this.orderId});
  final Order? order;
  final String? orderId;

  @override
  ConsumerState<CustomerOrderDetailsScreen> createState() =>
      _CustomerOrderDetailsScreenState();
}

class _CustomerOrderDetailsScreenState
    extends ConsumerState<CustomerOrderDetailsScreen> {
  Future<void> _handlePayment(Order order) async {
    final result = await ref
        .read(paymentProvider.notifier)
        .payForOrder(
          orderId: order.id,
          amount: order.total,
          userId: order.userId,
          pointsToEarn: order.points,
          email: order.userEmail,
        );

    if (!mounted) return;

    String message;
    bool isError = false;

    switch (result) {
      case PaymentResult.success:
        message = 'Payment Successful! Status will update shortly.';
        break;
      case PaymentResult.canceled:
        message = 'Payment cancelled';
        isError = true;
        break;
      case PaymentResult.failed:
        message = 'Payment failed. Please try again.';
        isError = true;
        break;
    }

    showAppSnackBar(context: context, content: message, isError: isError);
  }

  @override
  Widget build(BuildContext context) {
    final String effectiveId = widget.order?.id ?? widget.orderId!;
    ref.watch(orderRealTimeProvider);

    final paymentState = ref.watch(paymentProvider);
    final isPaying = paymentState.isLoading;
    final theme = Theme.of(context);

    final orderAsync = ref.watch(orderByIdProvider(effectiveId));

    // Optimistic / Fallback logic
    Order? currentOrder;
    if (orderAsync.hasValue) {
      currentOrder = orderAsync.value;
    } else if (widget.order != null) {
      currentOrder = widget.order;
    }

    if (currentOrder == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final items = currentOrder.items;

    final fullAddress = [
      currentOrder.deliveryAddressLine1,
      currentOrder.deliveryAddressLine2,
      '${currentOrder.deliveryPostcode} ${currentOrder.deliveryCity}',
      '${currentOrder.deliveryState!.label}, ${currentOrder.deliveryCountry}',
    ].where((s) => s != null && s.trim().isNotEmpty).join(', ');

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. STATUS HEADER ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // Use Status Color for background with low opacity
                  color: currentOrder.status.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: currentOrder.status.color.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      currentOrder.status.label.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: currentOrder.status.color,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentOrder.status.getMessage(
                        currentOrder.deliveryMethod,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- 2. ORDER INFO CARD ---
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
                      'Order ID',
                      '#${currentOrder.id.substring(0, 8)}',
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      'Date',
                      _timeFormatter.format(currentOrder.createdAt),
                    ),
                    const Divider(height: 24),
                    _buildDetailRow(
                      context,
                      'Method',
                      currentOrder.deliveryMethod.label,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- 3. ORDER SUMMARY ---
              Text(
                'Order Summary',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Ensure OrderSummary handles its own styling, but we wrap it for consistency
              OrderSummary(
                subtotal: currentOrder.subtotal,
                total: currentOrder.total,
                items: items,
                points: currentOrder.points,
                deliveryFee: currentOrder.deliveryFee,
              ),

              // --- 4. DELIVERY DETAILS ---
              if (currentOrder.deliveryMethod == DeliveryMethod.delivery) ...[
                const SizedBox(height: 30),
                Text(
                  'Delivery Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
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

              // --- 5. PAY NOW BUTTON ---
              if (currentOrder.status == OrderStatus.unpaid) ...[
                const SizedBox(height: 40),
                FilledButton(
                  onPressed: isPaying
                      ? null
                      : () => _handlePayment(currentOrder!),
                  child: isPaying
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'PAY NOW',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),

                const SizedBox(height: 20),
              ],
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
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: SelectableText(
            textAlign: TextAlign.right,
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
