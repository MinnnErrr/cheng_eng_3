import 'package:cheng_eng_3/data/providers/booking/booking_by_date_provider.dart';
import 'package:cheng_eng_3/data/providers/booking/booking_by_id_provider.dart';
import 'package:cheng_eng_3/ui/bookings/notifiers/customer_booking_notifier.dart';
import 'package:cheng_eng_3/ui/bookings/notifiers/staff_booking_notifier.dart';
import 'package:cheng_eng_3/data/providers/order/order_providers.dart';
import 'package:cheng_eng_3/ui/points/notifiers/point_history_notifier.dart';
import 'package:cheng_eng_3/data/providers/point/staff_point_history_provider.dart';
import 'package:cheng_eng_3/ui/products/notifiers/customer_product_notifier.dart';
import 'package:cheng_eng_3/data/providers/product/product_by_id_provider.dart';
import 'package:cheng_eng_3/ui/products/notifiers/staff_product_notifier.dart';
import 'package:cheng_eng_3/data/providers/redeem_reward/redeemed_reward_by_id_provider.dart';
import 'package:cheng_eng_3/ui/redeemed_rewards/notifiers/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/ui/rewards/notifiers/customer_rewards_notifier.dart';
import 'package:cheng_eng_3/data/providers/reward/reward_by_id_provider.dart';
import 'package:cheng_eng_3/ui/rewards/notifiers/staff_rewards_notifier.dart';
import 'package:cheng_eng_3/ui/tows/notifiers/staff_towings_notifier.dart';
import 'package:cheng_eng_3/ui/tows/notifiers/customer_towings_notifier.dart';
import 'package:cheng_eng_3/data/providers/towing/towing_by_id_provider.dart';
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
          final dateString = payload.newRecord['date'];
          final bookingId = payload.newRecord['id'];

          final date = DateTime.parse(dateString);
          final finalDate = DateTime(date.year, date.month, date.day);

          // staff refresh
          ref.invalidate(staffBookingProvider);

          //customer refresh
          ref.invalidate(customerBookingProvider(userId));

          //single
          ref.invalidate(bookingByIdProvider(bookingId));

          //time slot
          ref.invalidate(bookingPerSlotProvider(finalDate));
        },
      )
      .subscribe();
  ref.onDispose(() {
    supabase.removeChannel(channel);
  });
});

final orderRealTimeProvider = Provider<void>((ref) {
  final supabase = Supabase.instance.client;

  final channel = supabase.channel('order-realtime');

  channel.onPostgresChanges(
    event: PostgresChangeEvent.all,
    schema: 'public',
    table: 'orders',
    callback: (payload) {
      final orderId = payload.newRecord['id'];
      final userId = payload.newRecord['userId'];

      // staff refresh
      ref.invalidate(staffOrdersProvider);

      //customer refresh
      ref.invalidate(customerOrdersProvider(userId));

      //single refresh
      ref.invalidate(orderByIdProvider(orderId));
    },
  );

  channel.onPostgresChanges(
    event: PostgresChangeEvent.all,
    schema: 'public',
    table: 'order_items',
    callback: (payload) async {
      final orderId = payload.newRecord['orderId'];

      ref.invalidate(orderByIdProvider(orderId));

      // Invalidate Staff List
      ref.invalidate(staffOrdersProvider);
    },
  );

  channel.subscribe();

  ref.onDispose(() {
    supabase.removeChannel(channel);
  });
});
