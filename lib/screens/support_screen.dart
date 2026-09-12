import 'package:flutter/material.dart';

import '../models/support_recommendation.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/numeric_field.dart';
import '../widgets/option_selector.dart';
import '../widgets/risk_chip.dart';
import '../widgets/section_card.dart';
import '../widgets/value_meter.dart';

/// Módulo de selección básica de sostenimiento.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final SupportQuery query = state.supportQuery;
    final SupportRecommendation? support = state.support;
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            'Selección básica de sostenimiento',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SectionCard(
          title: 'Escenario de la excavación',
          subtitle:
              'El RMR y el Q provienen de los módulos anteriores; aquí se '
              'define la geometría y el riesgo.',
          icon: Icons.architecture_outlined,
          children: <Widget>[
            _DataRow(label: 'RMR final', value: '${query.rmr}'),
            _DataRow(label: 'Índice Q', value: Fmt.smart(query.q)),
            const SizedBox(height: 12),
            OptionSelector<ExcavationType>(
              label: 'Tipo de excavación',
              value: query.excavationType,
              options: ExcavationType.values.map((ExcavationType item) {
                return SelectorOption<ExcavationType>(
                  value: item,
                  label: item.label,
                  description: item.detail,
                );
              }).toList(),
              onChanged: (ExcavationType value) {
                state.updateSupportQuery(
                  query.copyWith(excavationType: value),
                );
              },
            ),
            NumericField(
              label: 'Ancho o luz de la excavación',
              suffix: 'm',
              value: query.spanM,
              min: Limits.spanMin,
              max: Limits.spanMax,
              decimals: 1,
              helperText: 'A mayor luz, mayor área expuesta del techo y mayor '
                  'volumen potencial de cuñas.',
              onChanged: (double value) {
                state.updateSupportQuery(query.copyWith(spanM: value));
              },
            ),
            OptionSelector<OperationalRisk>(
              label: 'Nivel de riesgo operativo',
              value: query.risk,
              options: OperationalRisk.values.map((OperationalRisk item) {
                return SelectorOption<OperationalRisk>(
                  value: item,
                  label: item.label,
                  description: item.detail,
                );
              }).toList(),
              onChanged: (OperationalRisk value) {
                state.updateSupportQuery(query.copyWith(risk: value));
              },
            ),
          ],
        ),
        if (support != null) _RecommendationCard(support: support),
        const _ReferenceTableCard(),
        const DisclaimerBanner(
          message: SupportRecommendation.warning,
          icon: Icons.engineering_outlined,
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.support});

  final SupportRecommendation support;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = AppTheme.riskColor(support.risk);

    return SectionCard(
      title: 'Sistema recomendado',
      subtitle: 'Recomendación preliminar de carácter educativo.',
      icon: Icons.construction_outlined,
      accentColor: color,
      children: <Widget>[
        Text(
          support.system,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 10),
        ...support.elements.map((String element) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.check_circle_outline, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(element, style: theme.textTheme.bodySmall),
                ),
              ],
            ),
          );
        }),
        const Divider(height: 24),
        Text(
          'Justificación técnica',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          support.justification,
          style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
        ),
        const SizedBox(height: 16),
        ValueMeter(
          label: 'Nivel de confianza de la recomendación',
          value: support.confidence.ratio * 100,
          maxValue: 100,
          color: color,
          trailing: support.confidence.label,
        ),
        const SizedBox(height: 10),
        Text(
          support.confidenceReason,
          style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            RiskChip(level: support.risk),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Nivel de exigencia ${support.level} de 5',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReferenceTableCard extends StatelessWidget {
  const _ReferenceTableCard();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    const List<List<String>> rows = <List<String>>[
      <String>['I', 'Q > 40', 'Desatado y control visual'],
      <String>['II', 'Q 10 - 40', 'Pernos puntuales o sistemáticos'],
      <String>['III', 'Q 4 - 10', 'Pernos sistemáticos, malla si hay paso'],
      <String>['IV', 'Q 1 - 4', 'Pernos con malla o shotcrete inmediato'],
      <String>['V', 'Q < 1', 'Shotcrete reforzado y cerchas metálicas'],
    ];

    return SectionCard(
      title: 'Tabla educativa de referencia',
      subtitle: 'Relación orientativa entre clase, Q y sostenimiento.',
      icon: Icons.grid_on_outlined,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 40,
              child: Text('Clase', style: theme.textTheme.labelMedium),
            ),
            SizedBox(
              width: 80,
              child: Text('Q', style: theme.textTheme.labelMedium),
            ),
            Expanded(
              child: Text(
                'Sostenimiento preliminar',
                style: theme.textTheme.labelMedium,
              ),
            ),
          ],
        ),
        const Divider(height: 12),
        ...rows.map((List<String> row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 40,
                  child: Text(
                    row[0],
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(row[1], style: theme.textTheme.bodySmall),
                ),
                Expanded(
                  child: Text(row[2], style: theme.textTheme.bodySmall),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
