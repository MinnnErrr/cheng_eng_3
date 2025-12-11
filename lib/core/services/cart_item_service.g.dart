// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(cartItemService)
const cartItemServiceProvider = CartItemServiceProvider._();

final class CartItemServiceProvider
    extends
        $FunctionalProvider<CartItemService, CartItemService, CartItemService>
    with $Provider<CartItemService> {
  const CartItemServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartItemServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartItemServiceHash();

  @$internal
  @override
  $ProviderElement<CartItemService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CartItemService create(Ref ref) {
    return cartItemService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CartItemService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartItemService>(value),
    );
  }
}

String _$cartItemServiceHash() => r'5792385e3d75c2a7bcd61a8e85198865291dd316';
