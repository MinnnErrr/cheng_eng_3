import 'package:cheng_eng_3/core/controllers/order/order_providers.dart';
import 'package:cheng_eng_3/core/controllers/payment/payment_notifier.dart';
import 'package:cheng_eng_3/core/controllers/realtime_provider.dart'; // Ensure this matches your file path
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/ui/extensions/order_extension.dart'; // Ensure this matches your file path
import 'package:cheng_eng_3/ui/widgets/order_delivery.dart';
import 'package:cheng_eng_3/ui/widgets/order_summary.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cheng_eng_3/core/services/payment_service.dart';

// Move formatter to global scope for performance
final _timeFormatter = DateFormat('dd/MM/yyyy').add_jm();

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
    // 1. Trigger Payment
    // We reuse the exact same logic from the Checkout Screen
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

    // 2. Handle Result
    String message;
    bool isError = false;

    switch (result) {
      case PaymentResult.success:
        message = 'Payment Successful! Status will update shortly.';
        isError = false;
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

    showAppSnackBar(
      context: context,
      content: message,
      isError: isError,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String effectiveId = widget.order?.id ?? widget.orderId!;
    // 1. Activate Realtime Listener
    ref.watch(orderRealTimeProvider);

    // Watch Payment State (To show loading spinner on button)
    final paymentState = ref.watch(paymentProvider);
    final isPaying = paymentState.isLoading;

    // 2. Data Fetching
    final orderAsync = ref.watch(orderByIdProvider(effectiveId));
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

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
          children: [
            // --- HEADER SECTION ---
            Text(
              'Order Status',
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
                  // Status Banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: currentOrder.status.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: currentOrder.status.color,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            // Correctly call the extension method
                            currentOrder.status.getMessage(
                              currentOrder.deliveryMethod,
                            ),
                            style: TextStyle(
                              color: currentOrder.status.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Key Value Rows
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

            const SizedBox(height: 24),

            // --- SUMMARY SECTION ---
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            OrderSummary(
              subtotal: currentOrder.subtotal,
              total: currentOrder.total,
              items: items,
              points: currentOrder.points,
              deliveryFee: currentOrder.deliveryFee,
            ),

            //address
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
                    state: currentOrder.deliveryState!,
                  ),
                ],
              ),

            if (currentOrder.status == OrderStatus.unpaid) ...[
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // High visibility color
                    foregroundColor: Colors.black,
                  ),
                  // Disable button if payment is currently processing
                  onPressed: isPaying
                      ? null
                      : () => _handlePayment(currentOrder!),
                  child: isPaying
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method to keep code clean DRY (Don't Repeat Yourself)
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
