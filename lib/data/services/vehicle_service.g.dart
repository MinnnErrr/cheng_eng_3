// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vehicleService)
const vehicleServiceProvider = VehicleServiceProvider._();

final class VehicleServiceProvider
    extends $FunctionalProvider<VehicleService, VehicleService, VehicleService>
    with $Provider<VehicleService> {
  const VehicleServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vehicleServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vehicleServiceHash();

  @$internal
  @override
  $ProviderElement<VehicleService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VehicleService create(Ref ref) {
    return vehicleService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VehicleService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VehicleService>(value),
    );
  }
}

String _$vehicleServiceHash() => r'f8443cb6849a5f52c09ac7a38249e298d3249f2c';
