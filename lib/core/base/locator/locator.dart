import 'package:get_it/get_it.dart';
import 'package:myprayer/core/services/location_service.dart';
import 'package:myprayer/core/services/notification_service.dart';
import 'package:myprayer/core/services/prayer_service.dart';

final locator = GetIt.instance;
void setupLocator() {
  if (!locator.isRegistered<LocationService>()) {
    locator.registerLazySingleton<LocationService>(() => LocationService());
  }
  if (!locator.isRegistered<NotificationService>()) {
    locator.registerLazySingleton<NotificationService>(() => NotificationService());
  }
  if (!locator.isRegistered<PrayerService>()) {
    locator.registerLazySingleton<PrayerService>(() => PrayerService(
      locator<LocationService>(),
      locator<NotificationService>(),
    ));
  }
}
