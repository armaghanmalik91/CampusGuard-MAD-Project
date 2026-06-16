import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2/campus_guard_api';

  static Future<Map<String, dynamic>> sendOtp({
    required String email,
    required String role,
    required String purpose,
  }) async {
    final url = Uri.parse('$baseUrl/send_otp.php');

    final response = await http.post(
      url,
      body: {
        'email': email,
        'role': role,
        'purpose': purpose,
      },
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
    required String role,
    required String purpose,
  }) async {
    final url = Uri.parse('$baseUrl/verify_otp.php');

    final response = await http.post(
      url,
      body: {
        'email': email,
        'otp': otp,
        'role': role,
        'purpose': purpose,
      },
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> setPassword({
    required String email,
    required String password,
    required String role,
    required String purpose,
    String firstName = '',
    String lastName = '',
  }) async {
    final url = Uri.parse('$baseUrl/set_password.php');

    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'role': role,
        'purpose': purpose,
        'first_name': firstName,
        'last_name': lastName,
      },
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/login.php');

    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'role': role,
      },
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> googleSignup({
    required String email,
    required String firstName,
    required String lastName,
    required String googleUid,
    String photoUrl = '',
  }) async {
    final url = Uri.parse('$baseUrl/google_signup.php');

    final response = await http.post(
      url,
      body: {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'google_uid': googleUid,
        'photo_url': photoUrl,
        'role': 'student',
      },
    );

    return jsonDecode(response.body);
  }
  static Future<Map<String, dynamic>> sendSosAlert({
    required String email,
    required String alertType,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/save_sos.php');
      final response = await http.post(
        url,
        body: {
          'email': email,
          'alert_type': alertType,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Server error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection failed'};
    }
  }
  // Submit Incident Report API
  // Submit Incident Report API with Media
  static Future<Map<String, dynamic>> submitIncidentReport({
    required String email,
    required String category,
    required String description,
    String? photoPath,
    String? audioPath,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/save_incident.php');
      
      // Multipart request for sending files + text
      var request = http.MultipartRequest('POST', url);
      
      // Text data
      request.fields['email'] = email;
      request.fields['category'] = category;
      request.fields['description'] = description;

      // File data (Photo)
      if (photoPath != null && photoPath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('photo', photoPath));
      }

      // File data (Audio)
      if (audioPath != null && audioPath.isNotEmpty) {
        request.files.add(await http.MultipartFile.fromPath('audio', audioPath));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Server error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection failed'};
    }
  }
}

