import 'package:flutter/material.dart';

import '../models/risk_level.dart';
import '../theme/app_theme.dart';

/// Indicador visual compacto del nivel de riesgo.
class RiskChip extends StatelessWidget {
  const RiskChip({super.key, required this.level, this.label});

  final RiskLevel level;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final Color color = AppTheme.riskColor(level);
    final String text = label ?? level.label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(AppTheme.riskIcon(level), size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
