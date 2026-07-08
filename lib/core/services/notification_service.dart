import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Your app icon

    await _notificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings),
    );

    // Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'prayer_channel', // Unique channel ID
      'Prayer Notifications', // Channel name
      description: 'Channel for prayer time notifications',
      importance: Importance.max,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('azan1'),
    );

    // Create the channel on the device
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Show a notification
  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'prayer_channel', // Must match the channel ID used when creating the channel
      'Prayer Notifications',
      channelDescription: 'Channel for prayer time notifications',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('azan1'), // Use azan1.mp3 as the notification sound
    );

    print("Showing notification with title: $title and body: $body");
    await _notificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }


  // Request notification permission
  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }
  }

}
