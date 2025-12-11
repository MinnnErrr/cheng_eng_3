// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_history_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pointHistorytService)
const pointHistorytServiceProvider = PointHistorytServiceProvider._();

final class PointHistorytServiceProvider
    extends
        $FunctionalProvider<
          PointHistoryService,
          PointHistoryService,
          PointHistoryService
        >
    with $Provider<PointHistoryService> {
  const PointHistorytServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pointHistorytServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pointHistorytServiceHash();

  @$internal
  @override
  $ProviderElement<PointHistoryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PointHistoryService create(Ref ref) {
    return pointHistorytService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PointHistoryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PointHistoryService>(value),
    );
  }
}

String _$pointHistorytServiceHash() =>
    r'077c7b2e7ad00a9632d9d0eeb46b15389ec53a52';
