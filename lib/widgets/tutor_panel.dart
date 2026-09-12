import 'package:flutter/material.dart';

import '../services/tutor_service.dart';
import '../theme/app_colors.dart';

/// Panel del tutor geomecánico local basado en reglas.
class TutorPanel extends StatelessWidget {
  const TutorPanel({super.key, required this.messages});

  final List<TutorMessage> messages;

  Color _colorFor(TutorTone tone) {
    switch (tone) {
      case TutorTone.info:
        return AppColors.info;
      case TutorTone.warning:
        return AppColors.riskMedium;
      case TutorTone.positive:
        return AppColors.riskLow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: messages.map((TutorMessage message) {
        final Color color = _colorFor(message.tone);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: color, width: 4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                message.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message.body,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
