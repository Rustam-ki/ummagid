import 'package:flutter/material.dart';
import '../models/guide.dart';
import '../services/guide_service.dart';

const _kGreen = Color(0xFF1B5E20);

class GuideEditProfileScreen extends StatefulWidget {
  final Guide guide;

  const GuideEditProfileScreen({super.key, required this.guide});

  @override
  State<GuideEditProfileScreen> createState() => _GuideEditProfileScreenState();
}

class _GuideEditProfileScreenState extends State<GuideEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bio;
  late final TextEditingController _phone;
  late final TextEditingController _whatsapp;
  late final TextEditingController _telegram;
  late final TextEditingController _pricePerDay;
  late final TextEditingController _pricePerHour;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final g = widget.guide;
    _bio = TextEditingController(text: g.bio ?? '');
    _phone = TextEditingController(text: g.phone ?? '');
    _whatsapp = TextEditingController(text: g.whatsapp ?? '');
    _telegram = TextEditingController(text: g.telegram ?? '');
    _pricePerDay = TextEditingController(text: g.pricePerDay.toInt().toString());
    _pricePerHour =
        TextEditingController(text: g.pricePerHour?.toInt().toString() ?? '');
  }

  @override
  void dispose() {
    _bio.dispose();
    _phone.dispose();
    _whatsapp.dispose();
    _telegram.dispose();
    _pricePerDay.dispose();
    _pricePerHour.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'bio': _bio.text.trim(),
      'phone': _phone.text.trim(),
      'whatsapp': _whatsapp.text.trim(),
      'telegram': _telegram.text.trim(),
      'price_per_day': int.tryParse(_pricePerDay.text.trim()),
      if (_pricePerHour.text.trim().isNotEmpty)
        'price_per_hour': int.tryParse(_pricePerHour.text.trim()),
    };

    bool ok = false;
    try {
      ok = await GuideService.updateProfile(data);
    } catch (_) {
      ok = false;
    }

    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? 'Профиль сохранён' : 'Не удалось сохранить'),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
    if (ok) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        backgroundColor: _kGreen,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_bio, 'О себе', maxLines: 4),
            _field(_phone, 'Телефон', keyboard: TextInputType.phone),
            _field(_whatsapp, 'WhatsApp', keyboard: TextInputType.phone),
            _field(_telegram, 'Telegram'),
            _field(
              _pricePerDay,
              'Цена за день (SAR)',
              keyboard: TextInputType.number,
              validator: (v) =>
                  (v == null || int.tryParse(v) == null) ? 'Укажите число' : null,
            ),
            _field(_pricePerHour, 'Цена за час (SAR), необязательно',
                keyboard: TextInputType.number),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
