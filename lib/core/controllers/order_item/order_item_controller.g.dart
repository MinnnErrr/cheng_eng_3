// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderItemNotifier)
const orderItemProvider = OrderItemNotifierProvider._();

final class OrderItemNotifierProvider
    extends $AsyncNotifierProvider<OrderItemNotifier, void> {
  const OrderItemNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderItemNotifierHash();

  @$internal
  @override
  OrderItemNotifier create() => OrderItemNotifier();
}

String _$orderItemNotifierHash() => r'6b5141879c2a1535b414e86e24de5805f9c0447c';

abstract class _$OrderItemNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
