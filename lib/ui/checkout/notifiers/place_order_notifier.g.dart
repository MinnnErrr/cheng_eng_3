// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_order_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlaceOrderNotifier)
const placeOrderProvider = PlaceOrderNotifierProvider._();

final class PlaceOrderNotifierProvider
    extends $AsyncNotifierProvider<PlaceOrderNotifier, void> {
  const PlaceOrderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeOrderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeOrderNotifierHash();

  @$internal
  @override
  PlaceOrderNotifier create() => PlaceOrderNotifier();
}

String _$placeOrderNotifierHash() =>
    r'4356851669fab236aef1085645166966193aa23b';

abstract class _$PlaceOrderNotifier extends $AsyncNotifier<void> {
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
