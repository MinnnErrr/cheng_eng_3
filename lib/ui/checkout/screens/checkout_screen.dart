import 'package:cheng_eng_3/ui/core/theme/colorscheme.dart';
import 'package:cheng_eng_3/ui/checkout/notifiers/checkout_notifier.dart';
import 'package:cheng_eng_3/ui/checkout/notifiers/place_order_notifier.dart';
import 'package:cheng_eng_3/ui/checkout/notifiers/payment_notifier.dart';
import 'package:cheng_eng_3/ui/cart/notifiers/cart_entry_model.dart';
import 'package:cheng_eng_3/domain/models/order_model.dart';
import 'package:cheng_eng_3/ui/orders/extensions/order_extension.dart';
import 'package:cheng_eng_3/ui/orders/screens/customer/customer_order_details_screen.dart';
import 'package:cheng_eng_3/ui/orders/widgets/order_summary_listitem.dart';
import 'package:cheng_eng_3/utils/snackbar.dart';
import 'package:cheng_eng_3/ui/core/widgets/custom_text_field.dart';
import 'package:cheng_eng_3/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cheng_eng_3/data/services/payment_service.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _address1Ctrl = TextEditingController();
  final _address2Ctrl = TextEditingController();
  final _postcodeCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'Malaysia');

  String _countryCode = 'MY';
  String _dialCode = '+60';
  String _phoneNum = '';

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
    super.dispose();
  }

  Future<void> _handlePlaceOrder(dynamic checkout) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

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

      final String? orderId = await ref
          .read(placeOrderProvider.notifier)
          .placeOrder(
            cartState: checkout.cart,
            address: address,
            userId: user.id,
            method: checkout.method,
          );

      if (orderId == null) return;
      if (!mounted) return;

      final paymentResult = await ref
          .read(paymentProvider.notifier)
          .payForOrder(
            orderId: orderId,
            amount: checkout.total,
            userId: user.id,
            pointsToEarn: checkout.points,
            email: user.email!,
          );

      if (!mounted) return;

      String message = 'Payment failed';
      bool isError = true;

      switch (paymentResult) {
        case PaymentResult.success:
          message = 'Order paid successfully!';
          isError = false;
          break;
        case PaymentResult.canceled:
          message = 'Payment cancelled.';
          break;
        case PaymentResult.failed:
          message = 'Payment failed.';
          break;
      }

      showAppSnackBar(context: context, content: message, isError: isError);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => CustomerOrderDetailsScreen(
            orderId: orderId,
          ),
        ),
        (route) => route.isFirst,
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutAsync = ref.watch(checkoutProvider);
    final checkoutNotifier = ref.read(checkoutProvider.notifier);
    final placeOrderState = ref.watch(placeOrderProvider);
    final paymentState = ref.watch(paymentProvider);
    final bool isLoading = placeOrderState.isLoading || paymentState.isLoading;
    final theme = Theme.of(context);

    ref.listen(placeOrderProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        showAppSnackBar(
          context: context,
          content: next.error.toString(),
          isError: true,
        );
      }
    });
    ref.listen(paymentProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        showAppSnackBar(
          context: context,
          content: next.error.toString(),
          isError: true,
        );
      }
    });
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
                    // --- 1. ORDER SUMMARY CARD ---
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order Summary",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                ),
                                onPressed: () => _showOrderSummarySheet(
                                  context,
                                  cartEntries,
                                ),
                                child: Text("View ${cartEntries.length} Items"),
                              ),
                            ],
                          ),
                          const Divider(),
                          _buildTotalRow(
                            'Subtotal',
                            'RM ${checkout.cart.subtotal.toStringAsFixed(2)}',
                          ),
                          if (checkout.method == DeliveryMethod.delivery)
                            _buildTotalRow(
                              'Delivery',
                              'RM ${checkout.deliveryFee.toStringAsFixed(2)}',
                            ),
                          _buildTotalRow(
                            'Points earned',
                            '${checkout.points} pts',
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total Pay",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'RM ${checkout.total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: textYellow,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- 2. DELIVERY METHOD ---
                    Text(
                      'Delivery Method',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (checkout.hasInstallation)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info, color: Colors.orange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Items requiring installation must be picked up at the workshop.",
                                style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _DeliveryOptionCard(
                              label: "Pickup",
                              icon: Icons.store_mall_directory_outlined,
                              isSelected:
                                  checkout.method == DeliveryMethod.selfPickup,
                              onTap: () => checkoutNotifier.setDeliveryMethod(
                                DeliveryMethod.selfPickup,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DeliveryOptionCard(
                              label: "Delivery",
                              icon: Icons.local_shipping_outlined,
                              isSelected:
                                  checkout.method == DeliveryMethod.delivery,
                              onTap: () => checkoutNotifier.setDeliveryMethod(
                                DeliveryMethod.delivery,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 30),

                    // --- 3. SHIPPING FORM ---
                    if (checkout.method == DeliveryMethod.delivery) ...[
                      Text(
                        'Shipping Details',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _shippingForm(checkoutNotifier, checkout.selectedState),
                      const SizedBox(height: 30),
                    ],

                    // --- 4. REMARKS ---
                    Text(
                      'Remarks',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- 5. PLACE ORDER BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        onPressed: isLoading || !checkout.canPlaceOrder
                            ? null
                            : () => _handlePlaceOrder(checkout),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'PLACE ORDER • RM ${checkout.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
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
              child: Customtextfield(
                controller: _firstNameCtrl,
                label: 'First Name',
                validator: Validators.maxLength(50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Customtextfield(
                controller: _lastNameCtrl,
                label: 'Last Name',
                validator: Validators.maxLength(50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        IntlPhoneField(
          initialCountryCode: _countryCode,
          initialValue: _phoneNum,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            counterText: "", 
          ),
          onChanged: (value) {
            _dialCode = value.countryCode;
            _countryCode = value.countryISOCode;
            _phoneNum = value.number;
          },
        ),
        const SizedBox(height: 20),
        Customtextfield(controller: _address1Ctrl, label: 'Address Line 1', validator: Validators.maxLength(100),),
        const SizedBox(height: 20),
        Customtextfield(
          controller: _address2Ctrl,
          label: 'Address Line 2 (Optional)',
          isRequired: false,
          validator: Validators.maxLength(100),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Customtextfield(
                controller: _postcodeCtrl,
                label: 'Postcode',
                keyboardType: TextInputType.number,
                validator: Validators.postcode
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Customtextfield(
                controller: _cityCtrl,
                label: 'City',
                validator: Validators.maxLength(50),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<MalaysiaState>(
                initialValue: selectedState,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'State',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                items: MalaysiaState.values.map((s) {
                  return DropdownMenuItem(
                    value: s,
                    child: Text(s.label.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => notifier.setStateSelection(value),
                validator: (value) => value == null ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Customtextfield(
                controller: _countryCtrl,
                label: 'Country',
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
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

class _DeliveryOptionCard extends StatelessWidget {
  const _DeliveryOptionCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = isSelected
        ? theme
              .colorScheme
              .secondaryContainer 
        : theme.colorScheme.surface;

    final borderColor = isSelected
        ? theme
              .colorScheme
              .onSecondaryContainer 
        : theme.colorScheme.outline; 

    final contentColor = isSelected
        ? theme
              .colorScheme
              .onSecondaryContainer 
        : theme.colorScheme.onSurfaceVariant; 

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: isSelected ? 2.0 : 1.0),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: contentColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: contentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
