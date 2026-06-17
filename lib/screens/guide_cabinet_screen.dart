import 'package:flutter/material.dart';
import 'package:flutter_cors_image/flutter_cors_image.dart';
import '../models/guide.dart';
import '../services/guide_service.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'guide_edit_profile_screen.dart';

const _kGreen = Color(0xFF1B5E20);

class GuideCabinetScreen extends StatefulWidget {
  const GuideCabinetScreen({super.key});

  @override
  State<GuideCabinetScreen> createState() => _GuideCabinetScreenState();
}

class _GuideCabinetScreenState extends State<GuideCabinetScreen> {
  Guide? _profile;
  List<dynamic> _bookings = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await Future.wait([
        GuideService.getMyProfile(),
        GuideService.getMyBookings(),
      ]);
      if (!mounted) return;
      setState(() {
        _profile = results[0] as Guide;
        _bookings = results[1] as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Выйти из кабинета гида?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _setBookingStatus(int id, {required bool confirm}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final ok = confirm
        ? await GuideService.confirmBooking(id)
        : await GuideService.rejectBooking(id);

    if (!mounted) return;
    Navigator.pop(context); // закрыть индикатор

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok
            ? (confirm ? 'Бронь подтверждена' : 'Бронь отклонена')
            : 'Не удалось обновить статус'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
    if (ok) _load();
  }

  Future<void> _openEditProfile() async {
    if (_profile == null) return;
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => GuideEditProfileScreen(guide: _profile!),
      ),
    );
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    final pending =
        _bookings.where((b) => b['status'] == 'pending').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Кабинет гида'),
        backgroundColor: _kGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _ErrorView(error: _error!, onRetry: _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _ProfileHeader(
                        profile: _profile!,
                        onEdit: _openEditProfile,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Text(
                            'Бронирования',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          if (pending.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${pending.length} новых',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_bookings.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.event_busy,
                                    size: 56, color: Colors.grey),
                                SizedBox(height: 12),
                                Text('Пока нет бронирований',
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        )
                      else
                        ..._bookings.map(
                          (b) => _GuideBookingCard(
                            booking: b,
                            onConfirm: b['status'] == 'pending'
                                ? () => _setBookingStatus(b['id'],
                                    confirm: true)
                                : null,
                            onReject: b['status'] == 'pending'
                                ? () => _setBookingStatus(b['id'],
                                    confirm: false)
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Guide profile;
  final VoidCallback onEdit;

  const _ProfileHeader({required this.profile, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: profile.photoUrl != null &&
                          profile.photoUrl!.startsWith('http')
                      ? CustomNetworkImage(
                          url: profile.photoUrl!,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 72,
                          height: 72,
                          color: _kGreen.withOpacity(0.1),
                          child: const Icon(Icons.person,
                              size: 40, color: _kGreen),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              profile.name,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (profile.isVerified)
                            const Icon(Icons.verified,
                                color: _kGreen, size: 20),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 14, color: Colors.grey),
                          Text(profile.cityName,
                              style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 12),
                          const Icon(Icons.star,
                              size: 14, color: Colors.amber),
                          Text(
                            ' ${profile.rating} (${profile.reviewsCount})',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _StatChip(
                    label: 'Цена/день',
                    value: '${profile.pricePerDay.toInt()} SAR'),
                if (profile.experienceYears != null)
                  _StatChip(
                      label: 'Опыт',
                      value: '${profile.experienceYears} лет'),
                if (profile.groupsCount != null)
                  _StatChip(
                      label: 'Групп', value: '${profile.groupsCount}'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
                label: const Text('Редактировать профиль'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kGreen,
                  side: const BorderSide(color: _kGreen),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: _kGreen)),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

class _GuideBookingCard extends StatelessWidget {
  final dynamic booking;
  final VoidCallback? onConfirm;
  final VoidCallback? onReject;

  const _GuideBookingCard({
    required this.booking,
    this.onConfirm,
    this.onReject,
  });

  Color _statusColor(String s) {
    switch (s) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusText(String s) {
    switch (s) {
      case 'pending':
        return 'Ожидает';
      case 'confirmed':
        return 'Подтверждено';
      case 'cancelled':
        return 'Отменено';
      case 'rejected':
        return 'Отклонено';
      default:
        return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = booking['status']?.toString() ?? '';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Бронь #${booking['id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusText(status),
                    style: TextStyle(
                        color: _statusColor(status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _row(Icons.person, booking['client_name'] ?? 'Клиент'),
            if (booking['client_phone'] != null)
              _row(Icons.phone, booking['client_phone']),
            _row(Icons.calendar_today,
                '${booking['start_date']} → ${booking['end_date']}'),
            _row(Icons.people, '${booking['persons']} чел.'),
            if (booking['total_price'] != null)
              _row(Icons.payments,
                  '${double.tryParse(booking['total_price'].toString())?.toInt() ?? booking['total_price']} SAR'),
            if (onConfirm != null || onReject != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onReject != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('Отклонить'),
                      ),
                    ),
                  if (onReject != null && onConfirm != null)
                    const SizedBox(width: 12),
                  if (onConfirm != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _kGreen,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Подтвердить'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, dynamic text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text('$text', style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
