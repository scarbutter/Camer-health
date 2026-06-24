import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constantes/constantes_app.dart';

class ServiceApi {
  static String? _token;
  static String? _userId;

  static void setSession(String token, String userId) {
    _token = token;
    _userId = userId;
  }

  static void clearSession() {
    _token = null;
    _userId = null;
  }

  static String? get userId => _userId;

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  static Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await http
        .post(
          Uri.parse('${ConstantesApp.urlApi}$path'),
          headers: _headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final response = await http
        .get(Uri.parse('${ConstantesApp.urlApi}$path'), headers: _headers)
        .timeout(const Duration(seconds: 15));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final response = await http
        .put(
          Uri.parse('${ConstantesApp.urlApi}$path'),
          headers: _headers,
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 15));
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
