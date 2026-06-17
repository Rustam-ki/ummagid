// lib/services/guide_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/guide.dart';
import 'auth_service.dart';

/// Сервис личного кабинета гида.
/// Все запросы требуют авторизации (Bearer-токен) и работают
/// только для пользователей с ролью `guide`.
class GuideService {
  static const String baseUrl = 'https://umragid.ru/api';

  static Future<Map<String, String>> _authHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Профиль гида (его собственная карточка).
  static Future<Guide> getMyProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/guide/profile'),
      headers: await _authHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Бэкенд может вернуть как {data: {...}}, так и сам объект
      final json = data['data'] ?? data;
      return Guide.fromJson(json);
    }
    throw Exception('Не удалось загрузить профиль (${response.statusCode})');
  }

  /// Бронирования, адресованные этому гиду.
  static Future<List<dynamic>> getMyBookings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/guide/bookings'),
      headers: await _authHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] ?? data) as List<dynamic>;
    }
    throw Exception('Не удалось загрузить брони (${response.statusCode})');
  }

  /// Подтвердить бронирование.
  static Future<bool> confirmBooking(int bookingId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/guide/bookings/$bookingId/confirm'),
      headers: await _authHeaders(),
    );
    return response.statusCode == 200;
  }

  /// Отклонить/отменить бронирование.
  static Future<bool> rejectBooking(int bookingId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/guide/bookings/$bookingId/reject'),
      headers: await _authHeaders(),
    );
    return response.statusCode == 200;
  }

  /// Обновить свой профиль (bio, телефон, цены и т.д.).
  static Future<bool> updateProfile(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/guide/profile'),
      headers: await _authHeaders(),
      body: jsonEncode(data),
    );
    return response.statusCode == 200;
  }
}
