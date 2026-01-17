
import 'package:cheng_eng_3/domain/models/towing_model.dart';
import 'package:cheng_eng_3/data/services/towing_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_towings_notifier.g.dart';

@riverpod
class StaffTowingsNotifier extends _$StaffTowingsNotifier {
  TowingService get _towingService => ref.read(towingServiceProvider);

  @override
  FutureOr<List<Towing>> build() async {
    return await _towingService.getAllTowing();
  }

  // void refresh() => ref.invalidateSelf();

  Future<bool> updateStatus({
    required String id,
    required TowingStatus status,
  }) async {
    try {
      await _towingService.updateStatus(status.name, id);

      return true;
    } catch (e) {
      return false;
    }
  }
}

// final staffTowingByIdProvider = FutureProvider.family<Towing, String>(
//   (ref, towingId) async {
//     final towingList = await ref.watch(staffTowingProvider.future);

//     final towing = towingList.firstWhere(
//       (t) => t.id == towingId,
//       orElse: () => throw Exception('Towing not found'),
//     );

//     return towing;
//   },
// );


