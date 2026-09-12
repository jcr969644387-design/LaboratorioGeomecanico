import 'package:flutter/material.dart';

/// Barra de progreso con etiqueta, usada para RMR y puntajes.
class ValueMeter extends StatelessWidget {
  const ValueMeter({
    super.key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    this.trailing,
  });

  final String label;
  final double value;
  final double maxValue;
  final Color color;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double ratio = 0;
    if (maxValue > 0) ratio = value / maxValue;
    if (ratio < 0) ratio = 0;
    if (ratio > 1) ratio = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            Text(
              trailing ?? '${value.toStringAsFixed(0)} / $maxValue',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 10,
            color: color,
            backgroundColor: color.withOpacity(0.15),
          ),
        ),
      ],
    );
  }
}
