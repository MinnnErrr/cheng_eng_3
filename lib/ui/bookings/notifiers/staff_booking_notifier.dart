
import 'package:cheng_eng_3/domain/models/booking_model.dart';
import 'package:cheng_eng_3/domain/models/message_model.dart';
import 'package:cheng_eng_3/data/services/booking_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_booking_notifier.g.dart';

@riverpod
class StaffBookingNotifier extends _$StaffBookingNotifier {
  BookingService get _bookingService => ref.read(bookingServiceProvider);

  @override
  FutureOr<List<Booking>> build() async {
    return await _bookingService.getAllBooking();
  }

  // void refresh() => ref.invalidateSelf();

  Future<Message> updateStatus({
    required String id,
    required String status,
    required String? message,
  }) async {
    try {
      await _bookingService.updateStatus(status, id, message);

      return Message(isSuccess: true, message: 'Status updated');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to update status');
    }
  }
}

// final staffBookingByIdProvider = FutureProvider.family<Booking, String>(
//   (ref, bookingId) async {
//     final bookings = await ref.watch(staffBookingProvider.future);

//     final booking = bookings.firstWhere(
//       (t) => t.id == bookingId,
//       orElse: () => throw Exception('Towing not found'),
//     );

//     return booking;
//   },
// );


