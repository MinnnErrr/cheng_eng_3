// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maintenance_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MaintenanceNotifier)
const maintenanceProvider = MaintenanceNotifierProvider._();

final class MaintenanceNotifierProvider
    extends $AsyncNotifierProvider<MaintenanceNotifier, MaintenanceList> {
  const MaintenanceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maintenanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maintenanceNotifierHash();

  @$internal
  @override
  MaintenanceNotifier create() => MaintenanceNotifier();
}

String _$maintenanceNotifierHash() =>
    r'24cbe2c2792f5b512f3cde5904bc40cd19904626';

abstract class _$MaintenanceNotifier extends $AsyncNotifier<MaintenanceList> {
  FutureOr<MaintenanceList> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<MaintenanceList>, MaintenanceList>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MaintenanceList>, MaintenanceList>,
              AsyncValue<MaintenanceList>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
