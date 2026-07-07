import 'package:get_it/get_it.dart';
import 'package:myprayer/core/services/location_service.dart';
import 'package:myprayer/core/services/notification_service.dart';
import 'package:myprayer/core/services/prayer_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Register the services first
  locator.registerLazySingleton<LocationService>(() => LocationService());
  locator.registerLazySingleton<NotificationService>(() => NotificationService());

  // 2. Now register PrayerService with explicit types inside the closure
  locator.registerLazySingleton<PrayerService>(() => PrayerService(
    locator<LocationService>(),
    locator<NotificationService>(),
  ));
}