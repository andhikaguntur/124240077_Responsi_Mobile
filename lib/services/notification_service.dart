import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi notifikasi sistem ponsel
  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    try {
      await _notificationsPlugin.initialize(initSettings);

      // Meminta izin notifikasi pada perangkat
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
      }
    } catch (e) {
      debugPrint('Error init notification: $e');
    }
  }

  // Menampilkan notifikasi pada bilah status handphone
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'anime_channel',
      'Anime Notifications',
      channelDescription: 'Notifikasi aplikasi Keripikroll',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    try {
      await _notificationsPlugin.show(id, title, body, details);
    } catch (e) {
      debugPrint('Error show notification: $e');
    }
  }
}
