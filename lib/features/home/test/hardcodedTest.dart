// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:myprayer/core/services/prayer_service.dart';
// import 'package:myprayer/core/services/notification_service.dart';
// import 'package:myprayer/features/home/view_model/home_state.dart';
//
//
// class HomeCubit extends Cubit<HomeState> {
//   final PrayerService _prayerService;
//   final NotificationService _notificationService;
//
//   HomeCubit(this._prayerService, this._notificationService) : super(HomeInitial());
//
//   Future<void> fetchAndScheduleAlerts() async {
//     emit(HomeLoading());
//     try {
//       final prayerTimes = await _prayerService.getPrayerTimes();
//
//       // Hardcoded time for testing (e.g., Asr prayer time)
//       // You can change this to match any prayer time you want to test
//       final String hardcodedTime = "21:30"; // Example Asr time for testing
//
//       // Print current time for debugging
//       print("Hardcoded Time for Testing: $hardcodedTime");
//
//       // Loop through prayer times and check for matches
//       for (var entry in prayerTimes.entries) {
//         String prayerName = entry.key;
//         String prayerTime = entry.value;
//
//         // Print each prayer time for debugging
//         print("Checking Prayer: $prayerName at $prayerTime against hardcoded time: $hardcodedTime");
//
//         // Check if the hardcoded time matches the prayer time
//         if (prayerTime == hardcodedTime) {
//           // Send notification if the time matches
//           String notificationMessage = "It's time for $prayerName at $prayerTime";
//           await _notificationService.showNotification("Prayer Time Alert", notificationMessage);
//           print("Notification sent for $prayerName at $prayerTime");
//         }
//       }
//
//       emit(HomeLoaded(prayerTimes)); // Emit loaded state with prayer times
//     } catch (e) {
//       emit(HomeError("Failed to fetch prayer times: $e"));
//     }
//   }
// }
