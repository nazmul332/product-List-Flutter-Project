import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';

class ApiService {
  static const String baseUrl = 'https://product-list-app-backend-h7hw.onrender.com/api/v1';

  Map<String, String> get _authHeaders {
    final token = StorageService.to.token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Map<String, String> get _bareAuthHeaders {
    final token = StorageService.to.token;
    return {
      if (token != null) 'Authorization': '$token',
    };
  }


  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  Future<List<dynamic>> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/'),
      headers: _bareAuthHeaders,
    );
    final decoded = _handleListResponse(response);
    return decoded;
  }

  Future<Map<String, dynamic>> getProductDetail(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: _bareAuthHeaders,
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createProduct(
      Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products/'),
      headers: _authHeaders,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateProduct(
      int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/products/$id'),
      headers: _authHeaders,
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: _authHeaders,
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body as Map<String, dynamic>;
    }
    final message = (body is Map && body.containsKey('message'))
        ? body['message']
        : response.reasonPhrase ?? 'Unknown error';
    throw ApiException(message, response.statusCode);
  }

  List<dynamic> _handleListResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    final body = jsonDecode(response.body);
    final message = (body is Map && body.containsKey('message'))
        ? body['message']
        : response.reasonPhrase ?? 'Unknown error';
    throw ApiException(message, response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
