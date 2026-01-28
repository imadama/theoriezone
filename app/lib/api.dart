import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  // Voor Android emulator is localhost 10.0.2.2
  // Voor iOS simulator is localhost 127.0.0.1
  // We gebruiken hier een slimme getter of config.
  // Laten we voor nu 10.0.2.2 aannemen (Android default).
  static const String baseUrl = 'http://10.0.2.2:8080/api'; 

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await getToken();
    return http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> get(String endpoint) async {
    final token = await getToken();
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}
