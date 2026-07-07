import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'core/base/locator/locator.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/prayer_service.dart';
import 'features/home/view/home_view.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 1. Manually instantiate services (Isolates do not share GetIt memory)
    final locationService = LocationService();
    final notificationService = NotificationService();
    await notificationService.init();

    final prayerService = PrayerService(locationService, notificationService);

    try {
      final timings = await prayerService.getPrayerTimes();
      final now = DateTime.now();
      final currentTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      final prefs = await SharedPreferences.getInstance();
      String today = DateTime.now().toString().split(' ')[0];

      // 2. Check each prayer
      for (var entry in timings.entries) {
        String prayerName = entry.key;
        String prayerTime = entry.value.toString().substring(0, 5);

        if (prayerTime == currentTime) {
          String lastNotifiedKey = "last_notified_${prayerName}_$today";
          bool alreadyNotified = prefs.getBool(lastNotifiedKey) ?? false;

          if (!alreadyNotified) {
            await notificationService.showNotification(
                "Prayer Time",
                "It is time for $prayerName"
            );
            // Mark as notified for today
            await prefs.setBool(lastNotifiedKey, true);
          }
        }
      }
    } catch (e) {
      debugPrint("Background error: $e");
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup Dependency Injection for UI
  setupLocator();

  // Initialize Notifications for UI
  final notificationService = GetIt.instance<NotificationService>();
  await notificationService.requestNotificationPermission();
  await notificationService.init();

  // Initialize Background Task
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeView(),
    );
  }
}
