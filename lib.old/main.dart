import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Umra Guide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          primary: const Color(0xFF1B5E20),
          secondary: const Color(0xFFC8A951),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B5E20),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        fontFamily: 'Roboto',
      ),
      home: const MyHomePage(title: 'Umra Guide'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MainScreen(),
    const UmraScreen(),
    const PrayerTimesScreen(),
    const QiblaScreen(),
    const BestDaysScreen(),
    const ReviewsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1B5E20),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.mosque), label: 'Умра'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Намазы',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration),
            label: 'Кибла',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Лучшие дни',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Отзывы'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
// ========== ГЛАВНЫЙ ЭКРАН МАРКЕТПЛЕЙСА ==========
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _selectedCategory = 'Все'; // Все, Гиды, Трансферы
  int _selectedTab = 0; // 0 - рекомендации, 1 - рядом, 2 - топ
  // Метод для диалога с советами по самостоятельной Умре
  void _showIndependentTipsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      '🕋 Как организовать Умру самостоятельно?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTipSection(
                    '✈️ 1. Авиабилеты',
                    '• Авиакомпании: Saudia, FlyNas, Air Arabia, FlyDubai\n'
                    '• Лучшие цены: за 2-3 месяца до поездки\n'
                    '• Средняя цена: \$400-700 из Москвы\n'
                    '• Стыковки: через Дубай, Доху, Стамбул',
                  ),
                  _buildTipSection(
                    '🏨 2. Отели',
                    '• Booking.com, Agoda, Expedia\n'
                    '• Мекка: от \$30/ночь (3*), \$80-150 (5*)\n'
                    '• Медина: от \$25/ночь (3*), \$60-120 (5*)\n'
                    '• Выбирайте отели рядом с Харамом',
                  ),
                  _buildTipSection(
                    '📄 3. Виза',
                    '• Виза для Умры - БЕСПЛАТНО!\n'
                    '• Оформление онлайн: официальный сайт МИД КСА\n'
                    '• Нужен: загранпаспорт, фото, страховка\n'
                    '• Время получения: 5-15 минут',
                  ),
                  _buildTipSection(
                    '🚐 4. Трансферы',
                    '• Такси: Uber, Careem (дешевле отельных)\n'
                    '• Поезд Haramain: Мекка-Медина за 2 часа\n'
                    '• Автобусы SAPTCO: бюджетный вариант',
                  ),
                  _buildTipSection(
                    '💡 5. Советы по экономии',
                    '• Ешьте в местных кафе (дешевле отельных)\n'
                    '• Покупайте воду в супермаркетах\n'
                    '• Используйте общественный транспорт\n'
                    '• Скачайте приложение Nusuk для визы',
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.amber),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Важно: Убедитесь, что у вас есть страховка и медицинская справка!',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Понятно, спасибо!'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Метод для диалога помощи при заселении
  void _showHelpDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  '🛎️ Помощь при заселении',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Что мы предлагаем:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              _buildHelpListItem('🚐 Встреча в аэропорту с табличкой'),
              _buildHelpListItem('🏨 Трансфер до отеля на комфортном авто'),
              _buildHelpListItem('📋 Помощь с заполнением документов'),
              _buildHelpListItem('🗣️ Перевод при общении с ресепшен'),
              _buildHelpListItem('🔑 Помощь с заселением и багажом'),
              _buildHelpListItem('📞 Контакт 24/7 на время вашего пребывания'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.payment, color: Color(0xFF1B5E20)),
                    SizedBox(width: 8),
                    Text(
                      'Стоимость: от 50 SAR (≈ 1300₽)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Отмена'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Мы свяжемся с вами в ближайшее время!'),
                            backgroundColor: Color(0xFF1B5E20),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                      ),
                      child: const Text('Заказать'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Вспомогательные виджеты
  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1B5E20), size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Text(
            description,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTipSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          const Divider(height: 16),
        ],
      ),
    );
  }

  Widget _buildHelpListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF1B5E20), size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Umra Market'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
        centerTitle: false,
        actions: [
          // Корзина/бронирования
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== ПОИСКОВАЯ СТРОКА ==========
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Поиск гидов, трансферов, экскурсий...',
                    prefixIcon: Icon(Icons.search, color: Color(0xFF1B5E20)),
                    suffixIcon: Icon(Icons.tune, color: Color(0xFF1B5E20)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
            ),
            // После поисковой строки (после Padding с TextField)
            const SizedBox(height: 16),

            // ========== МОТИВАЦИОННЫЙ БЛОК ==========
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Умра может быть дешевле!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '✅ Самостоятельная организация Умры обходится на 30-50% дешевле\n'
                    '✅ Средняя цена тура от туроператора: \$2000-3000\n'
                    '✅ Самостоятельно: \$1000-1500 (авиабилеты + отель)\n'
                    '✅ Отели от \$30/ночь в Мекке и Медине\n'
                    '✅ Виза для Умры: бесплатно (оформляется онлайн)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Совет: Покупайте авиабилеты за 2-3 месяца до поездки, следите за акциями Saudia и FlyNas',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        _showIndependentTipsDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        '📘 Как организовать Умру самостоятельно?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ========== БЛОК ПОМОЩИ ПРИ ЗАСЕЛЕНИИ ==========
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: const Color(0xFF1B5E20).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.support_agent, color: Color(0xFF1B5E20), size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Помощь в заселении в отель',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Встретим вас в аэропорту, поможем с заселением и решим любые вопросы с отелем:',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildHelpCard(
                          icon: Icons.airport_shuttle,
                          title: 'Трансфер из аэропорта',
                          description: 'Доставим до отеля',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildHelpCard(
                          icon: Icons.hotel,
                          title: 'Заселение',
                          description: 'Поможем с документами',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildHelpCard(
                          icon: Icons.translate,
                          title: 'Переводчик',
                          description: 'Общение с персоналом',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildHelpCard(
                          icon: Icons.emergency,
                          title: '24/7 поддержка',
                          description: 'Любые вопросы',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showHelpDialog(context);
                      },
                      icon: const Icon(Icons.headset_mic),
                      label: const Text('Заказать помощь при заселении'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ========== КАТЕГОРИИ УСЛУГ ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryChip('Все', 0),
                  const SizedBox(width: 8),
                  _buildCategoryChip('👨‍🏫 Гиды', 1),
                  const SizedBox(width: 8),
                  _buildCategoryChip('🚐 Трансферы', 2),
                  const SizedBox(width: 8),
                  _buildCategoryChip('🕌 Экскурсии', 3),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ========== ВАЛЮТА И СОРТИРОВКА ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          size: 16,
                          color: Color(0xFF1B5E20),
                        ),
                        SizedBox(width: 4),
                        Text('SAR', style: TextStyle(fontSize: 12)),
                        Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.sort, size: 16),
                        SizedBox(width: 4),
                        Text('Сортировка', style: TextStyle(fontSize: 12)),
                        Icon(Icons.arrow_drop_down, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ========== ВКЛАДКИ (Рекомендации / Рядом / Топ) ==========
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTabButton('Для вас', 0),
                  const SizedBox(width: 16),
                  _buildTabButton('Рядом с вами', 1),
                  const SizedBox(width: 16),
                  _buildTabButton('Топ рейтинг', 2),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ========== СПИСОК ГИДОВ ==========
            if (_selectedCategory == 'Все' ||
                _selectedCategory == '👨‍🏫 Гиды') ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '👨‍🏫 Популярные гиды',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 280,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildGuideMarketCard(
                      name: 'Ахмад Аль-Хакими',
                      photo: '👳‍♂️',
                      rating: 4.9,
                      reviews: 234,
                      price: '150',
                      unit: 'час',
                      city: 'Мекка',
                      languages: 'Русский, Арабский',
                      isOnline: true,
                    ),
                    const SizedBox(width: 12),
                    _buildGuideMarketCard(
                      name: 'Юсуф Аль-Мадини',
                      photo: '👨‍🏫',
                      rating: 5.0,
                      reviews: 189,
                      price: '200',
                      unit: 'час',
                      city: 'Медина',
                      languages: 'Русский, Английский',
                      isOnline: true,
                    ),
                    const SizedBox(width: 12),
                    _buildGuideMarketCard(
                      name: 'Фатима Ахмед',
                      photo: '👩‍🏫',
                      rating: 4.8,
                      reviews: 156,
                      price: '120',
                      unit: 'час',
                      city: 'Джидда',
                      languages: 'Русский, Арабский',
                      isOnline: false,
                    ),
                    const SizedBox(width: 12),
                    _buildGuideMarketCard(
                      name: 'Омар Аль-Кураши',
                      photo: '🧕',
                      rating: 4.9,
                      reviews: 312,
                      price: '180',
                      unit: 'час',
                      city: 'Мекка',
                      languages: 'Английский, Урду',
                      isOnline: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ========== СПИСОК ТРАНСФЕРОВ ==========
            if (_selectedCategory == 'Все' ||
                _selectedCategory == '🚐 Трансферы') ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '🚐 Популярные трансферы',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildTransferMarketCard(
                      route: 'Аэропорт Джидда → Мекка',
                      duration: '1.5 часа',
                      price: '150',
                      vehicle: '🚐 Микроавтобус',
                      seats: 7,
                      rating: 4.8,
                    ),
                    const SizedBox(width: 12),
                    _buildTransferMarketCard(
                      route: 'Мекка → Медина',
                      duration: '4.5 часа',
                      price: '300',
                      vehicle: '🚌 Комфортабельный',
                      seats: 15,
                      rating: 4.9,
                    ),
                    const SizedBox(width: 12),
                    _buildTransferMarketCard(
                      route: 'Отель → Заповедная мечеть',
                      duration: '15 мин',
                      price: '40',
                      vehicle: '🚗 Седан VIP',
                      seats: 4,
                      rating: 4.9,
                    ),
                    const SizedBox(width: 12),
                    _buildTransferMarketCard(
                      route: 'Мекка → Аэропорт',
                      duration: '1.5 часа',
                      price: '150',
                      vehicle: '🚗 Седан',
                      seats: 4,
                      rating: 4.7,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ========== ЭКСКУРСИИ ==========
            if (_selectedCategory == 'Все' ||
                _selectedCategory == '🕌 Экскурсии') ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '🕌 Популярные экскурсии',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 260,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    _buildExcursionMarketCard(
                      title: 'Ночная Мекка',
                      duration: '4 часа',
                      price: '250',
                      groupSize: 'до 10 чел',
                      rating: 4.9,
                      imageIcon: '🕋',
                    ),
                    const SizedBox(width: 12),
                    _buildExcursionMarketCard(
                      title: 'Историческая Медина',
                      duration: '6 часов',
                      price: '300',
                      groupSize: 'до 15 чел',
                      rating: 5.0,
                      imageIcon: '🕌',
                    ),
                    const SizedBox(width: 12),
                    _buildExcursionMarketCard(
                      title: 'Джидда тур',
                      duration: '5 часов',
                      price: '220',
                      groupSize: 'до 12 чел',
                      rating: 4.8,
                      imageIcon: '🌊',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ========== БАННЕР-АКЦИЯ ==========
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8F00), Color(0xFFFFB300)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🔥 Скидка 20%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'на первый трансфер',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Промокод: UMRATOUR',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Виджет категории (чип)
  Widget _buildCategoryChip(String label, int index) {
    bool isSelected = _selectedCategory == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = label;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF1B5E20).withOpacity(0.1),
      checkmarkColor: const Color(0xFF1B5E20),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF1B5E20) : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected ? const Color(0xFF1B5E20) : Colors.grey[300]!,
        ),
      ),
    );
  }

  // Виджет вкладки
  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF1B5E20) : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 30,
            color: isSelected ? const Color(0xFF1B5E20) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  // Карточка гида для маркетплейса
  Widget _buildGuideMarketCard({
    required String name,
    required String photo,
    required double rating,
    required int reviews,
    required String price,
    required String unit,
    required String city,
    required String languages,
    required bool isOnline,
  }) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Фото и онлайн статус
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B5E20).withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(photo, style: const TextStyle(fontSize: 60)),
                ),
              ),
              if (isOnline)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Online',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          rating.toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          '($reviews)',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(
                      city,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  languages,
                  style: const TextStyle(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$price SAR',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '/$unit',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Заказать',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Карточка трансфера для маркетплейса
  Widget _buildTransferMarketCard({
    required String route,
    required String duration,
    required String price,
    required String vehicle,
    required int seats,
    required double rating,
  }) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(vehicle, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        route,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(duration, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.people, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('$seats мест', style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$price SAR',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B5E20),
                            fontSize: 18,
                          ),
                        ),
                        const Text(
                          'за поездку',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Заказать'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Карточка экскурсии для маркетплейса
  Widget _buildExcursionMarketCard({
    required String title,
    required String duration,
    required String price,
    required String groupSize,
    required double rating,
    required String imageIcon,
  }) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(imageIcon, style: const TextStyle(fontSize: 50)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(
                      duration,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.people, size: 12, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(
                      groupSize,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(
                      rating.toString(),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$price SAR',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                        fontSize: 16,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Заказать'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ========== ГЛАВНЫЙ ЭКРАН ==========
// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Umra Guide'),
//         backgroundColor: const Color(0xFF1B5E20),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications_none),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Верхний баннер на всю ширину
//             Container(
//               width: double.infinity, // На всю ширину
//               height: 200,
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                   image: NetworkImage(
//                     'https://avatars.mds.yandex.net/i?id=5c98533cde9ed276fb19e3397288d3fc_l-5220668-images-thumbs&n=13',
//                   ),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.black.withOpacity(0.3),
//                       Colors.black.withOpacity(0.7),
//                     ],
//                   ),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(20.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Умра и Путешествия',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Мекка • Медина • Джидда',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // Поисковая строка
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: const TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Поиск экскурсий, отелей, трансферов...',
//                     prefixIcon: Icon(Icons.search, color: Color(0xFF1B5E20)),
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.all(16),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Быстрые категории
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Text(
//                 'Быстрый доступ',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1B5E20),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 children: [
//                   _buildQuickCard(
//                     Icons.mosque,
//                     'Времена\nнамазов',
//                     Colors.green,
//                   ),
//                   _buildQuickCard(
//                     Icons.compass_calibration,
//                     'Кибла\nнаправление',
//                     Colors.amber,
//                   ),
//                   _buildQuickCard(
//                     Icons.calendar_today,
//                     'Лучшие дни\nдля Умры',
//                     Colors.orange,
//                   ),
//                   _buildQuickCard(
//                     Icons.star,
//                     'Отзывы\nпаломников',
//                     Colors.blue,
//                   ),
//                   _buildQuickCard(
//                     Icons.local_hotel,
//                     'Отели\nрядом',
//                     Colors.purple,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),

//             // Популярные экскурсии
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Популярные экскурсии',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'Смотреть все',
//                     style: TextStyle(
//                       color: Color(0xFF1B5E20),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 children: [
//                   _buildExcursionCard(
//                     'Ночная экскурсия в Мекке',
//                     'Джабаль ан-Нур, пещера Хира',
//                     'от 150 SAR',
//                     '4.9',
//                   ),
//                   _buildExcursionCard(
//                     'Медина - Город Пророка',
//                     'Масджид ан-Набави',
//                     'от 120 SAR',
//                     '5.0',
//                   ),
//                   _buildExcursionCard(
//                     'Джидда историческая',
//                     'Аль-Балад, мечеть Аль-Шафи',
//                     'от 100 SAR',
//                     '4.8',
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//           // Ближайшие гиды - добавьте после блока "Популярные экскурсии"
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Наши гиды',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     'Смотреть всех',
//                     style: TextStyle(
//                       color: Color(0xFF1B5E20),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 children: [
//                   _buildGuideCard(
//                     'Шейх Ахмад',
//                     'Мекка',
//                     'Гид-богослов',
//                     '5.0',
//                     'Арабский, Русский',
//                   ),
//                   _buildGuideCard(
//                     'Абдуллах',
//                     'Медина',
//                     'Историк Ислама',
//                     '4.9',
//                     'Арабский, Английский',
//                   ),
//                   _buildGuideCard(
//                     'Мухаммад',
//                     'Джидда',
//                     'Гид-переводчик',
//                     '4.8',
//                     'Русский, Арабский',
//                   ),
//                   _buildGuideCard(
//                     'Омар',
//                     'Мекка',
//                     'Эксперт по Умре',
//                     '5.0',
//                     'Русский, Урду',
//                   ),
//                   _buildGuideCard(
//                     'Хадиджа',
//                     'Медина',
//                     'Женский гид',
//                     '4.9',
//                     'Русский, Арабский',
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//             // Советы для паломников
//             Container(
//               margin: const EdgeInsets.all(16),
//               padding: const EdgeInsets.all(20),
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Row(
//                     children: [
//                       Icon(Icons.lightbulb, color: Colors.white, size: 28),
//                       SizedBox(width: 10),
//                       Text(
//                         'Советы для Умры',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     '• Пейте больше воды, особенно в жару\n'
//                     '• Надевайте удобную обувь для тавафа\n'
//                     '• Держите при себе карту местности\n'
//                     '• Скачайте приложение для намазов\n'
//                     '• Носите с собой легкий рюкзак',
//                     style: TextStyle(color: Colors.white70, height: 1.5),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickCard(IconData icon, String title, Color color) {
//     return Container(
//       width: 100,
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, size: 32, color: color),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildExcursionCard(
//     String title,
//     String location,
//     String price,
//     String rating,
//   ) {
//     return Container(
//       width: 240,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(15),
//               topRight: Radius.circular(15),
//             ),
//             child: Image.network(
//               'https://avatars.mds.yandex.net/i?id=5c98533cde9ed276fb19e3397288d3fc_l-5220668-images-thumbs&n=13',
//               height: 130,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 12, color: Colors.grey),
//                     const SizedBox(width: 2),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: const TextStyle(
//                           fontSize: 11,
//                           color: Colors.grey,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       price,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1B5E20),
//                         fontSize: 14,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         const Icon(Icons.star, size: 14, color: Colors.amber),
//                         const SizedBox(width: 2),
//                         Text(rating, style: const TextStyle(fontSize: 12)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildGuideCard(
//     String name,
//     String city,
//     String role,
//     String rating,
//     String languages,
//   ) {
//     return Container(
//       width: 180,
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const CircleAvatar(
//             radius: 35,
//             backgroundColor: Color(0xFF1B5E20),
//             child: Icon(Icons.person, size: 35, color: Colors.white),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             name,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           const SizedBox(height: 2),
//           Text(city, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//           const SizedBox(height: 2),
//           Text(
//             role,
//             style: const TextStyle(fontSize: 11, color: Color(0xFF1B5E20)),
//           ),
//           const SizedBox(height: 2),
//           Text(languages, style: const TextStyle(fontSize: 10)),
//           const SizedBox(height: 4),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.star, size: 14, color: Colors.amber),
//               const SizedBox(width: 2),
//               Text(
//                 rating,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1B5E20),
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: const Text('Связаться', style: TextStyle(fontSize: 12)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ========== ВРЕМЕНА НАМАЗОВ ==========
class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  String _selectedCity = 'Мекка';
  late Map<String, Map<String, String>> _prayerTimes;

  @override
  void initState() {
    super.initState();
    _initPrayerTimes();
  }

  void _initPrayerTimes() {
    _prayerTimes = {
      'Мекка': {
        'Фаджр': '04:30',
        'Восход': '05:55',
        'Зухр': '12:20',
        'Аср': '15:45',
        'Магриб': '18:30',
        'Иша': '20:00',
      },
      'Медина': {
        'Фаджр': '04:35',
        'Восход': '06:00',
        'Зухр': '12:25',
        'Аср': '15:50',
        'Магриб': '18:35',
        'Иша': '20:05',
      },
      'Джидда': {
        'Фаджр': '04:32',
        'Восход': '05:57',
        'Зухр': '12:22',
        'Аср': '15:47',
        'Магриб': '18:32',
        'Иша': '20:02',
      },
    };
  }

  String _getCurrentPrayer() {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final currentTime = currentHour * 60 + currentMinute;

    final times = _prayerTimes[_selectedCity]!;
    final fajr = _timeToMinutes(times['Фаджр']!);
    final dhuhr = _timeToMinutes(times['Зухр']!);
    final asr = _timeToMinutes(times['Аср']!);
    final maghrib = _timeToMinutes(times['Магриб']!);
    final isha = _timeToMinutes(times['Иша']!);

    if (currentTime < fajr) return 'Фаджр';
    if (currentTime < dhuhr) return 'Зухр';
    if (currentTime < asr) return 'Аср';
    if (currentTime < maghrib) return 'Магриб';
    if (currentTime < isha) return 'Иша';
    return 'Фаджр (следующий)';
  }

  int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Времена намазов'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Выбор города
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Выберите город',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCityButton('Мекка'),
                      const SizedBox(width: 10),
                      _buildCityButton('Медина'),
                      const SizedBox(width: 10),
                      _buildCityButton('Джидда'),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Текущий намаз
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    'Следующий намаз',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getCurrentPrayer(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _selectedCity,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Таблица намазов
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Расписание на сегодня',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildPrayerRow(
                    'Фаджр',
                    _prayerTimes[_selectedCity]!['Фаджр']!,
                  ),
                  _buildDivider(),
                  _buildPrayerRow(
                    'Восход',
                    _prayerTimes[_selectedCity]!['Восход']!,
                  ),
                  _buildDivider(),
                  _buildPrayerRow(
                    'Зухр',
                    _prayerTimes[_selectedCity]!['Зухр']!,
                  ),
                  _buildDivider(),
                  _buildPrayerRow('Аср', _prayerTimes[_selectedCity]!['Аср']!),
                  _buildDivider(),
                  _buildPrayerRow(
                    'Магриб',
                    _prayerTimes[_selectedCity]!['Магриб']!,
                  ),
                  _buildDivider(),
                  _buildPrayerRow('Иша', _prayerTimes[_selectedCity]!['Иша']!),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCityButton(String city) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCity = city;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedCity == city
            ? const Color(0xFF1B5E20)
            : Colors.grey[300],
        foregroundColor: _selectedCity == city ? Colors.white : Colors.black,
      ),
      child: Text(city),
    );
  }

  Widget _buildPrayerRow(String name, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1B5E20),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }
}

// ========== КИБЛА (НАПРАВЛЕНИЕ) ==========
class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Направление Киблы'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Компас
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1B5E20), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 80,
                        color: Color(0xFF1B5E20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '⬆️ НАПРАВЛЕНИЕ НА КААБУ ⬆️',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Информация
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Как определить Киблу?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTipCard(
                      '1. Используйте компас',
                      'Поверните телефон так, чтобы стрелка указывала на север, затем следуйте направлению на карте',
                    ),
                    _buildTipCard(
                      '2. Приложения-компасы',
                      'Используйте специальные приложения для определения Киблы с дополненной реальностью',
                    ),
                    _buildTipCard(
                      '3. Ориентиры',
                      'В Мекке и Медине есть указатели направления в отелях и мечетях',
                    ),
                    _buildTipCard(
                      '4. Положение солнца',
                      'В Саудовской Аравии Кааба находится на юго-востоке от большинства стран СНГ',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Примечание
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.amber),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Для точного определения Киблы используйте GPS и компас на вашем устройстве',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF1B5E20), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ========== ЛУЧШИЕ ДНИ ДЛЯ УМРЫ ==========
class BestDaysScreen extends StatelessWidget {
  const BestDaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лучшие дни для Умры'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildBestDayCard(
              '📅 Месяц Рамадан',
              'Особое благословение',
              'Умра в Рамадане приравнивается к Хаджу по вознаграждению',
              '⭐ Особое значение',
            ),
            _buildBestDayCard(
              '🕋 Пятница (Джума)',
              'Лучший день недели',
              'В пятницу особенно благословенны любые благие дела',
              '📆 Каждую пятницу',
            ),
            _buildBestDayCard(
              '🌙 15 Ша\'бана',
              'Ночь Бараат',
              'Ночь прощения и милости Всевышнего',
              '🤲 Ночь поклонения',
            ),
            _buildBestDayCard(
              '📖 Первые 10 дней Зуль-хиджа',
              'Благословенные дни',
              'Лучшие дни в году для поклонения',
              '✨ Высокая награда',
            ),
            _buildBestDayCard(
              '🌙 1 Мухаррам',
              'Начало нового года',
              'День поминания и покаяния',
              '🕌 Желательный пост',
            ),
            _buildBestDayCard(
              '📿 День Ашура',
              '10 Мухаррам',
              'День спасения пророков, желательный пост',
              '🙏 Прощение грехов',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestDayCard(
    String title,
    String subtitle,
    String description,
    String badge,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== ОТЗЫВЫ ПАЛОМНИКОВ ==========
class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отзывы паломников'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Средняя оценка
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Общая оценка',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) =>
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('На основе 1,247 отзывов'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Кнопка добавления отзыва
            ElevatedButton.icon(
              onPressed: () {
                _showAddReviewDialog(context);
              },
              icon: const Icon(Icons.add),
              label: const Text('Оставить отзыв'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Список отзывов
            _buildReviewCard(
              'Айдар, Казань',
              '5.0',
              'Была умра в Рамадан. Организация на высшем уровне! Гиды очень помогли, всё объяснили. Трансферы вовремя, отели чистые. Доволен полностью, иншаАллах приеду ещё.',
              '2 дня назад',
            ),
            _buildReviewCard(
              'Мадина, Москва',
              '5.0',
              'Очень понравилось приложение! Особенно времена намазов и кибла. Всё удобно и понятно. Советую всем паломникам!',
              '5 дней назад',
            ),
            _buildReviewCard(
              'Рашид, Уфа',
              '4.5',
              'Хорошее приложение, но хотелось бы больше информации о трансферах. В остальном всё отлично, спасибо!',
              '1 неделю назад',
            ),
            _buildReviewCard(
              'Гульнара, Алматы',
              '5.0',
              'Удобно, что всё в одном приложении: и намазы, и экскурсии, и отзывы. Спасибо разработчикам за полезное приложение для умры!',
              '2 недели назад',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewCard(
    String name,
    String rating,
    String comment,
    String date,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment, style: const TextStyle(height: 1.4)),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController reviewController = TextEditingController();
    double rating = 5.0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Оставить отзыв'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Ваше имя',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Оценка:'),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              rating = index + 1.0;
                            });
                          },
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reviewController,
                  decoration: const InputDecoration(
                    labelText: 'Ваш отзыв',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                // Здесь будет сохранение отзыва
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Спасибо за отзыв!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
              ),
              child: const Text('Отправить'),
            ),
          ],
        );
      },
    );
  }
}

// ========== ПРОФИЛЬ ==========
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFF1B5E20),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Гость',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Войдите, чтобы сохранять избранное',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Войти', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 15),
            TextButton(onPressed: () {}, child: const Text('Регистрация')),
          ],
        ),
      ),
    );
  }
}

