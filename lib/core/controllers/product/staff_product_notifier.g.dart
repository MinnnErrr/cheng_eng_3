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
    r'a1778ff9fc29f9b3c712485af4f50ff5a5f26b3e';

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
