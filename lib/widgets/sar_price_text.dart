// lib/widgets/sar_price_text.dart
import 'package:flutter/material.dart';
import '../services/currency_service.dart';

/// Цена в риалах с конвертацией в рубли по текущему курсу, отдельной
/// строкой помельче — так длинная сумма не переполняет узкие карточки.
/// Если курс не загрузился, показывает только сумму в риалах.
class SarPriceText extends StatelessWidget {
  final double sar;
  final String suffix;
  final TextStyle? style;
  final TextStyle? rubStyle;
  final CrossAxisAlignment crossAxisAlignment;

  const SarPriceText({
    super.key,
    required this.sar,
    this.suffix = '',
    this.style,
    this.rubStyle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double?>(
      future: CurrencyService.getSarToRubRate(),
      builder: (context, snapshot) {
        final rate = snapshot.data;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Text(
              '${sar.toInt()} SAR$suffix',
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
            if (rate != null)
              Text(
                '~${(sar * rate).round()} ₽',
                style: rubStyle ??
                    const TextStyle(fontSize: 11, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
          ],
        );
      },
    );
  }
}
