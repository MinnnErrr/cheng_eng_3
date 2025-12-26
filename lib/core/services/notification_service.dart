import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'notification_service.g.dart'; // 👈 Generated file

// ✅ Define the Provider
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationService();
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<bool> requestPermission() async {
    // 1. Check current status
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    // 2. If not granted, request it
    final result = await Permission.notification.request();
    return result.isGranted;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }

  Future<void> init() async {
    tz.initializeTimeZones();
    final TimezoneInfo timezone = await FlutterTimezone.getLocalTimezone();
    final String timeZoneId = timezone.identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneId));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/cheng_eng_logo_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
        );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // // ✅ ADD THIS: Request Permission explicitly for Android 13+
    // final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    //     flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>();

    // if (androidImplementation != null) {
    //   await androidImplementation.requestNotificationsPermission();
    // }
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
        title: 'Cheng Eng Auto Accessories',
        body:
            'Your vehicle $vehicleName has a maintenance service scheduled after 3 days.',
        time: dateBefore,
      );
    }

    if (serviceDate.isAfter(DateTime.now())) {
      // Create a different unique INT based on UUID + different suffix
      final int dueId = ('$id + "_due"').hashCode;

      await _scheduleSingleNotification(
        id: dueId,
        title: 'Cheng Eng Auto Accessories',
        body:
            'Your vehicle $vehicleName is due for a maintenance service today!',
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
      9,
      0,
    );

    final largeIcon = 
        DrawableResourceAndroidBitmap('@mipmap/cheng_eng_logo_black_background');

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'maintenance_channel',
      'Maintenance Reminders',
      channelDescription: 'Reminders for upcoming vehicle service',
      importance: Importance.max,
      priority: Priority.high,

      // A. Small Icon (Status Bar): White Silhouette
      icon: '@mipmap/cheng_eng_logo_icon', 

      // C. Large Icon (Content): Full Color Brand Logo
      largeIcon: largeIcon,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
       NotificationDetails(
        android: androidDetails
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
