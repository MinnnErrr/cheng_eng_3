// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CheckoutNotifier)
const checkoutProvider = CheckoutNotifierProvider._();

final class CheckoutNotifierProvider
    extends $AsyncNotifierProvider<CheckoutNotifier, CheckoutState> {
  const CheckoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutNotifierHash();

  @$internal
  @override
  CheckoutNotifier create() => CheckoutNotifier();
}

String _$checkoutNotifierHash() => r'7c892f9c7c81483e9153049bd74413daac5ef564';

abstract class _$CheckoutNotifier extends $AsyncNotifier<CheckoutState> {
  FutureOr<CheckoutState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CheckoutState>, CheckoutState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CheckoutState>, CheckoutState>,
              AsyncValue<CheckoutState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
