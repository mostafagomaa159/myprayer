// part of '../home_imports.dart';
//
// class HomeViewModel {
//   /// services
//   final PrayerService _prayerService = locator<PrayerService>();
//   final NotificationService _notificationService = locator<NotificationService>();
//
//   /// cubits
//   final GenericCubit<Map<String, String>> prayerTimesCubit =
//   GenericCubit<Map<String, String>>({});
//
//   /// state values
//   String? errorMessage;
//   Timer? _dailyRescheduleTimer;
//
//   /// getters
//   Map<String, String> get prayerTimes => prayerTimesCubit.state.data;
//
//   /// init
//   void init() {
//     // You can call fetchAndScheduleAlerts() here if you want auto-load on open
//   }
//
//   /// Fetch prayer times and schedule notifications
//   Future<void> fetchAndScheduleAlerts() async {
//     errorMessage = null;
//
//     try {
//       await _notificationService.cancelAllNotifications();
//
//       final hasPermission =
//       await _notificationService.requestExactAlarmPermission();
//       if (!hasPermission) {
//         errorMessage = "Exact alarm permission is required";
//         prayerTimesCubit.onUpdateData({});
//         return;
//       }
//
//       final prayerTimes = await _prayerService.getPrayerTimes();
//
//       await _scheduleFuturePrayers(prayerTimes);
//       await _notificationService.printPendingNotifications();
//       _scheduleDailyReschedule();
//
//       prayerTimesCubit.onUpdateData(prayerTimes);
//     } catch (e) {
//       errorMessage = "Failed to schedule notifications: $e";
//       prayerTimesCubit.onUpdateData({});
//     }
//   }
//
//   Future<void> cancelAllNotifications() async {
//     await _notificationService.cancelAllNotifications();
//     prayerTimesCubit.onUpdateData({});
//   }
//
//   Future<void> printScheduledPrayers() async {
//     await _notificationService.printPendingNotifications();
//   }
//
//   // ==================== Private Methods ====================
//
//   Future<void> _scheduleFuturePrayers(Map<String, String> prayerTimes) async {
//     final prayers = ["Fajr", "Dhuhr", "Asr", "Maghrib", "Isha"];
//
//     for (int i = 0; i < prayers.length; i++) {
//       final prayerName = prayers[i];
//       final prayerTime = prayerTimes[prayerName];
//
//       if (prayerTime != null &&
//           _notificationService.isPrayerTimeInFuture(prayerTime)) {
//         await _notificationService.schedulePrayerNotification(
//           prayerName: prayerName,
//           prayerTime: prayerTime,
//           id: i,
//         );
//       } else if (prayerTime != null) {
//         print("$prayerName ($prayerTime) has already passed. Skipping.");
//       }
//     }
//   }
//
//   Future<void> testNotificationIn2Minutes() async {
//     await _notificationService.testNotificationIn2Minutes();
//   }
//
//   void _scheduleDailyReschedule() {
//     _dailyRescheduleTimer?.cancel();
//
//     final now = DateTime.now();
//     final nextMidnight = DateTime(now.year, now.month, now.day + 1);
//
//     _dailyRescheduleTimer = Timer(
//       nextMidnight.difference(now),
//           () async {
//         print("Midnight reschedule triggered...");
//         await fetchAndScheduleAlerts();
//       },
//     );
//   }
//
//   void dispose() {
//     _dailyRescheduleTimer?.cancel();
//   }
// }
