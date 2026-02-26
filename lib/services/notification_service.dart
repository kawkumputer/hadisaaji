import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _enabledKey = 'daily_notification_enabled';
  static const String _hourKey = 'daily_notification_hour';
  static const String _minuteKey = 'daily_notification_minute';
  static const int _dailyNotifId = 100;

  static Future<void> init() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);
  }

  static Future<bool> get isEnabled async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? true;
  }

  static Future<int> get notifHour async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_hourKey) ?? 7;
  }

  static Future<int> get notifMinute async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_minuteKey) ?? 0;
  }

  static Future<void> scheduleDailyHadith({
    required String title,
    required String body,
    int? hour,
    int? minute,
  }) async {
    final h = hour ?? await notifHour;
    final m = minute ?? await notifMinute;

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, h, m);

    // Si l'heure est déjà passée aujourd'hui, planifier pour demain
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'hadith_daily',
      'Hadiis Ñalngu',
      channelDescription: 'Notification quotidienne du hadith du jour',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      styleInformation: BigTextStyleInformation(''),
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      _dailyNotifId,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelDailyHadith() async {
    await _plugin.cancel(_dailyNotifId);
  }

  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
  }

  static Future<void> setTime(int hour, int minute) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hourKey, hour);
    await prefs.setInt(_minuteKey, minute);
  }

  static Future<void> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
    }
  }
}
