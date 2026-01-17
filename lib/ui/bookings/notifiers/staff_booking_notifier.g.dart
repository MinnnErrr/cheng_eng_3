// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_booking_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StaffBookingNotifier)
const staffBookingProvider = StaffBookingNotifierProvider._();

final class StaffBookingNotifierProvider
    extends $AsyncNotifierProvider<StaffBookingNotifier, List<Booking>> {
  const StaffBookingNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'staffBookingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$staffBookingNotifierHash();

  @$internal
  @override
  StaffBookingNotifier create() => StaffBookingNotifier();
}

String _$staffBookingNotifierHash() =>
    r'70fcd8d4614182a8dedb22f48c1672f5cc09acf5';

abstract class _$StaffBookingNotifier extends $AsyncNotifier<List<Booking>> {
  FutureOr<List<Booking>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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
