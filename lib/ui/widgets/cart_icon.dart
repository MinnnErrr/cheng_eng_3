import 'package:cheng_eng_3/core/controllers/cart/cart_number_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget cartIcon(WidgetRef ref, BuildContext context) {
  final number = ref.watch(cartNumberProvider);

  return Stack(
    clipBehavior: Clip.none,
    children: [
      const Icon(Icons.shopping_cart),

      if (number > 0)
        Positioned(
          right: -3,
          bottom: -3,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: const EdgeInsets.all(2),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 8,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
    ],
  );
}
