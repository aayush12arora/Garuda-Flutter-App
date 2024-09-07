import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceApi {
  final String apiUrl = 'https://garuda-ams.vercel.app/api/attendance/manualCheckIn'; // Replace with your API URL
  final String apiUrlout = 'https://garuda-ams.vercel.app/api/attendance/manualCheckOut';
  final String apiUrlgetattendanceDetails = 'https://garuda-ams.vercel.app/api/attendance/getAttendanceAndWorkingHours'; // Replace with your actual Supabase API URL

  Future<Map<String, dynamic>> manualCheckIn({
    required  int employeeId,
    required int officeId,
    required DateTime timestamp,
  }) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'employee_id': employeeId,
        'office_id': officeId,
        'event_time': timestamp.toIso8601String(), // Convert DateTime to ISO8601 string
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to manually check in: ${response.body}');
    }
  }





  Future<Map<String, dynamic>> manualCheckOut({
    required int employeeId,
    required int officeId,
    required DateTime timestamp,
  }) async {
    final response = await http.post(
      Uri.parse(apiUrlout),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'employee_id': employeeId,
        'office_id': officeId,
        'event_time': timestamp.toIso8601String(), // Convert DateTime to ISO8601 string
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to manually check in: ${response.body}');
    }
  }





  Future<Map<String, dynamic>> fetchAttendanceAndWorkingHours({
    required  int employeeId,
    required DateTime date,
  }) async {
    // Format the date to the required format YYYY-MM-DD
    final formattedDate = date.toIso8601String().split('T')[0];

    // Build the URL with query parameters
    final Uri url = Uri.parse('$apiUrlgetattendanceDetails?employee_id=$employeeId&date=$formattedDate');

    // Send the GET request
    final response = await http.get(url);

    // Check for a successful response
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch attendance and working hours: ${response.body}');
    }
  }
}
