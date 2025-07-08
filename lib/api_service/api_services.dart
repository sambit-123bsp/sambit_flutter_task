import 'dart:convert';
import 'package:http/http.dart' as http;
import '../local_storage/store_accessToken.dart';
import 'api_service_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  final String _baseUrl = 'http://localhost:3030';

  Future<Map<String, String>> _buildHeaders({bool withAuth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await SecureStorageService().accessToken;
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<ApiResponse> get(String endpoint, {bool withAuth = true}) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint');
      final res = await http.get(url, headers: await _buildHeaders(withAuth: withAuth));
      return _handleResponse(res);
    } catch (e) {
      return ApiResponse.error("Something went wrong: $e");
    }
  }

  Future<ApiResponse> post(String endpoint, dynamic body, {bool withAuth = true}) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint');
      final res = await http.post(
        url,
        headers: await _buildHeaders(withAuth: withAuth),
        body: jsonEncode(body),
      );
      return _handleResponse(res);
    } catch (e) {
      return ApiResponse.error("Something went wrong: $e");
    }
  }

  Future<ApiResponse> patch(String endpoint, dynamic body, {bool withAuth = true}) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint');
      final res = await http.patch(
        url,
        headers: await _buildHeaders(withAuth: withAuth),
        body: jsonEncode(body),
      );
      return _handleResponse(res);
    } catch (e) {
      return ApiResponse.error("Something went wrong: $e");
    }
  }

  Future<ApiResponse> delete(String endpoint, {bool withAuth = true}) async {
    try {
      final url = Uri.parse('$_baseUrl/$endpoint');
      final res = await http.delete(
        url,
        headers: await _buildHeaders(withAuth: withAuth),
      );
      return _handleResponse(res);
    } catch (e) {
      return ApiResponse.error("Something went wrong: $e");
    }
  }

  ApiResponse _handleResponse(http.Response res) {
    try {
      final jsonData = jsonDecode(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse.success(jsonData, res.statusCode);
      } else {
        final errorMsg = jsonData['message'] ?? 'Unexpected error';
        return ApiResponse.error(errorMsg, res.statusCode);
      }
    } catch (e) {
      return ApiResponse.error("Invalid response format", res.statusCode);
    }
  }
}
