import 'package:cheng_eng_3/core/controllers/checkout/checkout_notifier.dart';
import 'package:cheng_eng_3/core/controllers/order/place_order_notifier.dart';
import 'package:cheng_eng_3/core/controllers/payment/payment_notifier.dart';
import 'package:cheng_eng_3/core/models/cart_entry_model.dart';
import 'package:cheng_eng_3/core/models/order_model.dart';
import 'package:cheng_eng_3/ui/extensions/order_extension.dart';
import 'package:cheng_eng_3/ui/screens/customer/order/customer_order_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/order_summary_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:cheng_eng_3/ui/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cheng_eng_3/core/services/payment_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _address1Ctrl = TextEditingController();
  final _address2Ctrl = TextEditingController();
  final _postcodeCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'Malaysia');
  final _remarksCtrl = TextEditingController();

  // Phone Logic
  String _countryCode = 'MY';
  String _dialCode = '+60';
  String _phoneNum = '';

  // Flags
  bool _isDataPreFilled = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _address1Ctrl.dispose();
    _address2Ctrl.dispose();
    _postcodeCtrl.dispose();
    _cityCtrl.dispose();
    _countryCtrl.dispose();
    _remarksCtrl.dispose();
    super.dispose();
  }

  Future<void> _handlePlaceOrder(dynamic checkout) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        showAppSnackBar(
          context: context,
          content: 'User not found',
          isError: true,
        );
        return;
      }

      // 1. Prepare Address
      final address = Address(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        countryCode: _countryCode,
        dialCode: _dialCode,
        phoneNum: _phoneNum,
        line1: _address1Ctrl.text,
        line2: _address2Ctrl.text.isNotEmpty ? _address2Ctrl.text : null,
        postcode: _postcodeCtrl.text,
        city: _cityCtrl.text,
        state: checkout.selectedState ?? MalaysiaState.kualaLumpur,
        country: 'Malaysia',
      );

      // 2. STEP 1: CREATE ORDER
      // We call the notifier and wait for the ID
      final String? orderId = await ref
          .read(placeOrderProvider.notifier)
          .placeOrder(
            cartState: checkout.cart,
            address: address,
            userId: user.id,
            method: checkout.method,
          );

      // If orderId is null, Step 1 failed.
      // The Error Listener (ref.listen) in build() will show the error snackbar.
      if (orderId == null) return;

      if (!mounted) return;

      // 3. STEP 2: PAYMENT
      // We have the ID, now we ask for money.
      final paymentResult = await ref
          .read(paymentProvider.notifier)
          .payForOrder(
            orderId: orderId,
            amount: checkout.total,
            userId: user.id,
            pointsToEarn: checkout.points,
            // 👇 Add these lines
            email: user.email!,
          );

      if (!mounted) return;

      String message;
      bool isError = false;

      switch (paymentResult) {
        case PaymentResult.success:
          message = 'Order paid successfully!';
          isError = false;
          break;
        case PaymentResult.canceled:
          message = 'Order created, but payment was cancelled.';
          isError =
              true; // Or use orange/warning color if your snackbar supports it
          break;
        case PaymentResult.failed:
          message = 'Payment failed. Please try again.';
          isError = true;
          break;
      }

      // Show the message
      showAppSnackBar(context: context, content: message, isError: isError);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CustomerOrderDetailsScreen(
            orderId: orderId,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. WATCH Checkout State (Single Source of Truth)
    final checkoutAsync = ref.watch(checkoutProvider);
    final checkoutNotifier = ref.read(checkoutProvider.notifier);

    // Watch both to determine if we are busy
    final placeOrderState = ref.watch(placeOrderProvider);
    final paymentState = ref.watch(paymentProvider);

    final bool isLoading = placeOrderState.isLoading || paymentState.isLoading;

    // A. Listen for Order Creation Errors
    ref.listen(placeOrderProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        showAppSnackBar(
          context: context,
          content: next.error.toString(),
          isError: true,
        );
      }
    });

    // B. Listen for CRITICAL Payment Errors (The Desync Exception)
    ref.listen(paymentProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        // This catches the scary "Money taken but DB failed" error
        showAppSnackBar(
          context: context,
          content: next.error.toString(),
          isError: true,
        );
      }
    });

    // 3. PRE-FILL DATA
    ref.listen(checkoutProvider, (previous, next) {
      next.whenData((state) {
        if (!_isDataPreFilled && state.profile != null) {
          setState(() {
            if (state.profile!.phoneNum.isNotEmpty) {
              _countryCode = state.profile!.countryCode;
              _phoneNum = state.profile!.phoneNum;
            }

            _isDataPreFilled = true;
          });
        }
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: checkoutAsync.when(
        data: (checkout) {
          // ACCESS NEW NESTED STATE
          final cartEntries = checkout.cart.entries;

          if (cartEntries.isEmpty && !_isProcessing) {
            return const Center(child: Text('Cart is empty'));
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Order Summary ---
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () =>
                              _showOrderSummarySheet(context, cartEntries),
                          icon: const Icon(Icons.list),
                          label: Text('${cartEntries.length} Items'),
                        ),
                        // SUBTOTAL (Direct access, no async)
                        Text(
                          'RM ${checkout.cart.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- Delivery Method Dropdown ---
                    Text(
                      'Delivery Method',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<DeliveryMethod>(
                      initialValue: checkout.method,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: checkout.hasInstallation
                          ? null
                          : (value) {
                              if (value != null) {
                                checkoutNotifier.setDeliveryMethod(value);
                              }
                            },
                      items: DeliveryMethod.values.map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Text(method.label),
                        );
                      }).toList(),
                    ),

                    if (checkout.hasInstallation)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.amber),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Items requiring installation must be picked up at the workshop.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 30),

                    // --- Shipping Form ---
                    if (checkout.method == DeliveryMethod.delivery) ...[
                      Text(
                        'Shipping Information',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _shippingForm(checkoutNotifier, checkout.selectedState),
                      const SizedBox(height: 30),
                    ],

                    // --- Remarks ---
                    Text(
                      'Remarks',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    textFormField(
                      controller: _remarksCtrl,
                      label: 'Optional message...',
                      validationRequired: false,
                      minLines: 3,
                      maxLines: null,
                    ),

                    const SizedBox(height: 30),
                    const Divider(),

                    // --- Totals ---
                    _buildTotalRow('Subtotal', checkout.cart.subtotal),

                    if (checkout.method == DeliveryMethod.delivery)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Fee'),
                            Text(
                              'RM ${checkout.deliveryFee.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total'),
                        Text(
                          'RM ${checkout.total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Points earned'),
                        Text(
                          '${checkout.points}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // --- Place Order Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading || !checkout.canPlaceOrder
                            ? null
                            : () => _handlePlaceOrder(checkout),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('Place Order'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildTotalRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          'RM ${value.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _shippingForm(
    CheckoutNotifier notifier,
    MalaysiaState? selectedState,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: textFormField(
                controller: _firstNameCtrl,
                label: 'First Name',
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: textFormField(
                controller: _lastNameCtrl,
                label: 'Last Name',
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        IntlPhoneField(
          initialCountryCode: _countryCode,
          initialValue: _phoneNum,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _dialCode = value.countryCode;
              _countryCode = value.countryISOCode;
              _phoneNum = value.number;
            });
          },
        ),
        const SizedBox(height: 15),
        textFormField(controller: _address1Ctrl, label: 'Address Line 1'),
        const SizedBox(height: 15),
        textFormField(
          controller: _address2Ctrl,
          label: 'Address Line 2 (Optional)',
          validationRequired: false,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: textFormField(
                controller: _postcodeCtrl,
                label: 'Postcode',
                validationRequired: true,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: textFormField(
                controller: _cityCtrl,
                label: 'City',
                validationRequired: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<MalaysiaState>(
                initialValue: selectedState,
                hint: const Text('Select State'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                items: MalaysiaState.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(
                      s.name.toUpperCase(),
                    ), // Ensure you have .label extension if needed
                  );
                }).toList(),
                onChanged: (value) => notifier.setStateSelection(value),
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: textFormField(
                controller: _countryCtrl,
                label: 'Country',
                validationRequired: true,
                enabled: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showOrderSummarySheet(BuildContext context, List<CartEntry> items) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Order Items",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final cartEntry = items[index];
                      final product = cartEntry.product;
                      if (product == null) return const SizedBox.shrink();

                      return OrderSummaryListItem(
                        photoPaths: product.photoPaths,
                        brand: product.brand,
                        name: product.name,
                        model: product.model,
                        color: product.colour,
                        quantity: cartEntry.item.quantity,
                        priceTotal: cartEntry.priceTotal,
                        installationTotal: cartEntry.installationTotal,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
