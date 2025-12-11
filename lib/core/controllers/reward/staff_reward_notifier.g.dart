// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_reward_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaffRewardNotifier)
const staffRewardProvider = StaffRewardNotifierProvider._();

final class StaffRewardNotifierProvider
    extends $AsyncNotifierProvider<StaffRewardNotifier, List<Reward>> {
  const StaffRewardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffRewardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffRewardNotifierHash();

  @$internal
  @override
  StaffRewardNotifier create() => StaffRewardNotifier();
}

String _$staffRewardNotifierHash() =>
    r'1f5a07dcdef90735c63d1b6b947f9d35109a19f0';

abstract class _$StaffRewardNotifier extends $AsyncNotifier<List<Reward>> {
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
