// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_towings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaffTowingsNotifier)
const staffTowingsProvider = StaffTowingsNotifierProvider._();

final class StaffTowingsNotifierProvider
    extends $AsyncNotifierProvider<StaffTowingsNotifier, List<Towing>> {
  const StaffTowingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffTowingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffTowingsNotifierHash();

  @$internal
  @override
  StaffTowingsNotifier create() => StaffTowingsNotifier();
}

String _$staffTowingsNotifierHash() =>
    r'09d055041d4e3373b7cb0112e1a5d47ade7bcdba';

abstract class _$StaffTowingsNotifier extends $AsyncNotifier<List<Towing>> {
  FutureOr<List<Towing>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Towing>>, List<Towing>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Towing>>, List<Towing>>,
              AsyncValue<List<Towing>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
