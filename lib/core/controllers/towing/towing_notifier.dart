import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/core/services/towing_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'towing_notifier.g.dart';

@riverpod
class TowingNotifier extends _$TowingNotifier {
  TowingService get _towingService => ref.read(towingServiceProvider);

  @override
  FutureOr<Towing> build(String towingId) async {
    return await _towingService.getByTowingId(towingId);
  }

  void refresh() => ref.invalidateSelf();
}
