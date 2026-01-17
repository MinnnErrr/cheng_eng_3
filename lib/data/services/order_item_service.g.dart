// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderItemService)
const orderItemServiceProvider = OrderItemServiceProvider._();

final class OrderItemServiceProvider
    extends
        $FunctionalProvider<
          OrderItemService,
          OrderItemService,
          OrderItemService
        >
    with $Provider<OrderItemService> {
  const OrderItemServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderItemServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderItemServiceHash();

  @$internal
  @override
  $ProviderElement<OrderItemService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderItemService create(Ref ref) {
    return orderItemService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderItemService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderItemService>(value),
    );
  }
}

String _$orderItemServiceHash() => r'0b5385b00c42f2a5f3114a78a449d2bee0a19f81';
