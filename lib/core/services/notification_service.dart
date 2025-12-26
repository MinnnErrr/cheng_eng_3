import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart'; // 👈 Generated file

// ✅ Define the Provider
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService();
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    final TimezoneInfo timezone = await FlutterTimezone.getLocalTimezone();
    final String timeZoneId = timezone.identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneId));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/cheng_eng_logo');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleMaintenanceReminder({
    required String id, // Unique ID for this vehicle/service
    required String vehicleName,
    required DateTime serviceDate,
  }) async {
    // 1. Calculate the reminder date (3 days before)
    final DateTime dateBefore = serviceDate.subtract(
      const Duration(days: 3),
    );

    if (dateBefore.isAfter(DateTime.now())) {
      // Create a unique INT based on UUID + suffix
      final int earlyId = ('$id + "_early"').hashCode;

      await _scheduleSingleNotification(
        id: earlyId, 
        title: 'Upcoming Service',
        body: 'Your vehicle $vehicleName has a maintenance service scheduled after 3 days.',
        time: dateBefore,
      );
    }

    if (serviceDate.isBefore(DateTime.now())) {
      // Create a different unique INT based on UUID + different suffix
      final int dueId = ('$id + "_due"').hashCode;

      await _scheduleSingleNotification(
        id: dueId,
        title: 'Service Due Today',
        body: 'Your vehicle $vehicleName is due for a maintenance service today!',
        time: serviceDate,
      );
    }
  }

  Future<void> _scheduleSingleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime time,
  }) async {
    // Schedule for 9:00 AM
    final tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      time.year,
      time.month,
      time.day,
      17, 
      0,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'maintenance_channel',
          'Maintenance Reminders',
          channelDescription: 'Reminders for upcoming vehicle service',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelReminder(String id) async {
    final int earlyId = ('$id + "_early"').hashCode;
    final int dueId = ('$id + "_due"').hashCode;

    await flutterLocalNotificationsPlugin.cancel(earlyId);
    await flutterLocalNotificationsPlugin.cancel(dueId);
  }
}
