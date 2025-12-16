// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_rewards_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaffRewardsNotifier)
const staffRewardsProvider = StaffRewardsNotifierProvider._();

final class StaffRewardsNotifierProvider
    extends $AsyncNotifierProvider<StaffRewardsNotifier, List<Reward>> {
  const StaffRewardsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffRewardsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffRewardsNotifierHash();

  @$internal
  @override
  StaffRewardsNotifier create() => StaffRewardsNotifier();
}

String _$staffRewardsNotifierHash() =>
    r'225a03cb56d12f3f343d533087bd62a9dbdfedef';

abstract class _$StaffRewardsNotifier extends $AsyncNotifier<List<Reward>> {
  FutureOr<List<Reward>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Reward>>, List<Reward>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Reward>>, List<Reward>>,
              AsyncValue<List<Reward>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
