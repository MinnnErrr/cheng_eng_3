// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_product_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerProductNotifier)
const customerProductProvider = CustomerProductNotifierProvider._();

final class CustomerProductNotifierProvider
    extends $AsyncNotifierProvider<CustomerProductNotifier, List<Product>> {
  const CustomerProductNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerProductProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerProductNotifierHash();

  @$internal
  @override
  CustomerProductNotifier create() => CustomerProductNotifier();
}

String _$customerProductNotifierHash() =>
    r'1dbdc907a6ac883457aa7642a01fa3e9d495c38d';

abstract class _$CustomerProductNotifier extends $AsyncNotifier<List<Product>> {
  FutureOr<List<Product>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
              AsyncValue<List<Product>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
