import 'package:cheng_eng_3/core/models/booking_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'booking_service.g.dart';

@Riverpod(keepAlive: true)
BookingService bookingService(Ref ref) {
  return BookingService();
}

class BookingService {
  final supabase = Supabase.instance.client;

  Future<List<Booking>> getAllBooking() async {
    final data = await supabase
        .from('bookings')
        .select()
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Booking>((b) => Booking.fromJson(b)).toList();
  }

  Future<List<Booking>> getByUser(String userId) async {
    final data = await supabase
        .from('bookings')
        .select()
        .eq('userId', userId)
        .isFilter('deletedAt', null)
        .order('createdAt', ascending: false);
    return data.map<Booking>((b) => Booking.fromJson(b)).toList();
  }

  Future<Booking> getByBookingId(String id) async {
    final data = await supabase.from('bookings').select().eq('id', id).single();
    return Booking.fromJson(data);
  }

  Future<void> create(Booking booking) async {
    await supabase.from('bookings').insert(booking.toJson());
  }

  Future<void> update(Booking booking) async {
    await supabase
        .from('bookings')
        .update(booking.toJson())
        .eq('id', booking.id);
  }

  Future<void> updateStatus(
    String status,
    String towingId,
    String? message,
  ) async {
    await supabase
        .from('bookings')
        .update({
          'status': status,
          'updatedAt': DateTime.now().toIso8601String(),
          'staffMessage': message,
        })
        .eq('id', towingId);
  }

  Future<List<Booking>> getBookingByDate(DateTime date) async {
    final data = await supabase
        .from('bookings')
        .select()
        .eq('date', date)
        .isFilter('deletedAt', null);
    return data.map<Booking>((b) => Booking.fromJson(b)).toList();
  }
}
