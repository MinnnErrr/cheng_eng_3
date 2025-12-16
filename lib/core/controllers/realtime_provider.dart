import 'package:cheng_eng_3/core/controllers/booking/booking_by_date_provider.dart';
import 'package:cheng_eng_3/core/controllers/booking/booking_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/booking/customer_booking_notifier.dart';
import 'package:cheng_eng_3/core/controllers/booking/staff_booking_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/point_history_notifier.dart';
import 'package:cheng_eng_3/core/controllers/point/staff_point_history_provider.dart';
import 'package:cheng_eng_3/core/controllers/product/customer_product_notifier.dart';
import 'package:cheng_eng_3/core/controllers/product/product_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/product/staff_product_notifier.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/core/controllers/reward/customer_rewards_notifier.dart';
import 'package:cheng_eng_3/core/controllers/reward/reward_by_id_provider.dart';
import 'package:cheng_eng_3/core/controllers/reward/staff_rewards_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/staff_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towings_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/towing_by_id_provider.dart';
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
          ref.invalidate(towingByIdProvider(towingId));
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
          final productId = payload.newRecord['id'];

          // staff refresh
          ref.invalidate(staffProductProvider);

          //customer refresh
          ref.invalidate(customerProductProvider);

          ref.invalidate(productByIdProvider(productId));
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
          final rewardId = payload.newRecord['id'];

          // staff refresh
          ref.invalidate(staffRewardsProvider);

          //customer refresh
          ref.invalidate(customerRewardsProvider);

          //single refresh
          ref.invalidate(rewardByIdProvider(rewardId));
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
          final userId = payload.newRecord['userId'];

          // staff refresh
          ref.invalidate(staffPointHistoryProvider);

          //customer refresh
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
          final redeemedId = payload.newRecord['id'];

          //customer
          ref.invalidate(redeemedRewardProvider(userId));

          //single
          ref.invalidate(redeeemdRewardByIdProvider(redeemedId));
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
          final userId = payload.newRecord['userId'];
          final date = payload.newRecord['date'];
          final bookingId = payload.newRecord['id'];

          // staff refresh
          ref.invalidate(staffBookingProvider);

          //customer refresh
          ref.invalidate(customerBookingProvider(userId));

          //single
          ref.invalidate(bookingByIdProvider(bookingId));

          //time slot
          ref.invalidate(bookingPerSlotProvider(date));
        },
      )
      .subscribe();
  ref.onDispose(() {
    supabase.removeChannel(channel);
  });
});
