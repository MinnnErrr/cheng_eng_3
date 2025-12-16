// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(orderService)
const orderServiceProvider = OrderServiceProvider._();

final class OrderServiceProvider
    extends $FunctionalProvider<OrderService, OrderService, OrderService>
    with $Provider<OrderService> {
  const OrderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderServiceHash();

  @$internal
  @override
  $ProviderElement<OrderService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderService create(Ref ref) {
    return orderService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderService>(value),
    );
  }
}

String _$orderServiceHash() => r'2125a0ed59ad153d5852acc8066fdd01ac595b36';
