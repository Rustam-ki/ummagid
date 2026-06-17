// lib/services/currency_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Курс SAR -> RUB. Кэшируется в памяти на час, чтобы не дёргать API
/// при каждой отрисовке карточки гида.
class CurrencyService {
  static double? _sarToRub;
  static DateTime? _fetchedAt;

  static Future<double?> getSarToRubRate() async {
    if (_sarToRub != null &&
        DateTime.now().difference(_fetchedAt!) < const Duration(hours: 1)) {
      return _sarToRub;
    }

    try {
      final response = await http
          .get(Uri.parse('https://open.er-api.com/v6/latest/SAR'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rate = (data['rates']?['RUB'] as num?)?.toDouble();
        if (rate != null) {
          _sarToRub = rate;
          _fetchedAt = DateTime.now();
          return rate;
        }
      }
    } catch (_) {
      // сеть недоступна — покажем цену без конвертации
    }

    return _sarToRub;
  }
}
