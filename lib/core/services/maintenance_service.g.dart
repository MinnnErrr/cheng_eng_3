// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(maintenanceService)
const maintenanceServiceProvider = MaintenanceServiceProvider._();

final class MaintenanceServiceProvider
    extends
        $FunctionalProvider<
          MaintenanceService,
          MaintenanceService,
          MaintenanceService
        >
    with $Provider<MaintenanceService> {
  const MaintenanceServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceServiceHash();

  @$internal
  @override
  $ProviderElement<MaintenanceService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MaintenanceService create(Ref ref) {
    return maintenanceService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MaintenanceService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MaintenanceService>(value),
    );
  }
}

String _$maintenanceServiceHash() =>
    r'34bba01c9c71efd8163e31bda7200fb63d273239';
