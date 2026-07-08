import 'dart:async'; // Import for Timer
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myprayer/core/services/prayer_service.dart';
import 'package:myprayer/core/services/notification_service.dart';
import 'package:myprayer/features/home/view_model/home_state.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class HomeCubit extends Cubit<HomeState> {
  final PrayerService _prayerService;
  final NotificationService _notificationService;
  Timer? _timer; // Timer to check prayer times

  HomeCubit(this._prayerService, this._notificationService) : super(HomeInitial());

  Future<void> fetchAndScheduleAlerts() async {
    emit(HomeLoading());
    try {
      final prayerTimes = await _prayerService.getPrayerTimes();

      // Start checking for prayer times
      startCheckingForPrayers(prayerTimes);

      emit(HomeLoaded(prayerTimes)); // Emit loaded state with prayer times
    } catch (e) {
      emit(HomeError("Failed to fetch prayer times: $e"));
    }
  }

  void startCheckingForPrayers(Map<String, String> prayerTimes) {
    // Cancel any existing timer to avoid multiple timers running
    _timer?.cancel();

    // Start a timer to check every minute
    _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      final now = DateTime.now();
      final currentTime = DateFormat.Hm().format(now); // Format as HH:mm

      // Print current time for debugging
      print("Current Time: $currentTime");

      // Loop through prayer times and check for matches
      for (var entry in prayerTimes.entries) {
        String prayerName = entry.key;
        String prayerTime = entry.value;

        // Print each prayer time for debugging
        print("Checking Prayer: $prayerName at $prayerTime against current time: $currentTime");

        // Check if the current time matches the prayer time
        if (prayerTime == currentTime) {
          // Send notification if the time matches
          String notificationMessage = "It's time for $prayerName at $prayerTime";
          await _notificationService.showNotification("Prayer Time Alert", notificationMessage);
          print("Notification sent for $prayerName at $prayerTime");
        }
      }
    });
  }

  @override
  Future<void> close() async{
    _timer?.cancel(); // Cancel the timer when closing the cubit
    super.close();
  }
}
