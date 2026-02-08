import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    final androidPlugin =
        _notificationPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPlugin?.requestExactAlarmsPermission();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationPlugin.initialize(initSettings);
  }

  NotificationDetails _notificationDetails({required Priority priority}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel_id',
        'Task Notifications',
        channelDescription: 'Channel for task reminders',
        importance: Importance.max,
        priority: priority,
        color: Colors.orange,
        playSound: true,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
    Priority priority = Priority.max,
  }) async {
    await _notificationPlugin.show(
      DateTime.now().microsecond,
      title,
      body,
      _notificationDetails(priority: priority),
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int min,
    int? sec,
    int? year,
    int? month,
    int? day,
    required String priority,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleTime = tz.TZDateTime(
      tz.local,
      year ?? now.year,
      month ?? now.month,
      day ?? now.day,
      hour,
      min,
      sec ?? 0,
    );

    await _notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      _notificationDetails(
        priority:
            priority.toLowerCase() == 'high' ? Priority.high : Priority.min,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'task_payload',
    );
  }

  Future<void> cancelNotificationById(int id) async {
    await _notificationPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationPlugin.cancelAll();
  }
}
