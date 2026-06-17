import 'package:flutter/material.dart';
import '../models/guide.dart';
import '../services/guide_service.dart';

const _kGreen = Color(0xFF0F6B52);

class GuideEditProfileScreen extends StatefulWidget {
  final Guide guide;

  const GuideEditProfileScreen({super.key, required this.guide});

  @override
  State<GuideEditProfileScreen> createState() => _GuideEditProfileScreenState();
}

const _kCities = {
  'makkah': 'Мекка',
  'madinah': 'Медина',
  'jeddah': 'Джидда',
};

const _kLanguages = {
  'russian': 'Русский',
  'arabic': 'Арабский',
  'english': 'Английский',
};

// Все цены гид указывает в риалах (SAR); конвертация в рубли — на витрине.
const _kServiceTemplates = [
  {'type': 'medina_to_makkah', 'label': 'Медина → Мекка', 'price': 500},
  {'type': 'makkah_to_medina', 'label': 'Мекка → Медина', 'price': 500},
  {'type': 'jeddah_to_makkah', 'label': 'Джидда → Мекка', 'price': 250},
  {'type': 'makkah_to_jeddah', 'label': 'Мекка → Джидда', 'price': 250},
  {'type': 'excursion_makkah', 'label': 'Экскурсия по Мекке', 'price': 350},
  {'type': 'excursion_medina', 'label': 'Экскурсия по Медине', 'price': 350},
  {'type': 'umrah', 'label': 'Умра', 'price': 375},
];

class _CustomServiceRow {
  final TextEditingController name;
  final TextEditingController price;

  _CustomServiceRow({String name = '', String price = ''})
      : name = TextEditingController(text: name),
        price = TextEditingController(text: price);

  void dispose() {
    name.dispose();
    price.dispose();
  }
}

class _GuideEditProfileScreenState extends State<GuideEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _bio;
  late final TextEditingController _phone;
  late final TextEditingController _whatsapp;
  late final TextEditingController _telegram;
  late final TextEditingController _pricePerDay;
  late final TextEditingController _pricePerHour;
  late String _city;
  late Set<String> _languages;

  final Map<String, bool> _templateEnabled = {};
  final Map<String, TextEditingController> _templatePrice = {};
  final List<_CustomServiceRow> _customServices = [];

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final g = widget.guide;
    _name = TextEditingController(text: g.name);
    _bio = TextEditingController(text: g.bio ?? '');
    _phone = TextEditingController(text: g.phone ?? '');
    _whatsapp = TextEditingController(text: g.whatsapp ?? '');
    _telegram = TextEditingController(text: g.telegram ?? '');
    _pricePerDay = TextEditingController(text: g.pricePerDay.toInt().toString());
    _pricePerHour =
        TextEditingController(text: g.pricePerHour?.toInt().toString() ?? '');
    _city = _kCities.containsKey(g.city) ? g.city : 'makkah';
    _languages = g.languages.toSet();

    final templateTypes = _kServiceTemplates.map((t) => t['type']).toSet();
    for (final template in _kServiceTemplates) {
      final type = template['type'] as String;
      final matches = g.pricing.where((p) => p.serviceType == type);
      final existing = matches.isEmpty ? null : matches.first;
      _templateEnabled[type] = existing != null;
      _templatePrice[type] = TextEditingController(
        text: (existing?.price ?? (template['price'] as int).toDouble())
            .toInt()
            .toString(),
      );
    }
    for (final item in g.pricing) {
      if (!templateTypes.contains(item.serviceType)) {
        _customServices.add(
          _CustomServiceRow(
            name: item.name,
            price: item.price.toInt().toString(),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _phone.dispose();
    _whatsapp.dispose();
    _telegram.dispose();
    _pricePerDay.dispose();
    _pricePerHour.dispose();
    for (final c in _templatePrice.values) {
      c.dispose();
    }
    for (final row in _customServices) {
      row.dispose();
    }
    super.dispose();
  }

  void _addCustomService() {
    setState(() => _customServices.add(_CustomServiceRow()));
  }

  void _removeCustomService(int index) {
    setState(() => _customServices.removeAt(index).dispose());
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_languages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы один язык')),
      );
      return;
    }

    final pricing = <Map<String, dynamic>>[];
    for (final template in _kServiceTemplates) {
      final type = template['type'] as String;
      if (_templateEnabled[type] != true) continue;
      final price = double.tryParse(_templatePrice[type]!.text.trim());
      if (price == null) continue;
      pricing.add({
        'service_type': type,
        'name': template['label'],
        'price': price,
        'currency': 'SAR',
      });
    }
    for (final row in _customServices) {
      final name = row.name.text.trim();
      final price = double.tryParse(row.price.text.trim());
      if (name.isEmpty || price == null) continue;
      pricing.add({
        'service_type': 'custom',
        'name': name,
        'price': price,
        'currency': 'SAR',
      });
    }

    if (pricing.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Укажите хотя бы одну услугу с ценой'),
        ),
      );
      return;
    }

    setState(() => _saving = true);

    final data = <String, dynamic>{
      'name': _name.text.trim(),
      'city': _city,
      'languages': _languages.toList(),
      'bio': _bio.text.trim(),
      'phone': _phone.text.trim(),
      'whatsapp': _whatsapp.text.trim(),
      'telegram': _telegram.text.trim(),
      'price_per_day': int.tryParse(_pricePerDay.text.trim()),
      if (_pricePerHour.text.trim().isNotEmpty)
        'price_per_hour': int.tryParse(_pricePerHour.text.trim()),
      'pricing': pricing,
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
            _field(
              _name,
              'Имя',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Введите имя' : null,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String>(
                initialValue: _city,
                decoration: const InputDecoration(
                  labelText: 'Город',
                  border: OutlineInputBorder(),
                ),
                items: _kCities.entries
                    .map((e) =>
                        DropdownMenuItem(value: e.key, child: Text(e.value)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _city = value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Wrap(
                spacing: 8,
                children: _kLanguages.entries.map((e) {
                  final selected = _languages.contains(e.key);
                  return FilterChip(
                    label: Text(e.value),
                    selected: selected,
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          _languages.add(e.key);
                        } else {
                          _languages.remove(e.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
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
            const SizedBox(height: 8),
            const Text(
              'Услуги и цены (в риалах SAR)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Включите услуги, которые вы предоставляете, и укажите цену. Нужна хотя бы одна.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ..._kServiceTemplates.map((template) {
              final type = template['type'] as String;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Checkbox(
                      value: _templateEnabled[type],
                      activeColor: _kGreen,
                      onChanged: (value) {
                        setState(() => _templateEnabled[type] = value ?? false);
                      },
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(template['label'] as String),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: _templatePrice[type],
                        enabled: _templateEnabled[type] == true,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          suffixText: 'SAR',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
            ..._customServices.asMap().entries.map((entry) {
              final index = entry.key;
              final row = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: row.name,
                        decoration: const InputDecoration(
                          hintText: 'Название услуги',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        controller: row.price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          suffixText: 'SAR',
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _removeCustomService(index),
                    ),
                  ],
                ),
              );
            }),
            OutlinedButton.icon(
              onPressed: _addCustomService,
              icon: const Icon(Icons.add),
              label: const Text('Добавить услугу'),
              style: OutlinedButton.styleFrom(foregroundColor: _kGreen),
            ),
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
