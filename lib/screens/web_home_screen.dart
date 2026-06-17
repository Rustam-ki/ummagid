import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../services/settings_service.dart';
import '../models/guide.dart';
import 'guide_detail_screen.dart';
import 'package:flutter_cors_image/flutter_cors_image.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  List<Guide> _guides = [];
  Map<String, dynamic> _settings = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final settings = await SettingsService.getSettings();
      final guides = await ApiService.getGuides();

      if (settings['hero_image'] != null && settings['hero_image'].isNotEmpty) {
        String path = settings['hero_image'].toString();

        if (!path.startsWith('http://') && !path.startsWith('https://')) {
          path = path.replaceFirst(RegExp(r'^/'), '');
          settings['hero_image'] = 'http://webmarq7.beget.tech/storage/$path';
        } else {
          settings['hero_image'] = path.replaceFirst('http://', 'http://');
        }

        print('Hero image URL: ${settings['hero_image']}');
      }

      setState(() {
        _settings = settings;
        _guides = guides;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  // Вспомогательные методы для адаптивности
  bool _isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;
  bool _isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;
  bool _isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  // Дополнительные проверки для маленьких экранов
  double _getScreenWidth() => MediaQuery.of(context).size.width;
  bool _isUltraSmall() => _getScreenWidth() <= 320;
  bool _isVerySmall() => _getScreenWidth() < 375;

  // Адаптивные отступы
  EdgeInsets _adaptivePadding({
    double base = 40,
    double mobile = 16,
    double verySmall = 12,
    double ultraSmall = 10,
  }) {
    if (_isUltraSmall())
      return EdgeInsets.symmetric(
        horizontal: ultraSmall,
        vertical: ultraSmall * 3,
      );
    if (_isVerySmall())
      return EdgeInsets.symmetric(
        horizontal: verySmall,
        vertical: verySmall * 3,
      );
    if (_isMobile(context))
      return EdgeInsets.symmetric(horizontal: mobile, vertical: mobile * 2.5);
    return EdgeInsets.symmetric(horizontal: base, vertical: base * 1.5);
  }

  // Адаптивные размеры шрифтов
  double _adaptiveFontSize({
    double base = 32,
    double mobile = 24,
    double verySmall = 20,
    double ultraSmall = 18,
  }) {
    if (_isUltraSmall()) return ultraSmall;
    if (_isVerySmall()) return verySmall;
    if (_isMobile(context)) return mobile;
    return base;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      _buildHeroSection(context),
                      _buildAdvantagesSection(context),
                      _buildGuidesSection(context),
                      _buildHelpSection(context),
                      _buildHotelsSection(context),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== АДАПТИВНАЯ ШАПКА ==========
  Widget _buildHeader(BuildContext context) {
    final isMobile = _isMobile(context);
    final isUltraSmall = _isUltraSmall();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isUltraSmall ? 8 : (isMobile ? 16 : 40),
        vertical: isUltraSmall ? 8 : (isMobile ? 12 : 16),
      ),
      child: isMobile ? _buildMobileHeader() : _buildDesktopHeader(),
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(),
        Row(
          children: [
            _navItem('Главная'),
            const SizedBox(width: 24),
            _navItem('Гиды'),
            const SizedBox(width: 24),
            _navItem('Отели'),
            const SizedBox(width: 24),
            _navItem('Умра'),
            const SizedBox(width: 24),
            _navItem('Контакты'),
          ],
        ),
        _buildLoginButton(),
      ],
    );
  }

  Widget _buildMobileHeader() {
    final isUltraSmall = _isUltraSmall();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLogo(isSmall: isUltraSmall),
        Row(
          children: [
            _buildLoginButton(isSmall: isUltraSmall),
            SizedBox(width: isUltraSmall ? 4 : 8),
            IconButton(
              icon: Icon(
                Icons.menu,
                color: const Color(0xFF1B5E20),
                size: isUltraSmall ? 20 : 24,
              ),
              onPressed: () => _showMobileMenu(context),
              padding: isUltraSmall ? EdgeInsets.zero : null,
              constraints: isUltraSmall
                  ? const BoxConstraints(minWidth: 32, minHeight: 32)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLogo({bool isSmall = false}) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isSmall ? 30 : 40,
            height: isSmall ? 30 : 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(isSmall ? 8 : 10),
            ),
            child: Center(
              child: Text('🕋', style: TextStyle(fontSize: isSmall ? 16 : 20)),
            ),
          ),
          SizedBox(width: isSmall ? 8 : 12),
          Text(
            'Muslim Guide',
            style: TextStyle(
              fontSize: isSmall ? 16 : 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return InkWell(
      onTap: () {},
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildLoginButton({bool isSmall = false}) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF1B5E20)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 12 : 20,
          vertical: isSmall ? 6 : 10,
        ),
        minimumSize: isSmall ? const Size(0, 30) : null,
      ),
      child: Text(
        'Войти',
        style: TextStyle(
          color: const Color(0xFF1B5E20),
          fontSize: isSmall ? 12 : 14,
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _mobileMenuItem('Главная', Icons.home),
              _mobileMenuItem('Гиды', Icons.person),
              _mobileMenuItem('Отели', Icons.hotel),
              _mobileMenuItem('Умра', Icons.mosque),
              _mobileMenuItem('Контакты', Icons.contact_mail),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _mobileMenuItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1B5E20)),
      title: Text(title),
      onTap: () => Navigator.pop(context),
    );
  }

  // ========== АДАПТИВНАЯ HERO СЕКЦИЯ ==========
  Widget _buildHeroSection(BuildContext context) {
    final isMobile = _isMobile(context);
    final isUltraSmall = _isUltraSmall();
    final isVerySmall = _isVerySmall();

    final heroImage = _settings['hero_image'];
    final heroTitle =
        _settings['hero_title'] ?? 'Умра и Путешествия\nв Саудовскую Аравию';
    final heroSubtitle =
        _settings['hero_subtitle'] ??
        'Проверенные гиды, удобные трансферы, лучшие отели';

    final height = isUltraSmall
        ? 300.0
        : (isVerySmall ? 350.0 : (isMobile ? 400.0 : 500.0));
    final titleSize = isUltraSmall
        ? 20.0
        : (isVerySmall ? 24.0 : (isMobile ? 28.0 : 48.0));
    final subtitleSize = isUltraSmall
        ? 11.0
        : (isVerySmall ? 12.0 : (isMobile ? 14.0 : 18.0));

    return Container(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          if (heroImage != null && heroImage.isNotEmpty)
            CustomNetworkImage(
              url: heroImage,
              width: double.infinity,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: height,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            )
          else
            Container(
              height: height,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          Container(
            height: height,
            width: double.infinity,
            color: Colors.black.withOpacity(0.4),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isUltraSmall
                    ? 12
                    : (isVerySmall ? 16 : (isMobile ? 20 : 40)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    heroTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: isUltraSmall ? 1.2 : null,
                    ),
                  ),
                  SizedBox(height: isUltraSmall ? 8 : (isMobile ? 12 : 16)),
                  Text(
                    heroSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: isUltraSmall ? 16 : (isMobile ? 24 : 32)),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1B5E20),
                      padding: EdgeInsets.symmetric(
                        horizontal: isUltraSmall ? 16 : (isMobile ? 24 : 32),
                        vertical: isUltraSmall ? 8 : (isMobile ? 12 : 16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      'Найти гида',
                      style: TextStyle(
                        fontSize: isUltraSmall ? 12 : (isMobile ? 16 : 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== АДАПТИВНЫЙ БЛОК ПРЕИМУЩЕСТВ ==========
  Widget _buildAdvantagesSection(BuildContext context) {
    final sectionPadding = _adaptivePadding();

    return Container(
      padding: sectionPadding,
      child: Column(
        children: [
          Text(
            'Почему выбирают нас',
            style: TextStyle(
              fontSize: _adaptiveFontSize(),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B5E20),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Мы делаем ваше путешествие комфортным и безопасным',
            style: TextStyle(
              fontSize: _isUltraSmall()
                  ? 11
                  : (_isVerySmall() ? 12 : (_isMobile(context) ? 14 : 16)),
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (_isMobile(context)) {
                return Column(
                  children: [
                    _buildAdvantageCard(
                      icon: Icons.verified_user,
                      title: 'Проверенные гиды',
                      description:
                          'Все гиды проходят верификацию и имеют необходимые лицензии',
                      color: const Color(0xFF1B5E20),
                    ),
                    SizedBox(height: _isUltraSmall() ? 8 : 16),
                    _buildAdvantageCard(
                      icon: Icons.support_agent,
                      title: 'Поддержка 24/7',
                      description:
                          'Наша команда всегда на связи, чтобы помочь в любой ситуации',
                      color: const Color(0xFF2E7D32),
                    ),
                    SizedBox(height: _isUltraSmall() ? 8 : 16),
                    _buildAdvantageCard(
                      icon: Icons.language,
                      title: 'Русскоязычный сервис',
                      description:
                          'Полное сопровождение на русском языке без языкового барьера',
                      color: const Color(0xFF388E3C),
                    ),
                    SizedBox(height: _isUltraSmall() ? 8 : 16),
                    _buildAdvantageCard(
                      icon: Icons.shield,
                      title: 'Безопасная оплата',
                      description:
                          'Защищённые платежи через проверенные платёжные системы',
                      color: const Color(0xFF43A047),
                    ),
                  ],
                );
              } else if (_isTablet(context)) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildAdvantageCard(
                            icon: Icons.verified_user,
                            title: 'Проверенные гиды',
                            description: 'Все гиды проходят верификацию',
                            color: const Color(0xFF1B5E20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAdvantageCard(
                            icon: Icons.support_agent,
                            title: 'Поддержка 24/7',
                            description: 'Помощь в любой ситуации',
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAdvantageCard(
                            icon: Icons.language,
                            title: 'Русскоязычный сервис',
                            description: 'Без языкового барьера',
                            color: const Color(0xFF388E3C),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAdvantageCard(
                            icon: Icons.shield,
                            title: 'Безопасная оплата',
                            description: 'Проверенные платёжные системы',
                            color: const Color(0xFF43A047),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: _buildAdvantageCard(
                        icon: Icons.verified_user,
                        title: 'Проверенные гиды',
                        description:
                            'Все гиды проходят верификацию и имеют необходимые лицензии',
                        color: const Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildAdvantageCard(
                        icon: Icons.support_agent,
                        title: 'Поддержка 24/7',
                        description:
                            'Наша команда всегда на связи, чтобы помочь в любой ситуации',
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildAdvantageCard(
                        icon: Icons.language,
                        title: 'Русскоязычный сервис',
                        description:
                            'Полное сопровождение на русском языке без языкового барьера',
                        color: const Color(0xFF388E3C),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _buildAdvantageCard(
                        icon: Icons.shield,
                        title: 'Безопасная оплата',
                        description:
                            'Защищённые платежи через проверенные платёжные системы',
                        color: const Color(0xFF43A047),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (_isMobile(context)) {
                return Column(
                  children: [
                    _buildStatsBlock(isMobile: true),
                    SizedBox(height: _isUltraSmall() ? 12 : 20),
                    _buildMissionBlock(isMobile: true),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(flex: 2, child: _buildStatsBlock()),
                    const SizedBox(width: 24),
                    Expanded(child: _buildMissionBlock()),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvantageCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final isUltraSmall = _isUltraSmall();

    return Container(
      padding: EdgeInsets.all(isUltraSmall ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isUltraSmall ? 15 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isUltraSmall ? 8 : 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(isUltraSmall ? 8 : 12),
            ),
            child: Icon(icon, size: isUltraSmall ? 24 : 32, color: color),
          ),
          SizedBox(height: isUltraSmall ? 10 : 16),
          Text(
            title,
            style: TextStyle(
              fontSize: isUltraSmall ? 14 : 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B5E20),
            ),
          ),
          SizedBox(height: isUltraSmall ? 4 : 8),
          Text(
            description,
            style: TextStyle(
              fontSize: isUltraSmall ? 11 : 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBlock({bool isMobile = false}) {
    final isUltraSmall = _isUltraSmall();

    return Container(
      padding: EdgeInsets.all(isUltraSmall ? 16 : 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1B5E20).withOpacity(0.05),
            const Color(0xFF2E7D32).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(isUltraSmall ? 15 : 20),
        border: Border.all(color: const Color(0xFF1B5E20).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 Статистика',
            style: TextStyle(
              fontSize: isUltraSmall ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B5E20),
            ),
          ),
          SizedBox(height: isUltraSmall ? 12 : 16),
          isMobile
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          number: '500+',
                          label: 'Паломников',
                          isSmall: isUltraSmall,
                        ),
                        _StatItem(
                          number: '50+',
                          label: 'Гидов',
                          isSmall: isUltraSmall,
                        ),
                      ],
                    ),
                    SizedBox(height: isUltraSmall ? 8 : 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(
                          number: '4.8',
                          label: 'Оценка',
                          isSmall: isUltraSmall,
                        ),
                        _StatItem(
                          number: '3',
                          label: 'Года',
                          isSmall: isUltraSmall,
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _StatItem(number: '500+', label: 'Довольных паломников'),
                    _StatItem(number: '50+', label: 'Проверенных гидов'),
                    _StatItem(number: '4.8', label: 'Средняя оценка'),
                    _StatItem(number: '3', label: 'Года работы'),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildMissionBlock({bool isMobile = false}) {
    final isUltraSmall = _isUltraSmall();

    return Container(
      padding: EdgeInsets.all(isUltraSmall ? 16 : 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isUltraSmall ? 15 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 Наша миссия',
            style: TextStyle(
              fontSize: isUltraSmall ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B5E20),
            ),
          ),
          SizedBox(height: isUltraSmall ? 12 : 16),
          Text(
            'Сделать Умру доступной для каждого мусульманина, '
            'предоставляя качественный сервис по организации '
            'путешествия к святым местам.',
            style: TextStyle(
              fontSize: isUltraSmall ? 12 : 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ========== АДАПТИВНАЯ СЕКЦИЯ ГИДОВ ==========
  Widget _buildGuidesSection(BuildContext context) {
    final isMobile = _isMobile(context);
    final sectionPadding = _adaptivePadding();

    return Container(
      padding: sectionPadding,
      child: Column(
        children: [
          Text(
            'Наши гиды',
            style: TextStyle(
              fontSize: _adaptiveFontSize(),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B5E20),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Лицензированные русскоязычные гиды в Мекке и Медине',
            style: TextStyle(
              fontSize: _isUltraSmall() ? 11 : (_isMobile(context) ? 14 : 16),
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          if (_guides.isEmpty)
            const Center(child: Text('Гиды не найдены'))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : (_isTablet(context) ? 2 : 4),
                childAspectRatio: isMobile ? 0.85 : 0.8,
                crossAxisSpacing: _isUltraSmall() ? 10 : (isMobile ? 16 : 24),
                mainAxisSpacing: _isUltraSmall() ? 10 : (isMobile ? 16 : 24),
              ),
              itemCount: _guides.length,
              itemBuilder: (context, index) {
                final guide = _guides[index];
                return _buildGuideCard(guide, isMobile);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(Guide guide, bool isMobile) {
    final isUltraSmall = _isUltraSmall();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isUltraSmall ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isUltraSmall ? 12 : 16),
              topRight: Radius.circular(isUltraSmall ? 12 : 16),
            ),
            child: guide.photoUrl != null && guide.photoUrl!.isNotEmpty
                ? CustomNetworkImage(
                    url: guide.photoUrl!,
                    height: isUltraSmall ? 220 : (isMobile ? 200 : 180),
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: isUltraSmall ? 220 : (isMobile ? 200 : 180),
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: isUltraSmall ? 40 : 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    height: isUltraSmall ? 180 : (isMobile ? 200 : 180),
                    color: Colors.grey[200],
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: isUltraSmall ? 40 : 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(isUltraSmall ? 10 : (isMobile ? 16 : 12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guide.name,
                  style: TextStyle(
                    fontSize: isUltraSmall ? 14 : (isMobile ? 18 : 16),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: isUltraSmall ? 2 : 4),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: isUltraSmall ? 12 : 14,
                      color: Colors.amber,
                    ),
                    SizedBox(width: isUltraSmall ? 2 : 4),
                    Text(
                      guide.rating.toString(),
                      style: TextStyle(fontSize: isUltraSmall ? 11 : 12),
                    ),
                    SizedBox(width: isUltraSmall ? 4 : 8),
                    Text(
                      '(${guide.reviewsCount})',
                      style: TextStyle(
                        fontSize: isUltraSmall ? 10 : 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isUltraSmall ? 2 : 4),
                Text(
                  guide.cityName,
                  style: TextStyle(
                    fontSize: isUltraSmall ? 10 : 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: isUltraSmall ? 6 : 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${guide.pricePerDay.toInt()} SAR',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1B5E20),
                        fontSize: isUltraSmall ? 13 : 16,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GuideDetailScreen(guide: guide),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isUltraSmall ? 10 : (isMobile ? 16 : 12),
                          vertical: isUltraSmall ? 4 : (isMobile ? 8 : 6),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: isUltraSmall ? const Size(0, 28) : null,
                      ),
                      child: Text(
                        'Подробнее',
                        style: TextStyle(
                          fontSize: isUltraSmall ? 10 : (isMobile ? 14 : 12),
                        ),
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

  // ========== АДАПТИВНЫЙ БЛОК ПОМОЩИ ==========
  Widget _buildHelpSection(BuildContext context) {
    final isMobile = _isMobile(context);
    final isUltraSmall = _isUltraSmall();
    final isVerySmall = _isVerySmall();
    final sectionPadding = _adaptivePadding();

    return Container(
      color: Colors.grey[50],
      padding: sectionPadding,
      child: Column(
        children: [
          Text(
            'Помощь в организации Умры',
            style: TextStyle(
              fontSize: _adaptiveFontSize(),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B5E20),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Комплексная поддержка на всех этапах вашего путешествия',
            style: TextStyle(
              fontSize: isUltraSmall
                  ? 11
                  : (isVerySmall ? 12 : (isMobile ? 14 : 16)),
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                return Column(
                  children: [
                    _buildMotivationBanner(isMobile: true),
                    SizedBox(height: isUltraSmall ? 12 : 20),
                    _buildHelpItem(
                      icon: Icons.airport_shuttle,
                      title: 'Встреча в аэропорту',
                      description: 'Встретим вас с табличкой в аэропорту',
                      price: 'Бесплатно',
                      isCompact: isVerySmall,
                    ),
                    SizedBox(height: isUltraSmall ? 8 : 12),
                    _buildHelpItem(
                      icon: Icons.hotel,
                      title: 'Помощь при заселении',
                      description: 'Поможем с документами и переводом',
                      price: 'от 50 SAR',
                      isCompact: isVerySmall,
                    ),
                    SizedBox(height: isUltraSmall ? 8 : 12),
                    _buildHelpItem(
                      icon: Icons.translate,
                      title: 'Услуги переводчика',
                      description: 'Профессиональный переводчик',
                      price: 'от 100 SAR/час',
                      isCompact: isVerySmall,
                    ),
                    SizedBox(height: isUltraSmall ? 8 : 12),
                    _buildHelpItem(
                      icon: Icons.local_taxi,
                      title: 'Трансферы',
                      description: 'Комфортабельный транспорт',
                      price: 'от 150 SAR',
                      isCompact: isVerySmall,
                    ),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildHelpItem(
                            icon: Icons.airport_shuttle,
                            title: 'Встреча в аэропорту',
                            description:
                                'Встретим вас с табличкой в аэропорту Джидды или Медины, поможем с багажом',
                            price: 'Бесплатно',
                          ),
                          const SizedBox(height: 16),
                          _buildHelpItem(
                            icon: Icons.hotel,
                            title: 'Помощь при заселении',
                            description:
                                'Поможем с документами, переводом на ресепшене и заселением в номер',
                            price: 'от 50 SAR',
                          ),
                          const SizedBox(height: 16),
                          _buildHelpItem(
                            icon: Icons.translate,
                            title: 'Услуги переводчика',
                            description:
                                'Профессиональный переводчик для общения с местными жителями и персоналом',
                            price: 'от 100 SAR/час',
                          ),
                          const SizedBox(height: 16),
                          _buildHelpItem(
                            icon: Icons.local_taxi,
                            title: 'Трансферы',
                            description:
                                'Комфортабельный транспорт между городами и достопримечательностями',
                            price: 'от 150 SAR',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(flex: 2, child: _buildMotivationBanner()),
                  ],
                );
              }
            },
          ),
          SizedBox(height: isUltraSmall ? 30 : 40),
          // Важная информация
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              isUltraSmall ? 10 : (isVerySmall ? 12 : (isMobile ? 16 : 24)),
            ),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(isUltraSmall ? 15 : 20),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: isMobile
                ? Column(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.amber,
                        size: isUltraSmall ? 20 : (isVerySmall ? 24 : 32),
                      ),
                      SizedBox(
                        height: isUltraSmall ? 6 : (isVerySmall ? 8 : 12),
                      ),
                      Text(
                        'Важная информация',
                        style: TextStyle(
                          fontSize: isUltraSmall ? 14 : (isVerySmall ? 16 : 18),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: isUltraSmall ? 4 : (isVerySmall ? 6 : 8),
                      ),
                      Text(
                        'Убедитесь, что у вас есть страховка и медицинская справка!',
                        style: TextStyle(
                          fontSize: isUltraSmall ? 10 : (isVerySmall ? 12 : 14),
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: isUltraSmall ? 8 : (isVerySmall ? 12 : 16),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.phone,
                          size: isUltraSmall ? 14 : (isVerySmall ? 16 : 20),
                        ),
                        label: Text(
                          'Связаться с нами',
                          style: TextStyle(
                            fontSize: isUltraSmall
                                ? 10
                                : (isVerySmall ? 12 : 14),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isUltraSmall
                                ? 12
                                : (isVerySmall ? 16 : 24),
                            vertical: isUltraSmall
                                ? 6
                                : (isVerySmall ? 10 : 16),
                          ),
                          minimumSize: isUltraSmall ? const Size(0, 32) : null,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.warning_amber,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Важная информация',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Убедитесь, что у вас есть страховка и медицинская справка! '
                              'Свяжитесь с нами для получения актуальной информации о требованиях к паломникам.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.phone),
                        label: const Text('Связаться с нами'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationBanner({bool isMobile = false}) {
    final isUltraSmall = _isUltraSmall();
    final isVerySmall = _isVerySmall();

    return Container(
      padding: EdgeInsets.all(
        isUltraSmall ? 12 : (isVerySmall ? 16 : (isMobile ? 20 : 30)),
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isUltraSmall ? 15 : 20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: isUltraSmall
                    ? 16
                    : (isVerySmall ? 20 : (isMobile ? 24 : 28)),
              ),
              SizedBox(width: isUltraSmall ? 6 : 8),
              Expanded(
                child: Text(
                  'Умра может быть дешевле!',
                  style: TextStyle(
                    fontSize: isUltraSmall
                        ? 14
                        : (isVerySmall ? 16 : (isMobile ? 18 : 22)),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isUltraSmall ? 10 : (isVerySmall ? 12 : 20)),
          _buildBenefitItem(
            '✅',
            'Самостоятельная Умра дешевле на 30-50%',
            isCompact: isVerySmall,
          ),
          SizedBox(height: isUltraSmall ? 6 : (isVerySmall ? 8 : 12)),
          _buildBenefitItem(
            '✅',
            'Цена тура: \$2000-3000',
            isCompact: isVerySmall,
          ),
          SizedBox(height: isUltraSmall ? 6 : (isVerySmall ? 8 : 12)),
          _buildBenefitItem(
            '✅',
            'Самостоятельно: \$1000-1500',
            isCompact: isVerySmall,
          ),
          SizedBox(height: isUltraSmall ? 6 : (isVerySmall ? 8 : 12)),
          _buildBenefitItem('✅', 'Отели от \$30/ночь', isCompact: isVerySmall),
          SizedBox(height: isUltraSmall ? 6 : (isVerySmall ? 8 : 12)),
          _buildBenefitItem(
            '✅',
            'Виза: бесплатно (онлайн)',
            isCompact: isVerySmall,
          ),
          SizedBox(height: isUltraSmall ? 12 : (isVerySmall ? 16 : 24)),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showIndependentTipsDialog(context),
              icon: Icon(
                Icons.menu_book,
                color: Colors.white,
                size: isUltraSmall ? 14 : (isVerySmall ? 16 : 20),
              ),
              label: Text(
                'Как организовать Умру?',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isUltraSmall
                      ? 10
                      : (isVerySmall ? 11 : (isMobile ? 12 : 14)),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 2),
                padding: EdgeInsets.symmetric(
                  vertical: isUltraSmall
                      ? 8
                      : (isVerySmall ? 10 : (isMobile ? 12 : 16)),
                  horizontal: isUltraSmall ? 8 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: isUltraSmall ? const Size(0, 28) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
    required String price,
    bool isCompact = false,
  }) {
    final isUltraSmall = _isUltraSmall();
    final reallyCompact = isCompact || isUltraSmall;

    return Container(
      padding: EdgeInsets.all(isUltraSmall ? 10 : (reallyCompact ? 12 : 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isUltraSmall ? 10 : 15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: reallyCompact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isUltraSmall ? 6 : 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B5E20).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          isUltraSmall ? 6 : 10,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: isUltraSmall ? 16 : 20,
                        color: const Color(0xFF1B5E20),
                      ),
                    ),
                    SizedBox(width: isUltraSmall ? 8 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: isUltraSmall ? 12 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: isUltraSmall ? 1 : 2),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: isUltraSmall ? 10 : 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isUltraSmall ? 8 : 10),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isUltraSmall ? 8 : 12,
                        vertical: isUltraSmall ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B5E20).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B5E20),
                          fontSize: isUltraSmall ? 11 : 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: const Color(0xFF1B5E20)),
                ),
                const SizedBox(width: 16),
                Expanded(
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
                      Text(
                        description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    price,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildBenefitItem(String icon, String text, {bool isCompact = false}) {
    final isUltraSmall = _isUltraSmall();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          icon,
          style: TextStyle(fontSize: isUltraSmall ? 11 : (isCompact ? 13 : 16)),
        ),
        SizedBox(width: isUltraSmall ? 4 : 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isUltraSmall ? 10 : (isCompact ? 12 : 14),
              color: Colors.white,
              height: isUltraSmall ? 1.2 : null,
            ),
          ),
        ),
      ],
    );
  }

  // ========== АДАПТИВНЫЙ БЛОК ОТЕЛЕЙ ==========
  Widget _buildHotelsSection(BuildContext context) {
    final isMobile = _isMobile(context);
    final isUltraSmall = _isUltraSmall();
    final sectionPadding = _adaptivePadding();

    return Container(
      color: Colors.grey[50],
      padding: sectionPadding,
      child: Column(
        children: [
          Text(
            'Отели в Мекке и Медине',
            style: TextStyle(
              fontSize: _adaptiveFontSize(),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B5E20),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Лучшие предложения от проверенных партнёров',
            style: TextStyle(
              fontSize: isUltraSmall ? 11 : (isMobile ? 14 : 16),
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isUltraSmall ? 15 : 20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: isUltraSmall ? 120 : (isMobile ? 150 : 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isUltraSmall ? 15 : 20),
                      topRight: Radius.circular(isUltraSmall ? 15 : 20),
                    ),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -30,
                        top: -30,
                        child: Icon(
                          Icons.hotel,
                          size: isUltraSmall ? 80 : (isMobile ? 100 : 150),
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isUltraSmall
                                ? 12
                                : (isMobile ? 20 : 40),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '🏨 Забронируйте отель',
                                style: TextStyle(
                                  fontSize: isUltraSmall
                                      ? 18
                                      : (isMobile ? 24 : 32),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: isUltraSmall ? 6 : 12),
                              Text(
                                'Лучшие цены на отели в Мекке и Медине',
                                style: TextStyle(
                                  fontSize: isUltraSmall
                                      ? 11
                                      : (isMobile ? 14 : 18),
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    isUltraSmall ? 12 : (isMobile ? 20 : 40),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📋 Что вы можете забронировать на Trip.com:',
                        style: TextStyle(
                          fontSize: isUltraSmall ? 14 : (isMobile ? 16 : 20),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B5E20),
                        ),
                      ),
                      SizedBox(height: isUltraSmall ? 16 : 24),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (isMobile) {
                            return Column(
                              children: [
                                _buildHotelFeatureCard(
                                  icon: Icons.mosque,
                                  title: 'Отели рядом с Харамом',
                                  description:
                                      'Размещение в шаговой доступности',
                                ),
                                SizedBox(height: isUltraSmall ? 6 : 12),
                                _buildHotelFeatureCard(
                                  icon: Icons.location_city,
                                  title: 'Гостиницы в Медине',
                                  description: 'Отели возле Мечети Пророка',
                                ),
                                SizedBox(height: isUltraSmall ? 6 : 12),
                                _buildHotelFeatureCard(
                                  icon: Icons.star,
                                  title: 'Любой уровень комфорта',
                                  description: 'От бюджетных 3* до 5*',
                                ),
                                SizedBox(height: isUltraSmall ? 6 : 12),
                                _buildHotelFeatureCard(
                                  icon: Icons.attach_money,
                                  title: 'Цены от \$30/ночь',
                                  description: 'Со скидками и акциями',
                                ),
                                SizedBox(height: isUltraSmall ? 6 : 12),
                                _buildHotelFeatureCard(
                                  icon: Icons.autorenew,
                                  title: 'Бесплатная отмена',
                                  description: 'Гибкие условия бронирования',
                                ),
                                SizedBox(height: isUltraSmall ? 6 : 12),
                                _buildHotelFeatureCard(
                                  icon: Icons.language,
                                  title: 'Русскоязычная поддержка',
                                  description: 'Поддержка 24/7',
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildHotelFeatureCard(
                                        icon: Icons.mosque,
                                        title: 'Отели рядом с Харамом',
                                        description:
                                            'Размещение в шаговой доступности от Заповедной мечети в Мекке',
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildHotelFeatureCard(
                                        icon: Icons.location_city,
                                        title: 'Гостиницы в Медине',
                                        description:
                                            'Отели возле Мечети Пророка (мир ему) для удобного посещения',
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildHotelFeatureCard(
                                        icon: Icons.star,
                                        title: 'Любой уровень комфорта',
                                        description:
                                            'От бюджетных 3* до роскошных 5* отелей на любой вкус и бюджет',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildHotelFeatureCard(
                                        icon: Icons.attach_money,
                                        title: 'Цены от \$30/ночь',
                                        description:
                                            'Доступные варианты размещения со скидками и специальными предложениями',
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildHotelFeatureCard(
                                        icon: Icons.autorenew,
                                        title: 'Бесплатная отмена',
                                        description:
                                            'Гибкие условия бронирования с возможностью отмены во многих отелях',
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildHotelFeatureCard(
                                        icon: Icons.language,
                                        title: 'Русскоязычная поддержка',
                                        description:
                                            'Удобный интерфейс и поддержка на русском языке 24/7',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      SizedBox(height: isUltraSmall ? 20 : 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _bookHotel(
                            'https://www.trip.com/hotels/list?city=Makkah',
                          ),
                          icon: Icon(
                            Icons.hotel,
                            size: isUltraSmall ? 16 : (isMobile ? 20 : 24),
                          ),
                          label: Text(
                            'Забронировать отель на Trip.com',
                            style: TextStyle(
                              fontSize: isUltraSmall
                                  ? 12
                                  : (isMobile ? 14 : 18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: isUltraSmall
                                  ? 12
                                  : (isMobile ? 16 : 20),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: isUltraSmall
                                ? const Size(0, 36)
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(height: isUltraSmall ? 10 : 16),
                      Text(
                        'Trip.com предлагает лучшие цены на отели в Саудовской Аравии '
                        'с русскоязычной поддержкой и удобной системой бронирования.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isUltraSmall ? 10 : (isMobile ? 12 : 14),
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isUltraSmall = _isUltraSmall();

    return Container(
      padding: EdgeInsets.all(isUltraSmall ? 12 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20).withOpacity(0.05),
        borderRadius: BorderRadius.circular(isUltraSmall ? 10 : 15),
        border: Border.all(color: const Color(0xFF1B5E20).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isUltraSmall ? 6 : 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20).withOpacity(0.1),
              borderRadius: BorderRadius.circular(isUltraSmall ? 6 : 10),
            ),
            child: Icon(
              icon,
              size: isUltraSmall ? 20 : 28,
              color: const Color(0xFF1B5E20),
            ),
          ),
          SizedBox(width: isUltraSmall ? 10 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isUltraSmall ? 13 : 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B5E20),
                  ),
                ),
                SizedBox(height: isUltraSmall ? 4 : 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isUltraSmall ? 11 : 14,
                    color: Colors.grey[700],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _bookHotel(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось открыть ссылку')),
        );
      }
    }
  }

  // ========== АДАПТИВНЫЙ ФУТЕР ==========
  Widget _buildFooter(BuildContext context) {
    final isMobile = _isMobile(context);
    final isUltraSmall = _isUltraSmall();

    return Container(
      color: const Color(0xFF1B5E20),
      padding: EdgeInsets.symmetric(
        horizontal: isUltraSmall ? 10 : (isMobile ? 16 : 40),
        vertical: isUltraSmall ? 24 : (isMobile ? 32 : 48),
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFooterBrand(),
                    SizedBox(height: isUltraSmall ? 16 : 24),
                    _buildFooterLinks(
                      title: 'Услуги',
                      links: ['Гиды', 'Трансферы', 'Отели', 'Экскурсии'],
                    ),
                    SizedBox(height: isUltraSmall ? 16 : 24),
                    _buildFooterLinks(
                      title: 'О нас',
                      links: [
                        'Контакты',
                        'Политика конфиденциальности',
                        'Пользовательское соглашение',
                      ],
                    ),
                    SizedBox(height: isUltraSmall ? 16 : 24),
                    _buildFooterContacts(),
                  ],
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildFooterBrand()),
                    Expanded(
                      child: _buildFooterLinks(
                        title: 'Услуги',
                        links: ['Гиды', 'Трансферы', 'Отели', 'Экскурсии'],
                      ),
                    ),
                    Expanded(
                      child: _buildFooterLinks(
                        title: 'О нас',
                        links: [
                          'Контакты',
                          'Политика конфиденциальности',
                          'Пользовательское соглашение',
                        ],
                      ),
                    ),
                    Expanded(child: _buildFooterContacts()),
                  ],
                );
              }
            },
          ),
          SizedBox(height: isUltraSmall ? 24 : 32),
          const Divider(color: Colors.white24),
          SizedBox(height: isUltraSmall ? 16 : 24),
          Text(
            '© 2025 Muslim Guide. Все права защищены.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: isUltraSmall ? 10 : 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterBrand() {
    final isUltraSmall = _isUltraSmall();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Muslim Guide',
          style: TextStyle(
            fontSize: isUltraSmall ? 16 : 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isUltraSmall ? 4 : 8),
        Text(
          'Помогаем организовать умру и\nпутешествия в Саудовскую Аравию',
          style: TextStyle(
            color: Colors.white70,
            fontSize: isUltraSmall ? 10 : 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFooterLinks({
    required String title,
    required List<String> links,
  }) {
    final isUltraSmall = _isUltraSmall();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isUltraSmall ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isUltraSmall ? 4 : 8),
        ...links.map((link) => _footerLink(link)),
      ],
    );
  }

  Widget _buildFooterContacts() {
    final isUltraSmall = _isUltraSmall();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Контакты',
          style: TextStyle(
            fontSize: isUltraSmall ? 14 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isUltraSmall ? 4 : 8),
        Text(
          '📧 info@muslimguide.com',
          style: TextStyle(
            color: Colors.white70,
            fontSize: isUltraSmall ? 10 : 12,
          ),
        ),
        SizedBox(height: isUltraSmall ? 2 : 4),
        Text(
          '📞 +7 (999) 123-45-67',
          style: TextStyle(
            color: Colors.white70,
            fontSize: isUltraSmall ? 10 : 12,
          ),
        ),
        SizedBox(height: isUltraSmall ? 10 : 16),
        Row(
          children: [
            _socialIcon(Icons.telegram),
            SizedBox(width: isUltraSmall ? 6 : 12),
            _socialIcon(Icons.message),
            SizedBox(width: isUltraSmall ? 6 : 12),
            _socialIcon(Icons.camera_alt),
          ],
        ),
      ],
    );
  }

  Widget _footerLink(String title) {
    final isUltraSmall = _isUltraSmall();

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(bottom: 4),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: isUltraSmall ? 10 : 12,
          ),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    final isUltraSmall = _isUltraSmall();

    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(isUltraSmall ? 6 : 8),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(isUltraSmall ? 6 : 8),
        ),
        child: Icon(icon, size: isUltraSmall ? 16 : 20, color: Colors.white),
      ),
    );
  }

  void _showIndependentTipsDialog(BuildContext context) {
    final isMobile = _isMobile(context);
    final isUltraSmall = _isUltraSmall();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 600,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(isUltraSmall ? 12 : 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book,
                        color: const Color(0xFF1B5E20),
                        size: isUltraSmall ? 20 : 24,
                      ),
                      SizedBox(width: isUltraSmall ? 6 : 12),
                      Expanded(
                        child: Text(
                          '🕋 Как организовать Умру?',
                          style: TextStyle(
                            fontSize: isUltraSmall ? 14 : (isMobile ? 16 : 20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: isUltraSmall ? 18 : 24),
                        onPressed: () => Navigator.pop(context),
                        padding: isUltraSmall ? EdgeInsets.zero : null,
                        constraints: isUltraSmall
                            ? const BoxConstraints(minWidth: 32, minHeight: 32)
                            : null,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isUltraSmall ? 12 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTipSection(
                          '✈️ 1. Авиабилеты',
                          '• Авиакомпании: Saudia, FlyNas, Air Arabia\n'
                              '• Лучшие цены: за 2-3 месяца\n'
                              '• Средняя цена: \$400-700\n'
                              '• Стыковки: Дубай, Доха, Стамбул',
                        ),
                        _buildTipSection(
                          '🏨 2. Отели',
                          '• Booking.com, Agoda, Expedia\n'
                              '• Мекка: от \$30/ночь\n'
                              '• Медина: от \$25/ночь\n'
                              '• Рядом с Харамом',
                        ),
                        _buildTipSection(
                          '📄 3. Виза',
                          '• Виза для Умры - БЕСПЛАТНО!\n'
                              '• Оформление онлайн\n'
                              '• Нужен: загранпаспорт, фото\n'
                              '• Время: 5-15 минут',
                        ),
                        _buildTipSection(
                          '🚐 4. Трансферы',
                          '• Такси: Uber, Careem\n'
                              '• Поезд Haramain\n'
                              '• Автобусы SAPTCO',
                        ),
                        _buildTipSection(
                          '💡 5. Советы',
                          '• Местные кафе дешевле\n'
                              '• Вода в супермаркетах\n'
                              '• Приложение Nusuk',
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: EdgeInsets.all(isUltraSmall ? 10 : 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Закрыть',
                          style: TextStyle(fontSize: isUltraSmall ? 12 : 14),
                        ),
                      ),
                      SizedBox(width: isUltraSmall ? 6 : 12),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isUltraSmall ? 12 : 16,
                            vertical: isUltraSmall ? 6 : 10,
                          ),
                        ),
                        child: Text(
                          'Понятно!',
                          style: TextStyle(fontSize: isUltraSmall ? 12 : 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipSection(String title, String content) {
    final isUltraSmall = _isUltraSmall();

    return Padding(
      padding: EdgeInsets.only(bottom: isUltraSmall ? 10 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isUltraSmall ? 13 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isUltraSmall ? 4 : 8),
          Text(
            content,
            style: TextStyle(fontSize: isUltraSmall ? 11 : 13, height: 1.3),
          ),
          Divider(height: isUltraSmall ? 12 : 16),
        ],
      ),
    );
  }
}

// Вспомогательный виджет для статистики
class _StatItem extends StatelessWidget {
  final String number;
  final String label;
  final bool isSmall;

  const _StatItem({
    required this.number,
    required this.label,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: isSmall ? 22 : 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: isSmall ? 2 : 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isSmall ? 10 : 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
