
import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/core/services/booking_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bookingByIdProvider =
    FutureProvider.family<Booking, String>((ref, bookingId) async {
  final service = ref.read(bookingServiceProvider);
  return await service.getByBookingId(bookingId);
});
