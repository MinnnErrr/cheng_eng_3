// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PaymentNotifier)
const paymentProvider = PaymentNotifierProvider._();

final class PaymentNotifierProvider
    extends $NotifierProvider<PaymentNotifier, AsyncValue<PaymentResult>> {
  const PaymentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paymentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paymentNotifierHash();

  @$internal
  @override
  PaymentNotifier create() => PaymentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<PaymentResult> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<PaymentResult>>(value),
    );
  }
}

String _$paymentNotifierHash() => r'ddb1496280f95120fc6395bca8f89de10273169c';

abstract class _$PaymentNotifier extends $Notifier<AsyncValue<PaymentResult>> {
  AsyncValue<PaymentResult> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<PaymentResult>, AsyncValue<PaymentResult>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PaymentResult>, AsyncValue<PaymentResult>>,
              AsyncValue<PaymentResult>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