// ========== УМРА ==========
class UmraScreen extends StatelessWidget {
  const UmraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Руководство по Умре'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUmraStepCard(
              '1. Ихром',
              'Вступление в состояние ихрама',
              'Примите намерение совершить Умру, наденьте ихрам (для мужчин) и произнесите тальбию',
              Icons.check_circle,
            ),
            _buildUmraStepCard(
              '2. Таваф',
              '7 кругов вокруг Каабы',
              'Начните с черного камня, совершите 7 кругов против часовой стрелки с дуа',
              Icons.navigation,
            ),
            _buildUmraStepCard(
              '3. Намаз за макамом Ибрахима',
              '2 ракаата',
              'Совершите 2 ракаата намаза за местом Ибрахима (если возможно)',
              Icons.mosque,
            ),
            _buildUmraStepCard(
              '4. Сафа и Марва',
              '7 кругов между холмами',
              'Начните с холма Сафа, завершите на Марве, 7 кругов с дуа',
              Icons.directions_walk,
            ),
            _buildUmraStepCard(
              '5. Тахлиль',
              'Сбривание волос',
              'Мужчины сбривают или укорачивают волосы, женщины укорачивают на кончик пальца',
              Icons.content_cut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUmraStepCard(
    String title,
    String subtitle,
    String description,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF1B5E20),
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description, style: const TextStyle(height: 1.4)),
          ],
        ),
      ),
    );
  }
}
