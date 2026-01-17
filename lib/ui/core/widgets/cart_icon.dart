import 'package:cheng_eng_3/ui/cart/notifiers/cart_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartIconBadge extends ConsumerWidget {
  final Widget icon;
  
  const CartIconBadge({
    super.key, 
    required this.icon, 
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final number = cartAsync.value?.itemCount ?? 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,

        if (number > 0)
          Positioned(
            right: -3,
            top: -3,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.error,
              ),
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Text(
                  number > 99 ? '99+' : number.toString(),
                  style: TextStyle(
                    fontSize: 10,
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