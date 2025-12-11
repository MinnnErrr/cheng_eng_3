// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_reward_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerRewardNotifier)
const customerRewardProvider = CustomerRewardNotifierProvider._();

final class CustomerRewardNotifierProvider
    extends $AsyncNotifierProvider<CustomerRewardNotifier, List<Reward>> {
  const CustomerRewardNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRewardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRewardNotifierHash();

  @$internal
  @override
  CustomerRewardNotifier create() => CustomerRewardNotifier();
}

String _$customerRewardNotifierHash() =>
    r'ab54e190c7959f0b8fdaad3b199bbdcadfac6d73';

abstract class _$CustomerRewardNotifier extends $AsyncNotifier<List<Reward>> {
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
