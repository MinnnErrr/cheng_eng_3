// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redeemed_reward_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RedeemedRewardNotifier)
const redeemedRewardProvider = RedeemedRewardNotifierFamily._();

final class RedeemedRewardNotifierProvider
    extends
        $AsyncNotifierProvider<RedeemedRewardNotifier, List<RedeemedReward>> {
  const RedeemedRewardNotifierProvider._({
    required RedeemedRewardNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'redeemedRewardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$redeemedRewardNotifierHash();

  @override
  String toString() {
    return r'redeemedRewardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RedeemedRewardNotifier create() => RedeemedRewardNotifier();

  @override
  bool operator ==(Object other) {
    return other is RedeemedRewardNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$redeemedRewardNotifierHash() =>
    r'a2b30206f3c5ae312729e8dd002d0a00b020daab';

final class RedeemedRewardNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          RedeemedRewardNotifier,
          AsyncValue<List<RedeemedReward>>,
          List<RedeemedReward>,
          FutureOr<List<RedeemedReward>>,
          String
        > {
  const RedeemedRewardNotifierFamily._()
    : super(
        retry: null,
        name: r'redeemedRewardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RedeemedRewardNotifierProvider call(String userId) =>
      RedeemedRewardNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'redeemedRewardProvider';
}

abstract class _$RedeemedRewardNotifier
    extends $AsyncNotifier<List<RedeemedReward>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<RedeemedReward>> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<AsyncValue<List<RedeemedReward>>, List<RedeemedReward>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<RedeemedReward>>,
                List<RedeemedReward>
              >,
              AsyncValue<List<RedeemedReward>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
