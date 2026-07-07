import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location_service.dart';
import 'notification_service.dart';

class PrayerService {
  final LocationService _locationService;
  final NotificationService _notificationService;

  PrayerService(this._locationService, this._notificationService);

  Future<Map<String, dynamic>> getPrayerTimes() async {
    final position = await _locationService.getCurrentPosition();
    final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=${position.latitude}&longitude=${position.longitude}&method=4');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['timings'];
    } else {
      throw Exception('Failed to load prayer times');
    }
  }
}
