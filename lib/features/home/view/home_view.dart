import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  void triggerTestNotification() {
    Workmanager().registerOneOffTask(
      "testNotification",
      "fetchPrayerTimesTask",
      initialDelay: Duration(seconds: 5), // Delay for 5 seconds for testing
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prayer Time App")),
      body: Center(
        child:// Inside your HomeView Widget
        ElevatedButton(
          onPressed: () async {
            // 1. Request permissions first
            await Permission.location.request();
            await Permission.notification.request();

            // 2. Register the background task
            await Workmanager().registerPeriodicTask(
              "1", // Unique name
              "prayerTask",
              frequency: Duration(minutes: 15),
            );

            // 3. Feedback
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Alerts set successfully!")),
            );
          },
          child: Text("Enable Prayer Alerts"),
        )

      ),
    );
  }
}
