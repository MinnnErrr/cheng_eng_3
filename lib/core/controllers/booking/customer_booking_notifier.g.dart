// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_booking_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CustomerBookingNotifier)
const customerBookingProvider = CustomerBookingNotifierFamily._();

final class CustomerBookingNotifierProvider
    extends $AsyncNotifierProvider<CustomerBookingNotifier, List<Booking>> {
  const CustomerBookingNotifierProvider._({
    required CustomerBookingNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'customerBookingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerBookingNotifierHash();

  @override
  String toString() {
    return r'customerBookingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CustomerBookingNotifier create() => CustomerBookingNotifier();

  @override
  bool operator ==(Object other) {
    return other is CustomerBookingNotifierProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerBookingNotifierHash() =>
    r'1613479cd02409a25347702ec47287d587c184ea';

final class CustomerBookingNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          CustomerBookingNotifier,
          AsyncValue<List<Booking>>,
          List<Booking>,
          FutureOr<List<Booking>>,
          String
        > {
  const CustomerBookingNotifierFamily._()
    : super(
        retry: null,
        name: r'customerBookingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CustomerBookingNotifierProvider call(String userId) =>
      CustomerBookingNotifierProvider._(argument: userId, from: this);

  @override
  String toString() => r'customerBookingProvider';
}

abstract class _$CustomerBookingNotifier extends $AsyncNotifier<List<Booking>> {
  late final _$args = ref.$arg as String;
  String get userId => _$args;

  FutureOr<List<Booking>> build(String userId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<List<Booking>>, List<Booking>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Booking>>, List<Booking>>,
              AsyncValue<List<Booking>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
