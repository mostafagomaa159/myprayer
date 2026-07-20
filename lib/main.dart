import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myprayer/features/home/home_imports.dart';
import 'package:workmanager/workmanager.dart'; // Import Workmanager
import 'package:myprayer/core/base/locator/locator.dart';
import 'package:myprayer/core/services/notification_service.dart';
import 'package:myprayer/core/services/prayer_service.dart';
import 'core/utili/callbackDispatcher.dart'; // Import your callback dispatcher

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupLocator(); // Call the setup locator

  final notificationService = locator<NotificationService>();
  await notificationService.requestNotificationPermission(); // Request notification permissions
  await notificationService.init(); // Initialize the notification service

  // Initialize Workmanager
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Register your periodic task here
  await Workmanager().registerPeriodicTask(
    "1", // Unique task name
    "prayerTask", // Task identifier
    frequency: Duration(minutes: 15), // Frequency of the task
    constraints: Constraints(networkType: NetworkType.connected), // Only run when connected to the network
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        locator<PrayerService>(),
        locator<NotificationService>(),
      ),
      child: MaterialApp(
        title: 'Prayer Time App',
        home: HomeView(),
      ),
    );
  }
}
