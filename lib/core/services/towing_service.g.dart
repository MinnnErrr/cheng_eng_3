// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'towing_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(towingService)
const towingServiceProvider = TowingServiceProvider._();

final class TowingServiceProvider
    extends $FunctionalProvider<TowingService, TowingService, TowingService>
    with $Provider<TowingService> {
  const TowingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'towingServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$towingServiceHash();

  @$internal
  @override
  $ProviderElement<TowingService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TowingService create(Ref ref) {
    return towingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TowingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TowingService>(value),
    );
  }
}

String _$towingServiceHash() => r'704ae0b69e37209c0d189fcb6ade14dbb8407136';
