// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookingStateNotifier)
const bookingStateProvider = BookingStateNotifierProvider._();

final class BookingStateNotifierProvider
    extends $NotifierProvider<BookingStateNotifier, BookingState> {
  const BookingStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingStateNotifierHash();

  @$internal
  @override
  BookingStateNotifier create() => BookingStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookingState>(value),
    );
  }
}

String _$bookingStateNotifierHash() =>
    r'301d06bc82f3c130293a6f99e8c1d10081c4d298';

abstract class _$BookingStateNotifier extends $Notifier<BookingState> {
  BookingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BookingState, BookingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BookingState, BookingState>,
              BookingState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
