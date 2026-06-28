import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../models/user_settings.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized || kIsWeb) {
      return;
    }

    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Shanghai'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<void> requestPermissionIfNeeded() async {
    if (!_initialized) {
      await init();
    }
    if (kIsWeb) {
      return;
    }

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> syncReminder(
    UserSettings settings, {
    String? body,
  }) async {
    if (!_initialized) {
      await init();
    }

    if (!settings.reminderEnabled) {
      await _plugin.cancel(1);
      await _plugin.cancel(2);
      return;
    }

    final time = _parseTime(settings.reminderTime ?? '20:00');
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'vocab_daily',
      '每日学习提醒',
      channelDescription: 'VocabMaster 每日背单词提醒',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      1,
      'VocabMaster',
      body ?? '该学习单词了！完成今日目标，保持连续打卡。',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> syncWeeklyReport(
    UserSettings settings, {
    String? body,
  }) async {
    if (!_initialized) {
      await init();
    }

    if (!settings.reminderEnabled || !settings.weeklyReportEnabled) {
      await _plugin.cancel(2);
      return;
    }

    final time = _parseTime(settings.reminderTime ?? '20:00');
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = _nextSundayAt(time.hour, time.minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    const androidDetails = AndroidNotificationDetails(
      'vocab_weekly',
      '每周学习周报',
      channelDescription: 'VocabMaster 每周日学习总结',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      2,
      'VocabMaster 周报',
      body ?? '查看本周学习成果，继续加油！',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextSundayAt(int hour, int minute) {
    var date = tz.TZDateTime.now(tz.local);
    while (date.weekday != DateTime.sunday) {
      date = date.add(const Duration(days: 1));
    }
    return tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  ({int hour, int minute}) _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) {
      return (hour: 20, minute: 0);
    }
    return (
      hour: int.tryParse(parts[0]) ?? 20,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }
}