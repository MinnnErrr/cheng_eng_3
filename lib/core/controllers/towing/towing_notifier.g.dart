// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'towing_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TowingNotifier)
const towingProvider = TowingNotifierFamily._();

final class TowingNotifierProvider
    extends $AsyncNotifierProvider<TowingNotifier, Towing> {
  const TowingNotifierProvider._({
    required TowingNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'towingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$towingNotifierHash();

  @override
  String toString() {
    return r'towingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TowingNotifier create() => TowingNotifier();

  @override
  bool operator ==(Object other) {
    return other is TowingNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$towingNotifierHash() => r'3f9dc4939362bcb58e94bfcb8c3f03dfc2c24fea';

final class TowingNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          TowingNotifier,
          AsyncValue<Towing>,
          Towing,
          FutureOr<Towing>,
          String
        > {
  const TowingNotifierFamily._()
    : super(
        retry: null,
        name: r'towingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TowingNotifierProvider call(String towingId) =>
      TowingNotifierProvider._(argument: towingId, from: this);

  @override
  String toString() => r'towingProvider';
}

abstract class _$TowingNotifier extends $AsyncNotifier<Towing> {
  late final _$args = ref.$arg as String;
  String get towingId => _$args;

  FutureOr<Towing> build(String towingId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<Towing>, Towing>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Towing>, Towing>,
              AsyncValue<Towing>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
