import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const _kSosRed = Color(0xFFD32F2F);

/// Плавающая кнопка экстренной помощи: звонок в полицию/скорую КСА
/// или отправка геолокации через системное окно "Поделиться".
class SosButton extends StatelessWidget {
  const SosButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'sos_button',
      backgroundColor: _kSosRed,
      foregroundColor: Colors.white,
      onPressed: () => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => const _SosSheet(),
      ),
      child: const Icon(Icons.sos),
    );
  }
}

class _SosSheet extends StatefulWidget {
  const _SosSheet();

  @override
  State<_SosSheet> createState() => _SosSheetState();
}

class _SosSheetState extends State<_SosSheet> {
  bool _sendingLocation = false;

  Future<void> _confirmAndCall(String label, String number) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Позвонить: $label?'),
        content: Text('Откроется набор номера $number.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _kSosRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Позвонить'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await launchUrl(Uri.parse('tel:$number'));
    }
  }

  Future<void> _sendLocation() async {
    setState(() => _sendingLocation = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Включите службы геолокации на устройстве';
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw 'Нет доступа к геолокации';
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final mapsUrl =
          'https://maps.google.com/?q=${position.latitude},${position.longitude}';

      await SharePlus.instance.share(
        ShareParams(text: 'Мне нужна помощь! Моё местоположение: $mapsUrl'),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _sendingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.sos, color: _kSosRed, size: 28),
                SizedBox(width: 10),
                Text(
                  'Экстренная помощь',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Номера экстренных служб Саудовской Аравии',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _sosCallTile(Icons.local_police_outlined, 'Полиция', '999'),
            const SizedBox(height: 10),
            _sosCallTile(Icons.local_hospital_outlined, 'Скорая помощь', '997'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _sendingLocation ? null : _sendLocation,
                icon: _sendingLocation
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.share_location_outlined),
                label: Text(
                  _sendingLocation
                      ? 'Определяем местоположение...'
                      : 'Отправить мою геолокацию',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kSosRed,
                  side: const BorderSide(color: _kSosRed),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sosCallTile(IconData icon, String label, String number) {
    return InkWell(
      onTap: () => _confirmAndCall(label, number),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _kSosRed.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kSosRed.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: _kSosRed),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: _kSosRed,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.call, color: _kSosRed, size: 18),
          ],
        ),
      ),
    );
  }
}
