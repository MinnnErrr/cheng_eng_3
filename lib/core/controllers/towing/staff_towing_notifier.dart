
import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/core/services/towing_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_towing_notifier.g.dart';

@riverpod
class StaffTowingNotifier extends _$StaffTowingNotifier {
  TowingService get _towingService => ref.read(towingServiceProvider);

  @override
  FutureOr<List<Towing>> build() async {
    return await _towingService.getAllTowing();
  }

  // void refresh() => ref.invalidateSelf();

  Future<bool> updateStatus({
    required String id,
    required String status,
  }) async {
    try {
      await _towingService.updateStatus(status, id);

      return true;
    } catch (e) {
      return false;
    }
  }
}

final staffTowingByIdProvider =
    Provider.family<AsyncValue<Towing>, String>((
      ref,
      towingId,
    ) {
      final towingList = ref.watch(staffTowingProvider);

      return towingList.when(
        data: (list) {
          final towing = list.firstWhere(
            (t) => t.id == towingId,
            orElse: () => throw Exception('Towing not found'),
          );
          return AsyncValue.data(towing);
        },
        loading: () => const AsyncValue.loading(),
        error: (err, st) => AsyncValue.error(err, st),
      );
    });


