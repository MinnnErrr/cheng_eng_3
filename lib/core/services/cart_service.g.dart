// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cartService)
const cartServiceProvider = CartServiceProvider._();

final class CartServiceProvider
    extends $FunctionalProvider<CartService, CartService, CartService>
    with $Provider<CartService> {
  const CartServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartServiceHash();

  @$internal
  @override
  $ProviderElement<CartService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartService create(Ref ref) {
    return cartService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartService>(value),
    );
  }
}

String _$cartServiceHash() => r'c88eac90553f4e3b45761ce7ae7410b1178ecbb7';
