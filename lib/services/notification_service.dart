import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  var notification = FlutterLocalNotificationsPlugin();

  bool isTrue = false;

  bool get isInitialized => isTrue;

  Future<void> initializeNotification() async {
    if (isTrue) return;

    tz.initializeTimeZones();

    final timeZone = await FlutterTimezone.getLocalTimezone();
    print(timeZone);
    tz.setLocalLocation(tz.getLocation(timeZone));

    var initSetting = const InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
      ),
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await notification.initialize(initSetting);
  }

  Future<NotificationDetails> notificationDetail({
    required Priority priority,
  }) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'device_noti_channel.id',
        'Alert notification',
        priority: priority,
        importance: Importance.max,
        color: Colors.orange,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    return await notification.show(
      DateTime.now().microsecond,
      title,
      body,
      await notificationDetail(priority: Priority.max),
    );
  }

  Future<void> scheduleNotification({

    required String title,
    required String body,
    required int hour,
    required int min,
    required int id,
    int? sec,
    int? year,
    int? month,
    int? day,
    required String priority,
  }) async {

    print('$year $month $day');
    var now = tz.TZDateTime.now(tz.local);
    var scheduleTime = tz.TZDateTime(
      tz.local,
     year?? now.year,
     month?? now.month,
      day?? now.day,
      hour,
      min,
      sec??now.second
    );

    return notification.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      await notificationDetail(
        priority: priority == 'High' ? Priority.high : Priority.min,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time
    );
  }

   Future<void> cancelNotificationById(int id) async {
    await notification.cancel(id);
  }
}
