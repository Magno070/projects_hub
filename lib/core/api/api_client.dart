import 'package:http/http.dart' as http;

import 'dart:convert';

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Uri _buildUri(String path, Map<String, dynamic>? queryParams) {
    final uri = Uri.parse('$baseUrl$path');

    if (queryParams != null && queryParams.isNotEmpty) {
      // Converte Map<String, dynamic> para Map<String, String>
      final queryStringMap = queryParams.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      return uri.replace(queryParameters: queryStringMap);
    }

    return uri;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParams}) async {
    final uri = _buildUri(path, queryParams);
    final response = await http.get(uri);
    return response.body;
  }

  Future<dynamic> post(
    String path,
    dynamic body, {
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.body;
  }

  Future<dynamic> patch(
    String path,
    dynamic body, {
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);
    final response = await http.patch(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    return response.body;
  }

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = _buildUri(path, queryParams);
    final response = await http.delete(uri);
    return response.body;
  }
}
