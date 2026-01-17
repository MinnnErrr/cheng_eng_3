// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeemed_reward_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(redeemedRewardService)
const redeemedRewardServiceProvider = RedeemedRewardServiceProvider._();

final class RedeemedRewardServiceProvider
    extends
        $FunctionalProvider<
          RedeemedRewardService,
          RedeemedRewardService,
          RedeemedRewardService
        >
    with $Provider<RedeemedRewardService> {
  const RedeemedRewardServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'redeemedRewardServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$redeemedRewardServiceHash();

  @$internal
  @override
  $ProviderElement<RedeemedRewardService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RedeemedRewardService create(Ref ref) {
    return redeemedRewardService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RedeemedRewardService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RedeemedRewardService>(value),
    );
  }
}

String _$redeemedRewardServiceHash() =>
    r'1e3c1abacf57d685f455a75cd45e48a64078a03d';
