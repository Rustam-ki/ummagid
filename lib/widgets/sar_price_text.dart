// lib/widgets/sar_price_text.dart
import 'package:flutter/material.dart';
import '../services/currency_service.dart';

/// Текст вида "500 SAR (~12 500 ₽)" — цена в риалах с конвертацией
/// в рубли по текущему курсу. Если курс не загрузился, показывает
/// только сумму в риалах.
class SarPriceText extends StatelessWidget {
  final double sar;
  final String suffix;
  final TextStyle? style;
  final TextAlign? textAlign;

  const SarPriceText({
    super.key,
    required this.sar,
    this.suffix = '',
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double?>(
      future: CurrencyService.getSarToRubRate(),
      builder: (context, snapshot) {
        final rate = snapshot.data;
        final sarText = '${sar.toInt()} SAR$suffix';
        final text = rate == null
            ? sarText
            : '$sarText (~${(sar * rate).round()} ₽)';
        return Text(text, style: style, textAlign: textAlign);
      },
    );
  }
}
