// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_rewards_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerRewardsNotifier)
const customerRewardsProvider = CustomerRewardsNotifierProvider._();

final class CustomerRewardsNotifierProvider
    extends $AsyncNotifierProvider<CustomerRewardsNotifier, List<Reward>> {
  const CustomerRewardsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRewardsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRewardsNotifierHash();

  @$internal
  @override
  CustomerRewardsNotifier create() => CustomerRewardsNotifier();
}

String _$customerRewardsNotifierHash() =>
    r'e06dfdae081349e34f27c2c7d91844bcd50a4d6f';

abstract class _$CustomerRewardsNotifier extends $AsyncNotifier<List<Reward>> {
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
