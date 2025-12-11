// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_towing_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerTowingNotifier)
const customerTowingProvider = CustomerTowingNotifierFamily._();

final class CustomerTowingNotifierProvider
    extends $AsyncNotifierProvider<CustomerTowingNotifier, List<Towing>> {
  const CustomerTowingNotifierProvider._({
    required CustomerTowingNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerTowingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerTowingNotifierHash();

  @override
  String toString() {
    return r'customerTowingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CustomerTowingNotifier create() => CustomerTowingNotifier();

  @override
  bool operator ==(Object other) {
    return other is CustomerTowingNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerTowingNotifierHash() =>
    r'9c512fdf26f5743e42193a442d2c960931141dd1';

final class CustomerTowingNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CustomerTowingNotifier,
          AsyncValue<List<Towing>>,
          List<Towing>,
          FutureOr<List<Towing>>,
          String
        > {
  const CustomerTowingNotifierFamily._()
    : super(
        retry: null,
        name: r'customerTowingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CustomerTowingNotifierProvider call(String userId) =>
      CustomerTowingNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'customerTowingProvider';
}

abstract class _$CustomerTowingNotifier extends $AsyncNotifier<List<Towing>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<Towing>> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<Towing>>, List<Towing>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Towing>>, List<Towing>>,
              AsyncValue<List<Towing>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
