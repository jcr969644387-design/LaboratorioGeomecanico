import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Aviso persistente sobre el carácter educativo de la aplicación.
class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.color = AppColors.caution,
  });

  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
