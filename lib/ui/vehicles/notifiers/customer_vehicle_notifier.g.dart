// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_vehicle_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerVehicleNotifier)
const customerVehicleProvider = CustomerVehicleNotifierProvider._();

final class CustomerVehicleNotifierProvider
    extends $AsyncNotifierProvider<CustomerVehicleNotifier, VehicleList> {
  const CustomerVehicleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerVehicleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerVehicleNotifierHash();

  @$internal
  @override
  CustomerVehicleNotifier create() => CustomerVehicleNotifier();
}

String _$customerVehicleNotifierHash() =>
    r'033767bca5046f4f1c9a7d04a9abd659087579e3';

abstract class _$CustomerVehicleNotifier extends $AsyncNotifier<VehicleList> {
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
