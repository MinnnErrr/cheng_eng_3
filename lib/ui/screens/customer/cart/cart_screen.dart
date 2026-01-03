import 'package:cheng_eng_3/colorscheme/colorscheme.dart';
import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:cheng_eng_3/ui/screens/customer/cart/checkout_screen.dart';
import 'package:cheng_eng_3/ui/screens/customer/product/customer_product_screen.dart';
import 'package:cheng_eng_3/ui/widgets/cart_listitem.dart';
import 'package:cheng_eng_3/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // Helper: Check strictly for "Initial Loading" (No data yet)
    final isInitialLoading = cartAsync.isLoading && !cartAsync.hasValue;
    final isInitialError = cartAsync.hasError && !cartAsync.hasValue;

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: Builder(
        builder: (context) {
          // A. First Load Spinner
          if (isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // B. Fatal Error
          if (isInitialError) {
            return Center(child: Text('Error: ${cartAsync.error}'));
          }

          // C. Data State
          final cartState = cartAsync.value;
          final entries = cartState?.entries ?? [];

          // Empty State
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    // ✅ FIX: Use button for better UX
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CustomerProductScreen(),
                      ),
                    ),
                    child: const Text(
                      'Start Shopping',
                      style: TextStyle(color: textYellow),
                    ),
                  ),
                ],
              ),
            );
          }

          // List State
          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: entries.length,
            // Space items out cleanly
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final entry = entries[index];

              return CartListitem(
                entry: entry,
                incrementAction: () =>
                    cartNotifier.increaseQty(itemId: entry.item.id),
                decrementAction: () =>
                    cartNotifier.decreaseQty(itemId: entry.item.id),
                deleteAction: () async {
                  final message = await cartNotifier.deleteItem(entry.item.id);
                  if (context.mounted) {
                    showAppSnackBar(
                      context: context,
                      content: message.message,
                      isError: !message.isSuccess,
                    );
                  }
                },
              );
            },
          );
        },
      ),

      // 3. BOTTOM BAR (Refactored)
      bottomNavigationBar: Builder(
        builder: (context) {
          final cartState = cartAsync.value;
          if (cartState != null && cartState.entries.isNotEmpty) {
            return _CartBottomBar(
              subtotal: cartState.subtotal,
              isValid: cartState.isValid,
              isLoading: cartAsync.isLoading,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// Pure UI Bottom Bar
class _CartBottomBar extends StatelessWidget {
  const _CartBottomBar({
    required this.subtotal,
    required this.isValid,
    required this.isLoading,
  });

  final double subtotal;
  final bool isValid;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Using Container + SafeArea handles iPhone notches better than BottomAppBar
    return Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Subtotal Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Subtotal",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "RM ${subtotal.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textYellow,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Checkout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: (isValid && !isLoading)
                      ? () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CheckoutScreen(),
                          ),
                        )
                      : null,
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "CHECKOUT",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
