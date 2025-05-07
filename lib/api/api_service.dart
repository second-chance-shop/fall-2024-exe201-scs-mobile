import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api/v1'; // Thay bằng URL backend của bạn
  final _storage = const FlutterSecureStorage();

  // Lấy accessToken từ storage
  Future<String?> _getToken() async {
    return await _storage.read(key: 'accessToken');
  }

  // GET: Fetch data từ backend
  Future<List<dynamic>> getData(String endpoint) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // POST: Gửi data đến backend
  Future<Map<String, dynamic>> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error posting data: $e');
    }
  }

  // PUT: Cập nhật data trên backend
  Future<Map<String, dynamic>> updateData(String endpoint, int id, Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating data: $e');
    }
  }

  // DELETE: Xóa data từ backend
  Future<void> deleteData(String endpoint, int id) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint/$id'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting data: $e');
    }
  }
}