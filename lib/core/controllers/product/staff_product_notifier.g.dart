// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_product_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaffProductNotifier)
const staffProductProvider = StaffProductNotifierProvider._();

final class StaffProductNotifierProvider
    extends $AsyncNotifierProvider<StaffProductNotifier, List<Product>> {
  const StaffProductNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffProductProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffProductNotifierHash();

  @$internal
  @override
  StaffProductNotifier create() => StaffProductNotifier();
}

String _$staffProductNotifierHash() =>
    r'a4b13dd3dee3c837bf8a9455756cfedb381f9ed8';

abstract class _$StaffProductNotifier extends $AsyncNotifier<List<Product>> {
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
