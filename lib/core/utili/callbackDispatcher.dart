import 'package:myprayer/core/services/location_service.dart';
import 'package:myprayer/core/services/notification_service.dart';
import 'package:myprayer/core/services/prayer_service.dart';
import 'package:intl/intl.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final locationService = LocationService();
    final notificationService = NotificationService();
    await notificationService.init();
    final prayerService = PrayerService(locationService, notificationService);

    try {
      final prayerTimes = await prayerService.getPrayerTimes();
      final now = DateTime.now();
      final currentTime = DateFormat.Hm().format(now); // Format as HH:mm

      for (var entry in prayerTimes.entries) {
        String prayerName = entry.key;
        String prayerTime = entry.value;

        // Check if the current time matches the prayer time
        if (prayerTime == currentTime) {
          String notificationMessage = "It's time for $prayerName at $prayerTime";
          await notificationService.showNotification("Prayer Time Alert", notificationMessage);
        }
      }
    } catch (e) {
      print("Error fetching prayer times in background: $e");
    }

    return Future.value(true);
  });
}
