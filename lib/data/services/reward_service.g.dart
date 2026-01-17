// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rewardService)
const rewardServiceProvider = RewardServiceProvider._();

final class RewardServiceProvider
    extends $FunctionalProvider<RewardService, RewardService, RewardService>
    with $Provider<RewardService> {
  const RewardServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rewardServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rewardServiceHash();

  @$internal
  @override
  $ProviderElement<RewardService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RewardService create(Ref ref) {
    return rewardService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RewardService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RewardService>(value),
    );
  }
}

String _$rewardServiceHash() => r'e9eda3448f8ab0612843d2cbf3e0bbdbec9bf296';
