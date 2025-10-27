import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<dynamic> get(String path) async {
    final response = await http.get(Uri.parse('$baseUrl$path'));
    return response.body;
  }

  Future<dynamic> post(String path, dynamic body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.body;
  }

  Future<dynamic> patch(String path, dynamic body) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$path'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.body;
  }

  Future<dynamic> delete(String path) async {
    final response = await http.delete(Uri.parse('$baseUrl$path'));
    return response.body;
  }
}
