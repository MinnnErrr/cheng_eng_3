// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_towings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerTowingsNotifier)
const customerTowingsProvider = CustomerTowingsNotifierFamily._();

final class CustomerTowingsNotifierProvider
    extends $AsyncNotifierProvider<CustomerTowingsNotifier, List<Towing>> {
  const CustomerTowingsNotifierProvider._({
    required CustomerTowingsNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerTowingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerTowingsNotifierHash();

  @override
  String toString() {
    return r'customerTowingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CustomerTowingsNotifier create() => CustomerTowingsNotifier();

  @override
  bool operator ==(Object other) {
    return other is CustomerTowingsNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerTowingsNotifierHash() =>
    r'23413d7fe4ff1921d9e58bfffd15f0936d4ef6dd';

final class CustomerTowingsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CustomerTowingsNotifier,
          AsyncValue<List<Towing>>,
          List<Towing>,
          FutureOr<List<Towing>>,
          String
        > {
  const CustomerTowingsNotifierFamily._()
    : super(
        retry: null,
        name: r'customerTowingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CustomerTowingsNotifierProvider call(String userId) =>
      CustomerTowingsNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'customerTowingsProvider';
}

abstract class _$CustomerTowingsNotifier extends $AsyncNotifier<List<Towing>> {
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
