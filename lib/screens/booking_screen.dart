import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/guide.dart';
import 'package:my_first_app/services/auth_service.dart';
import 'package:my_first_app/screens/login_screen.dart';


class BookingScreen extends StatefulWidget {
  final Guide guide;
  
  const BookingScreen({super.key, required this.guide});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 1));
  int _persons = 1;
  
  @override
  Widget build(BuildContext context) {
    final days = _selectedEndDate.difference(_selectedStartDate).inDays + 1;
    final totalPrice = widget.guide.pricePerDay * days * _persons;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Бронирование'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о гиде
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.guide.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('⭐ ${widget.guide.rating} (${widget.guide.reviewsCount} отзывов)'),
                    Text('📍 ${widget.guide.cityName}'),
                    Text('💵 ${widget.guide.pricePerDay} SAR/день'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Дата начала
            const Text(
              'Дата начала',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(_formatDate(_selectedStartDate)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _selectStartDate(context),
              ),
            ),
            const SizedBox(height: 16),
            
            // Дата окончания
            const Text(
              'Дата окончания',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(_formatDate(_selectedEndDate)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _selectEndDate(context),
              ),
            ),
            const SizedBox(height: 16),
            
            // Количество человек
            const Text(
              'Количество паломников',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (_persons > 1) {
                          setState(() => _persons--);
                        }
                      },
                    ),
                    Text(
                      '$_persons',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (_persons < 20) {
                          setState(() => _persons++);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Итого
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'ИТОГО К ОПЛАТЕ',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${totalPrice.toInt()} SAR',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  Text(
                    '${widget.guide.pricePerDay} SAR/день × $days дней × $_persons чел.',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Кнопка "Оформить"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _createBooking(context, totalPrice),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Оформить',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
  
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        if (_selectedEndDate.isBefore(_selectedStartDate)) {
          _selectedEndDate = _selectedStartDate.add(const Duration(days: 1));
        }
      });
    }
  }
  
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate,
      firstDate: _selectedStartDate,
      lastDate: _selectedStartDate.add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
      });
    }
  }
  
  Future<void> _createBooking(BuildContext context, double totalPrice) async {
    // Проверяем авторизацию
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пожалуйста, войдите в аккаунт для бронирования'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
      return;
    }

    // Показываем индикатор загрузки
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final bookingData = {
      'guide_id': widget.guide.id,
      'start_date': _selectedStartDate.toIso8601String().split('T')[0],
      'end_date': _selectedEndDate.toIso8601String().split('T')[0],
      'persons': _persons,
      'total_price': totalPrice,
      'customer_name': 'Тестовый пользователь',
      'customer_phone': '+70000000000',
      'status': 'pending',
    };

    // ← ПОЛУЧАЕМ ТОКЕН
    final token = await AuthService.getToken();
    print('🔵 BOOKING TOKEN: $token');

    try {
      final response = await http.post(
        Uri.parse('https://umragid.ru/api/bookings'), // ← https!
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null)
            'Authorization': 'Bearer $token', // ← ДОБАВЛЯЕМ ТОКЕН
        },
        body: jsonEncode(bookingData),
      );

      print('🔵 RESPONSE STATUS: ${response.statusCode}');
      print('🔵 RESPONSE BODY: ${response.body}');

      // Закрываем индикатор
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      if (response.statusCode == 201) {
        // Успех
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Бронирование создано!'),
            backgroundColor: Colors.green,
          ),
        );
        // Возвращаемся на экран деталей
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // Ошибка
        final responseData = jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '❌ Ошибка: ${responseData['message'] ?? response.statusCode}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Закрываем индикатор
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // Ошибка соединения
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Ошибка соединения: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}