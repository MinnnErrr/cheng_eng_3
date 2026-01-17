// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_history_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pointHistoryService)
const pointHistoryServiceProvider = PointHistoryServiceProvider._();

final class PointHistoryServiceProvider
    extends
        $FunctionalProvider<
          PointHistoryService,
          PointHistoryService,
          PointHistoryService
        >
    with $Provider<PointHistoryService> {
  const PointHistoryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointHistoryServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointHistoryServiceHash();

  @$internal
  @override
  $ProviderElement<PointHistoryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PointHistoryService create(Ref ref) {
    return pointHistoryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PointHistoryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PointHistoryService>(value),
    );
  }
}

String _$pointHistoryServiceHash() =>
    r'f211caaad09f57b29f036fdbc3b7f2956d987b19';
