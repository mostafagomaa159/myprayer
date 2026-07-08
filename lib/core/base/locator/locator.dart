import 'package:get_it/get_it.dart';
import 'package:myprayer/core/services/location_service.dart';
import 'package:myprayer/core/services/notification_service.dart';
import 'package:myprayer/core/services/prayer_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<LocationService>(() => LocationService());
  locator.registerLazySingleton<NotificationService>(() => NotificationService());
  locator.registerLazySingleton<PrayerService>(() => PrayerService(
    locator<LocationService>(),
    locator<NotificationService>(),
  ));
}