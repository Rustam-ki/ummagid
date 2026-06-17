import 'package:flutter/material.dart';
import 'package:my_first_app/services/auth_service.dart';
import 'package:my_first_app/screens/my_bookings_screen.dart';
import 'package:my_first_app/screens/login_screen.dart';
import 'package:my_first_app/screens/register_screen.dart';
import 'package:my_first_app/screens/guide_cabinet_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  bool _isGuide = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
    if (isLoggedIn) {
    await _loadUserData();  // ← ДОБАВЬТЕ ЭТУ СТРОКУ
  }
  }

  // В ProfileScreenState добавьте:
    Future<void> _loadUserData() async {
    final user = await AuthService.getCurrentUser();
    if (user != null && mounted) {
        setState(() {
        _userName = user.name;
        _userEmail = user.email;
        _isGuide = user.isGuide;
        });
    }
    }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService.logout();
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вы вышли из аккаунта'), backgroundColor: Colors.orange),
        );
      }
    }
  }

  @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: _isLoggedIn
          ? RefreshIndicator(
              onRefresh: _loadUserData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Аватар
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF1B5E20).withOpacity(0.1),
                          child: const Icon(Icons.person, size: 50, color: Color(0xFF1B5E20)),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _userName,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _userEmail,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Кабинет гида (только для гидов)
                  if (_isGuide)
                    Card(
                      color: const Color(0xFF1B5E20).withOpacity(0.06),
                      child: ListTile(
                        leading: const Icon(Icons.badge, color: Color(0xFF1B5E20)),
                        title: const Text('Кабинет гида'),
                        subtitle: const Text('Мои брони и профиль'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const GuideCabinetScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  // Мои бронирования
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.history, color: Color(0xFF1B5E20)),
                      title: const Text('Мои бронирования'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
                        );
                      },
                    ),
                  ),
                  // Редактировать профиль
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.edit, color: Color(0xFF1B5E20)),
                      title: const Text('Редактировать профиль'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // TODO: экран редактирования профиля
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Кнопка выхода
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text('Выйти'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFF1B5E20),
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text('Гость', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text('Войдите, чтобы сохранять избранное', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      ).then((_) => _checkAuth());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Войти', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      ).then((_) => _checkAuth());
                    },
                    child: const Text('Регистрация', style: TextStyle(color: Color(0xFF1B5E20))),
                  ),
                ],
              ),
            ),
    );
  }
}