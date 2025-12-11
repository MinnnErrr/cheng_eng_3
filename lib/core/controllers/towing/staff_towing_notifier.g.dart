// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_towing_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaffTowingNotifier)
const staffTowingProvider = StaffTowingNotifierProvider._();

final class StaffTowingNotifierProvider
    extends $AsyncNotifierProvider<StaffTowingNotifier, List<Towing>> {
  const StaffTowingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffTowingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffTowingNotifierHash();

  @$internal
  @override
  StaffTowingNotifier create() => StaffTowingNotifier();
}

String _$staffTowingNotifierHash() =>
    r'65b2aee42c9e907c90151ffd530d3d861cfbc30f';

abstract class _$StaffTowingNotifier extends $AsyncNotifier<List<Towing>> {
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
