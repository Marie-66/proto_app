import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "http://127.0.0.1:8000/api";

  static const String faceUrl =
      "http://127.0.0.1:5001";

  static Future<List<dynamic>> getEvents() async {
    try {
      print('CALLING URL: $baseUrl/events');

      final response = await http
          .get(
        Uri.parse('$baseUrl/events'),
        headers: {
          'Accept': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 15));

      print('GET EVENTS STATUS: ${response.statusCode}');
      print('GET EVENTS BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          return decoded;
        } else {
          throw Exception('Invalid response format: expected a list');
        }
      } else {
        throw Exception(
          'Failed to load events. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } on SocketException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on TimeoutException {
      throw Exception('Request timed out. Check Laravel server and network.');
    } on FormatException catch (e) {
      throw Exception('Invalid JSON response: $e');
    } catch (e) {
      throw Exception('Unexpected error loading events: $e');
    }
  }


  // update event
  static Future<Map<String, dynamic>> updateEvent({
    required String id,
    required String title,
    required String venue,
    required String department,
    required String office,
    required String organizer,
    required String description,
    required int capacity,
  }) async {
    try {
      final response = await http
          .put(
        Uri.parse('$baseUrl/events/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'venue': venue,
          'department': department,
          'office': office,
          'organizer': organizer,
          'description': description,
          'capacity': capacity,
        }),
      )
          .timeout(const Duration(seconds: 15));

      print('UPDATE EVENT STATUS: ${response.statusCode}');
      print('UPDATE EVENT BODY: ${response.body}');

      return {
        'success': response.statusCode == 200,
        'status': response.statusCode,
        'body': response.body,
      };
    } on SocketException catch (e) {
      return {
        'success': false,
        'status': 0,
        'body': 'Network error: ${e.message}',
      };
    } on TimeoutException {
      return {
        'success': false,
        'status': 0,
        'body': 'Request timed out',
      };
    } catch (e) {
      return {
        'success': false,
        'status': 0,
        'body': 'Unexpected error: $e',
      };
    }
  }

  // create event
  static Future<Map<String, dynamic>> createEvent({
    required String title,
    required String venue,
    required String department,
    required String office,
    required String organizer,
    required String description,
    required int capacity,
    required String dateTime,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse('$baseUrl/events'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'venue': venue,
          'department': department,
          'office': office,
          'organizer': organizer,
          'description': description,
          'capacity': capacity,
          'date_time': dateTime,
        }),
      )
          .timeout(const Duration(seconds: 15));

      print('CREATE EVENT STATUS: ${response.statusCode}');
      print('CREATE EVENT BODY: ${response.body}');

      return {
        'success': response.statusCode == 201 || response.statusCode == 200,
        'status': response.statusCode,
        'body': response.body,
      };
    } on SocketException catch (e) {
      return {
        'success': false,
        'status': 0,
        'body': 'Network error: ${e.message}',
      };
    } on TimeoutException {
      return {
        'success': false,
        'status': 0,
        'body': 'Request timed out',
      };
    } catch (e) {
      return {
        'success': false,
        'status': 0,
        'body': 'Unexpected error: $e',
      };
    }
  }


  //delete event
  static Future<Map<String, dynamic>> deleteEvent(String id) async {
    try {
      final response = await http
          .delete(
        Uri.parse('$baseUrl/events/$id'),
        headers: {
          'Accept': 'application/json',
        },
      )
          .timeout(const Duration(seconds: 15));

      print('DELETE EVENT STATUS: ${response.statusCode}');
      print('DELETE EVENT BODY: ${response.body}');

      return {
        'success': response.statusCode == 200,
        'status': response.statusCode,
        'body': response.body,
      };
    } on SocketException catch (e) {
      return {
        'success': false,
        'status': 0,
        'body': 'Network error: ${e.message}',
      };
    } on TimeoutException {
      return {
        'success': false,
        'status': 0,
        'body': 'Request timed out',
      };
    } catch (e) {
      return {
        'success': false,
        'status': 0,
        'body': 'Unexpected error: $e',
      };
    }
  }

  //save attendance
  static Future<Map<String, dynamic>> saveAttendance({
    required String eventId,
    required String staffId,
    String method = 'manual',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/attendance'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'event_id': eventId,
          'staff_id': staffId,
          'method': method,
        }),
      );

      print('ATTENDANCE STATUS: ${response.statusCode}');
      print('ATTENDANCE BODY: ${response.body}');

      return {
        'success': response.statusCode == 201,
        'body': response.body,
      };
    } catch (e) {
      return {
        'success': false,
        'body': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getStaffById(
    String staffId,
) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/staff/$staffId'),
      headers: {
        'Accept': 'application/json',
      },
    );

    return {
      'success': response.statusCode == 200,
      'body': response.body,
    };
  } catch (e) {
    return {
      'success': false,
      'body': e.toString(),
    };
  }

}

  static Future<Map<String, dynamic>> matchFace(
      File imageFile,
      ) async {
    try {

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$faceUrl/match'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      var streamedResponse =
      await request.send();

      var response =
      await http.Response.fromStream(
        streamedResponse,
      );

      return {
        'success': response.statusCode == 200,
        'body': jsonDecode(response.body),
      };

    } catch (e) {

      return {
        'success': false,
        'body': e.toString(),
      };
    }
  }


}