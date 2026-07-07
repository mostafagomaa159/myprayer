import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';
import '../../../core/base/locator/locator.dart';
import '../../../core/services/prayer_service.dart';
import '../../../core/services/notification_service.dart';

// States
abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final Map<String, dynamic> prayerTimes;
  HomeLoaded(this.prayerTimes);
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final PrayerService _prayerService = locator<PrayerService>();
  final NotificationService _notificationService = locator<NotificationService>();

  Future<void> fetchAndScheduleAlerts() async {
    emit(HomeLoading());
    try {
      // 1. Register a periodic task to run every 3 hours (minimum allowed by Android)
      await Workmanager().registerPeriodicTask(
        "1",
        "fetchPrayerTimesTask",
        frequency: const Duration(hours: 3),
        constraints: Constraints(networkType: NetworkType.connected),
      );

      // 2. Trigger an immediate notification to confirm
      await locator<NotificationService>().showNotification(
          "Alerts Activated",
          "You will now receive prayer time notifications."
      );

      emit(HomeLoaded(await _prayerService.getPrayerTimes()));
    } catch (e) {
      emit(HomeInitial());
    }
  }
}
