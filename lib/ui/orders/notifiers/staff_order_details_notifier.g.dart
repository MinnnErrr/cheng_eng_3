// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_order_details_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaffOrderDetailNotifier)
const staffOrderDetailProvider = StaffOrderDetailNotifierFamily._();

final class StaffOrderDetailNotifierProvider
    extends
        $AsyncNotifierProvider<
          StaffOrderDetailNotifier,
          StaffOrderDetailState
        > {
  const StaffOrderDetailNotifierProvider._({
    required StaffOrderDetailNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'staffOrderDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$staffOrderDetailNotifierHash();

  @override
  String toString() {
    return r'staffOrderDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StaffOrderDetailNotifier create() => StaffOrderDetailNotifier();

  @override
  bool operator ==(Object other) {
    return other is StaffOrderDetailNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$staffOrderDetailNotifierHash() =>
    r'62eba3c30d88def30d404efe14d8c37564db6f3b';

final class StaffOrderDetailNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          StaffOrderDetailNotifier,
          AsyncValue<StaffOrderDetailState>,
          StaffOrderDetailState,
          FutureOr<StaffOrderDetailState>,
          String
        > {
  const StaffOrderDetailNotifierFamily._()
    : super(
        retry: null,
        name: r'staffOrderDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StaffOrderDetailNotifierProvider call(String orderId) =>
      StaffOrderDetailNotifierProvider._(argument: orderId, from: this);

  @override
  String toString() => r'staffOrderDetailProvider';
}

abstract class _$StaffOrderDetailNotifier
    extends $AsyncNotifier<StaffOrderDetailState> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  FutureOr<StaffOrderDetailState> build(String orderId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref =
        this.ref
            as $Ref<AsyncValue<StaffOrderDetailState>, StaffOrderDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<StaffOrderDetailState>,
                StaffOrderDetailState
              >,
              AsyncValue<StaffOrderDetailState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
