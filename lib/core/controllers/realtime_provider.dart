import 'package:cheng_eng_3/core/controllers/booking/booking_by_date_provider.dart';
import 'package:cheng_eng_3/core/controllers/booking/customer_booking_notifier.dart';
import 'package:cheng_eng_3/core/controllers/booking/staff_booking_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/customer_point_history_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/customer_product_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/staff_product_notifier.dart';
import 'package:cheng_eng_3/core/controllers/reward/customer_reward_notifier.dart';
import 'package:cheng_eng_3/core/controllers/reward/staff_reward_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/staff_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/towing_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final towingRealtimeProvider = Provider<void>((ref) {
  final supabase = Supabase.instance.client;

  final channel = supabase
      .channel('towing-realtime')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'tows',
        callback: (payload) {
          final userId = payload.newRecord['userId'];
          final towingId = payload.newRecord['id'];

          // staff refresh
          ref.invalidate(staffTowingsProvider);

          //customer refresh
          ref.invalidate(customerTowingsProvider(userId));

          //single towing refresh
          ref.invalidate(towingProvider(towingId));
        },
      )
      .subscribe();
  ref.onDispose(() {
    supabase.removeChannel(channel);
  });
});

final productRealTimeProvider = Provider<void>((ref) {
  final supabase = Supabase.instance.client;

  final channel = supabase
      .channel('product-realtime')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'products',
        callback: (payload) {
          // staff refresh
          ref.invalidate(staffProductProvider);

          //customer refresh
          ref.invalidate(customerProductProvider);
        },
      )
      .subscribe();
  ref.onDispose(() {
    supabase.removeChannel(channel);
  });
});

final rewardRealTimeProvider = Provider<void>((ref) {
  final supabase = Supabase.instance.client;

  final channel = supabase
      .channel('reward-realtime')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'rewards',
        callback: (payload) {
          // staff refresh
          ref.invalidate(staffRewardProvider);

          //customer refresh
          ref.invalidate(customerRewardProvider);
        },
      )
      .subscribe();
  ref.onDispose(() {
    supabase.removeChannel(channel);
  });
});

final pointHistoryRealTimeProvider = Provider<void>((ref) {
  final supabase = Supabase.instance.client;

  final channel = supabase
      .channel('point-history-realtime')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'point_history',
        callback: (payload) {
          // staff refresh
          ref.invalidate(staffProductProvider);

          //customer refresh
          final userId = payload.newRecord['userId'];
          ref.invalidate(pointHistoryProvider(userId));
        },
      )
      .subscribe();
  ref.onDispose(() {
    supabase.removeChannel(channel);
  });
});

final redeemedRewardRealTimeProvider = Provider<void>((ref) {
  final supabase = Supabase.instance.client;

  final channel = supabase
      .channel('redeemed-reward-realtime')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'redeemed_rewards',
        callback: (payload) {
          final userId = payload.newRecord['userId'];
          ref.invalidate(pointHistoryProvider(userId));
        },
      )
      .subscribe();
  ref.onDispose(() {
    supabase.removeChannel(channel);
  });
});

final bookingRealTimeProvider = Provider<void>((ref) {
  final supabase = Supabase.instance.client;

  final channel = supabase
      .channel('booking-realtime')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'bookings',
        callback: (payload) {
          // staff refresh
          ref.invalidate(staffBookingProvider);

          final date = payload.newRecord['date'];
          ref.invalidate(bookingPerSlotProvider(date));

          //customer refresh
          final userId = payload.newRecord['userId'];
          ref.invalidate(customerBookingProvider(userId));
        },
      )
      .subscribe();
  ref.onDispose(() {
    supabase.removeChannel(channel);
  });
});
