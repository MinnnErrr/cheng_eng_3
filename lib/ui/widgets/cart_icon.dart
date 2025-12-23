import 'package:cheng_eng_3/core/controllers/cart/cart_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartIconBadge extends ConsumerWidget {
  const CartIconBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. FIX: Handle AsyncValue
    final cartAsync = ref.watch(cartProvider);
    
    // We use valueOrNull: 
    // - If loading/error, it returns null (so we default to 0).
    // - This prevents the badge from flashing or crashing during load.
    final number = cartAsync.value?.itemCount ?? 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart),

        if (number > 0)
          Positioned(
            // UX TIP: Badges are usually Top-Right, not Bottom-Right
            right: -3, 
            top: -3,   
            child: Container(
              // REMOVED fixed width/height so it grows if number is "99+"
              // Added minWidth/minHeight constraints instead
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.error, // Red is standard for badges
              ),
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Text(
                  number > 99 ? '99+' : number.toString(), // UX Handle large numbers
                  style: TextStyle(
                    fontSize: 10, // Slightly readable size
                    color: Theme.of(context).colorScheme.onError,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}