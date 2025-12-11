// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VehicleNotifier)
const vehicleProvider = VehicleNotifierProvider._();

final class VehicleNotifierProvider
    extends $AsyncNotifierProvider<VehicleNotifier, VehicleList> {
  const VehicleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicleNotifierHash();

  @$internal
  @override
  VehicleNotifier create() => VehicleNotifier();
}

String _$vehicleNotifierHash() => r'764bb213c1134c5134e61e97dff0ce135236c2d9';

abstract class _$VehicleNotifier extends $AsyncNotifier<VehicleList> {
  FutureOr<VehicleList> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<VehicleList>, VehicleList>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VehicleList>, VehicleList>,
              AsyncValue<VehicleList>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
