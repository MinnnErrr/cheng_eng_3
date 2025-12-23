// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_history_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PointHistoryNotifier)
const pointHistoryProvider = PointHistoryNotifierFamily._();

final class PointHistoryNotifierProvider
    extends $AsyncNotifierProvider<PointHistoryNotifier, List<PointHistory>> {
  const PointHistoryNotifierProvider._({
    required PointHistoryNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'pointHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pointHistoryNotifierHash();

  @override
  String toString() {
    return r'pointHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PointHistoryNotifier create() => PointHistoryNotifier();

  @override
  bool operator ==(Object other) {
    return other is PointHistoryNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pointHistoryNotifierHash() =>
    r'9d23cfcc7daab3c36cc944f25003edb3a85a7fd3';

final class PointHistoryNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          PointHistoryNotifier,
          AsyncValue<List<PointHistory>>,
          List<PointHistory>,
          FutureOr<List<PointHistory>>,
          String
        > {
  const PointHistoryNotifierFamily._()
    : super(
        retry: null,
        name: r'pointHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PointHistoryNotifierProvider call(String userId) =>
      PointHistoryNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'pointHistoryProvider';
}

abstract class _$PointHistoryNotifier
    extends $AsyncNotifier<List<PointHistory>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<PointHistory>> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref as $Ref<AsyncValue<List<PointHistory>>, List<PointHistory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PointHistory>>, List<PointHistory>>,
              AsyncValue<List<PointHistory>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
