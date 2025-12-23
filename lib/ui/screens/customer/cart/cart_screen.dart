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
    // 1. WATCH THE UNIFIED STATE
    final cartAsync = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    // 2. HELPER: Check strictly for "Initial Loading" (No data yet)
    final isInitialLoading = cartAsync.isLoading && !cartAsync.hasValue;
    final isInitialError = cartAsync.hasError && !cartAsync.hasValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Builder(
        builder: (context) {
          // A. Handle First Load Spinner
          if (isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // B. Handle Fatal Error
          if (isInitialError) {
            return Center(child: Text('Error: ${cartAsync.error}'));
          }

          // C. Handle Data (Use valueOrNull to persist data during background refreshes)
          final cartState = cartAsync.value;
          final entries = cartState?.entries ?? [];

          // Empty State
          if (entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Your cart is empty'),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CustomerProductScreen(),
                      ),
                    ),
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            );
          }

          // List State
          return SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const Divider(height: 40),
              itemBuilder: (context, index) {
                final entry = entries[index];

                return CartListitem(
                  entry: entry,
                  incrementAction: () => cartNotifier.increaseQty(
                    itemId: entry.item.id,
                  ),
                  decrementAction: () => cartNotifier.decreaseQty(
                    itemId: entry.item.id,
                  ),
                  deleteAction: () async {
                    final message = await cartNotifier.deleteItem(
                      entry.item.id,
                    );
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
            ),
          );
        },
      ),

      // 3. BOTTOM BAR
      // We pass the calculated values directly from the state.
      // No more watching providers inside the bottom bar.
      bottomNavigationBar: Builder(
        builder: (context) {
          final cartState = cartAsync.value;

          // Only show if we have entries
          if (cartState != null && cartState.entries.isNotEmpty) {
            return _CartBottomBar(
              subtotal: cartState.subtotal, // Calculated in Model
              isValid: cartState.isValid, // Calculated in Model
              isLoading: cartAsync.isLoading, // Spinner logic
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ------------------------------------------------------
// Refactored to be a Pure UI Widget (Stateless)
// It doesn't need to know about Providers anymore.
// ------------------------------------------------------
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
    return BottomAppBar(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- SUBTOTAL ROW ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Subtotal"),
              Text(
                "RM ${subtotal.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const Spacer(),

          // --- CHECKOUT BUTTON ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: (isValid && !isLoading)
                  ? () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    )
                  : null, // Disabled if invalid or currently loading
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}
