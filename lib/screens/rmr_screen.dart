import 'package:flutter/material.dart';

import '../models/rmr_result.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/risk_chip.dart';
import '../widgets/score_table.dart';
import '../widgets/section_card.dart';
import '../widgets/tutor_panel.dart';
import '../widgets/value_meter.dart';

/// Módulo evaluador del Rock Mass Rating.
class RmrScreen extends StatelessWidget {
  const RmrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final RmrResult result = state.rmrResult;
    final RmrClassInfo info = result.classInfo;
    final ThemeData theme = Theme.of(context);
    final Color riskColor = AppTheme.riskColor(result.risk);

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            'Evaluador RMR',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SectionCard(
          title: 'Resultado',
          subtitle: 'Escala configurable de 0 a 100.',
          icon: Icons.assessment_outlined,
          accentColor: riskColor,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${result.finalRmr}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: riskColor,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Clase ${info.roman} · ${info.quality}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(info.rangeLabel, style: theme.textTheme.bodySmall),
                      const SizedBox(height: 8),
                      RiskChip(level: result.risk),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ValueMeter(
              label: 'RMR final',
              value: result.finalRmr.toDouble(),
              maxValue: 100,
              color: riskColor,
              trailing: '${result.finalRmr} / 100',
            ),
            const SizedBox(height: 12),
            Text(info.description, style: theme.textTheme.bodySmall),
          ],
        ),
        SectionCard(
          title: 'Puntaje por parámetro',
          subtitle: 'Detalle de los componentes A1 a A5.',
          icon: Icons.table_chart_outlined,
          children: <Widget>[
            ScoreTable(scores: result.scores),
            const Divider(height: 24),
            _SummaryRow(
              label: 'Suma A1 a A5 (RMR básico)',
              value: '${result.basicRmr}',
            ),
            _SummaryRow(
              label: 'Ajuste B por orientación',
              value: Fmt.signed(result.orientationAdjustment),
            ),
            _SummaryRow(
              label: 'RMR final',
              value: '${result.finalRmr}',
              emphasized: true,
            ),
          ],
        ),
        SectionCard(
          title: 'Clasificación utilizada',
          subtitle: 'Tabla simplificada con fines educativos.',
          icon: Icons.list_alt_outlined,
          children: const <Widget>[
            _ClassRow(range: 'RMR 81-100', text: 'Clase I, roca muy buena'),
            _ClassRow(range: 'RMR 61-80', text: 'Clase II, roca buena'),
            _ClassRow(range: 'RMR 41-60', text: 'Clase III, roca regular'),
            _ClassRow(range: 'RMR 21-40', text: 'Clase IV, roca mala'),
            _ClassRow(range: 'RMR 0-20', text: 'Clase V, roca muy mala'),
          ],
        ),
        SectionCard(
          title: 'Fórmula utilizada',
          icon: Icons.calculate_outlined,
          children: <Widget>[
            Text(
              RmrResult.formula,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
            ),
          ],
        ),
        SectionCard(
          title: 'Interpretación del tutor geomecánico',
          subtitle: 'Explicación local basada en reglas.',
          icon: Icons.school_outlined,
          children: <Widget>[TutorPanel(messages: state.tutorMessages)],
        ),
        const DisclaimerBanner(message: AppInfo.tablesNote),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? style = emphasized
        ? theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)
        : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class _ClassRow extends StatelessWidget {
  const _ClassRow({required this.range, required this.text});

  final String range;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 96,
            child: Text(
              range,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
