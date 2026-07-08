// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:myprayer/core/services/prayer_service.dart';
// import 'package:myprayer/core/services/notification_service.dart';
// import 'package:myprayer/features/home/view_model/home_state.dart';
//
// class HomeCubit extends Cubit<HomeState> {
//   final PrayerService _prayerService;
//   final NotificationService _notificationService;
//   Timer? _timer; // Timer to check for Fajr time
//
//   HomeCubit(this._prayerService, this._notificationService) : super(HomeInitial());
//
//   Future<void> fetchAndScheduleAlerts() async {
//     emit(HomeLoading());
//     try {
//       // Fetch prayer times from the API (if needed for other purposes)
//       final prayerTimes = await _prayerService.getPrayerTimes();
//
//       // Start checking for Fajr time
//       startCheckingForFajr();
//
//       emit(HomeLoaded(prayerTimes)); // Emit loaded state with prayer times
//     } catch (e) {
//       emit(HomeError("Failed to fetch prayer times: $e"));
//     }
//   }
//
//   void startCheckingForFajr() {
//     // Hardcoded Fajr prayer time
//     final String fajrTime = "21:17"; // Hardcoded Fajr time
//
//     // Start a timer to check every minute
//     _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
//       final now = DateTime.now();
//       final currentTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
//
//       // Print current time for debugging
//       print("Current Time: $currentTime");
//
//       // Check if the current time matches the hardcoded Fajr time
//       if (currentTime == fajrTime) {
//         // Send notification if the time matches
//         String notificationMessage = "It's time for Fajr at $fajrTime";
//         await _notificationService.showNotification("Prayer Time Alert", notificationMessage);
//         print("Notification sent for Fajr at $fajrTime");
//
//         // Cancel the timer after sending the notification
//         timer.cancel();
//       }
//     });
//   }
//
//   @override
//   Future<void> close() async {
//     _timer?.cancel(); // Cancel the timer when closing the cubit
//     super.close();
//   }
// }
