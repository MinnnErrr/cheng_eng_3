import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:cheng_eng_3/core/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'customer_booking_notifier.g.dart';

@riverpod
class CustomerBookingNotifier extends _$CustomerBookingNotifier {
  BookingService get _bookingService => ref.read(bookingServiceProvider);

  @override
  FutureOr<List<Booking>> build(String userId) async {
    return await _bookingService.getByUser(userId);
  }

  // void refresh() => ref.invalidateSelf();

  Future<Message> addBooking({
    required List<BookingServiceType> services,
    required DateTime date,
    required TimeOfDay time,
    required String? remarks,
    required Vehicle vehicle,
  }) async {
    final userState = ref.read(authProvider);
    final user = userState.value;
    if (user == null) {
      return Message(isSuccess: false, message: 'No user found');
    }

    final bookingId = Uuid().v4();

    final booking = Booking(
      id: bookingId,
      services: services,
      date: date,
      time: time,
      remarks: remarks,
      status: BookingStatus.pending,
      vehiclePhoto: vehicle.photoPath,
      vehicleRegNum: vehicle.regNum,
      vehicleMake: vehicle.make,
      vehicleModel: vehicle.model,
      vehicleColour: vehicle.colour,
      vehicleYear: vehicle.year,
      createdAt: DateTime.now(),
      updatedAt: null,
      vehicleId: vehicle.id,
      userId: user.id,
    );

    try {
      await _bookingService.create(booking);

      return Message(isSuccess: true, message: 'Booking submitted');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to submit booking');
    }
  }

  Future<Message> cancelBooking({
    required String id,
  }) async {
    try {
      await _bookingService.updateStatus(
        BookingStatus.cancelled.name,
        id,
        null,
      );

      return Message(isSuccess: true, message: 'Booking cancelled');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to cancel booking');
    }
  }
}

  // final customerBookingByIdProvider = FutureProvider.family<Booking, ({String userId, String bookingId})>(
  // (ref, params) async {
  //   final bookings = await ref.watch(customerBookingProvider(params.userId).future);

  //   final booking = bookings.firstWhere(
  //     (b) => b.id == params.bookingId,
  //     orElse: () => throw Exception('Towing not found'),
  //   );

  //   return booking;
  // },



