// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/guide.dart';
import 'auth_service.dart';

class ApiService {
  // Для Android эмулятора
  static const String baseUrl = 'https://umragid.ru/api';
  
  static Future<List<Guide>> getGuides() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/guides'),
        headers: {'Accept': 'application/json'},
      );
      
      print('API Status: ${response.statusCode}');
      print('API Response: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Guide.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Не удалось загрузить гидов: $e');
    }
  }
  
  static Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    final token = await AuthService.getToken();
    
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
    
    return jsonDecode(response.body);
  }
}