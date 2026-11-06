import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(
      settings: const InitializationSettings(android: android),
    );
  }

  static Future<void> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  static Future<void> showTest() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_horoscope',
        'Daily horoscope',
        channelDescription: 'Your daily horoscope reminder',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
    await _plugin.show(
      id: 0,
      title: 'Your horoscope is ready',
      body: 'Tap to see today\'s reading',
      notificationDetails: details,
    );
  }
}