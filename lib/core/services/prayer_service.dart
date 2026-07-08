import 'dart:convert';
import 'package:http/http.dart' as http;
import 'location_service.dart';
import 'notification_service.dart';

class PrayerService {
  final LocationService _locationService;
  final NotificationService _notificationService;

  PrayerService(this._locationService, this._notificationService);

  Future<Map<String, String>> getPrayerTimes() async {
    // Get the current location
    final position = await _locationService.getCurrentPosition();
    print("Current Position: ${position.latitude}, ${position.longitude}");

    final url = Uri.parse(
        'https://api.aladhan.com/v1/timings?latitude=${position.latitude}&longitude=${position.longitude}&method=4'
    );

    try {
      // Send the GET request
      final response = await http.get(url);

      // Print the raw response for debugging
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        final data = json.decode(response.body);
        print("Decoded JSON data: $data"); // Log the entire JSON structure

        // Extract and return the prayer times as a Map<String, String>
        Map<String, String> prayerTimes = {
          "Fajr": data['data']['timings']['Fajr'],
          "Dhuhr": data['data']['timings']['Dhuhr'],
          "Asr": data['data']['timings']['Asr'],
          "Maghrib": data['data']['timings']['Maghrib'],
          "Isha": data['data']['timings']['Isha'],
        };

        return prayerTimes;
      } else {
        // Handle the error case
        throw Exception('Failed to load prayer times: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching prayer times: $e");
      throw Exception('Error fetching prayer times: $e');
    }
  }
}
