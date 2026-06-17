import 'package:flutter/material.dart';
import 'package:flutter_cors_image/flutter_cors_image.dart';
import '../models/guide.dart';
import '../widgets/sar_price_text.dart';
import 'booking_screen.dart';

class GuideDetailScreen extends StatelessWidget {
  final Guide guide;

  const GuideDetailScreen({super.key, required this.guide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(guide.name),
        backgroundColor: const Color(0xFF0F6B52),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== ФОТОГРАФИЯ ==========
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    guide.photoUrl != null && guide.photoUrl!.startsWith('http')
                    ? CustomNetworkImage(
                        url: guide.photoUrl!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Фото не загрузилось',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Icon(Icons.person, size: 80, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // ========== ИМЯ И РЕЙТИНГ ==========
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    guide.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    '⭐ ${guide.rating.toStringAsFixed(1)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // ========== ГОРОД И ЯЗЫКИ ==========
            Text(
              '📍 ${guide.cityName}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              '🗣️ ${guide.languages.map((l) {
                if (l == 'russian') return 'Русский';
                if (l == 'arabic') return 'Арабский';
                if (l == 'english') return 'Английский';
                return l;
              }).join(', ')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // ========== О СЕБЕ (БИОГРАФИЯ) ==========
            if (guide.bio != null && guide.bio!.isNotEmpty) ...[
              const Text(
                '📖 О себе',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                guide.bio!,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 16),
            ],

            // ========== ОПЫТ ==========
            if (guide.experienceYears != null || guide.groupsCount != null) ...[
              const Text(
                '👨‍🏫 Опыт',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (guide.experienceYears != null)
                Text('• Опыт работы: ${guide.experienceYears} лет'),
              if (guide.groupsCount != null)
                Text('• Проведено групп: ${guide.groupsCount}'),
              const SizedBox(height: 16),
            ],

            // ========== УСЛУГИ ==========
            if (guide.services != null && guide.services!.isNotEmpty) ...[
              const Text(
                '🛎️ Услуги',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: guide.services!.map((service) {
                  return Chip(
                    label: Text(service),
                    backgroundColor: const Color(0xFF0F6B52).withOpacity(0.1),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ========== АВТОМОБИЛЬ ==========
            if (guide.hasCar == true) ...[
              const Text(
                '🚗 Автомобиль',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (guide.carModel != null) Text('• Модель: ${guide.carModel}'),
              if (guide.carCapacity != null)
                Text('• Количество мест: ${guide.carCapacity}'),
              const SizedBox(height: 16),
            ],

            // ========== КОНТАКТЫ ==========
            const Text(
              '📞 Контакты',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (guide.phone != null && guide.phone!.isNotEmpty)
              Text('• Телефон: ${guide.phone}'),
            if (guide.whatsapp != null && guide.whatsapp!.isNotEmpty)
              Text('• WhatsApp: ${guide.whatsapp}'),
            if (guide.telegram != null && guide.telegram!.isNotEmpty)
              Text('• Telegram: ${guide.telegram}'),
            if (guide.instagram != null && guide.instagram!.isNotEmpty)
              Text('• Instagram: ${guide.instagram}'),
            const SizedBox(height: 16),

            // ========== ЦЕНА ==========
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F6B52).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Стоимость:', style: TextStyle(fontSize: 18)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SarPriceText(
                        sar: guide.pricePerDay,
                        suffix: ' / день',
                        crossAxisAlignment: CrossAxisAlignment.end,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F6B52),
                        ),
                      ),
                      if (guide.pricePerHour != null)
                        SarPriceText(
                          sar: guide.pricePerHour!,
                          suffix: ' / час',
                          crossAxisAlignment: CrossAxisAlignment.end,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0F6B52),
                          ),
                        ),
                      if (guide.pricePerUmrah != null)
                        SarPriceText(
                          sar: guide.pricePerUmrah!,
                          suffix: ' / умра',
                          crossAxisAlignment: CrossAxisAlignment.end,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0F6B52),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // ========== ПРАЙС-ЛИСТ ПО УСЛУГАМ ==========
            if (guide.pricing.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                '💰 Цены на услуги',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...guide.pricing.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(item.name)),
                      SarPriceText(
                        sar: item.price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F6B52),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // ========== КНОПКА "ЗАБРОНИРОВАТЬ" ==========
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(guide: guide),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F6B52),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Забронировать',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
