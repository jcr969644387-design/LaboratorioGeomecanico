import 'package:flutter/material.dart';

import '../calculators/q_calculator.dart';
import '../models/q_result.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/numeric_field.dart';
import '../widgets/option_selector.dart';
import '../widgets/risk_chip.dart';
import '../widgets/section_card.dart';

/// Módulo de cálculo del índice Q de Barton.
class QSystemScreen extends StatelessWidget {
  const QSystemScreen({super.key});

  List<SelectorOption<double>> _optionsFrom(List<QFactorOption> source) {
    return source.map((QFactorOption option) {
      return SelectorOption<double>(
        value: option.value,
        label: option.label,
        description: option.description,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final QInput input = state.qInput;
    final QResult? result = state.qResult;
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            'Sistema Q',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SectionCard(
          title: 'Parámetros de entrada',
          subtitle: QResult.formula,
          icon: Icons.functions_outlined,
          children: <Widget>[
            NumericField(
              label: 'RQD',
              suffix: '%',
              value: input.rqd,
              min: Limits.rqdMin,
              max: Limits.rqdMax,
              decimals: 0,
              helperText:
                  'Si el RQD es menor a 10 %, el sistema Q utiliza 10 por '
                  'convención.',
              onChanged: (double value) {
                state.updateQInput(input.copyWith(rqd: value));
              },
            ),
            OptionSelector<double>(
              label: 'Jn · Número de familias',
              value: input.jn,
              options: _optionsFrom(QCalculator.jnOptions),
              onChanged: (double value) {
                state.updateQInput(input.copyWith(jn: value));
              },
            ),
            OptionSelector<double>(
              label: 'Jr · Rugosidad',
              value: input.jr,
              options: _optionsFrom(QCalculator.jrOptions),
              onChanged: (double value) {
                state.updateQInput(input.copyWith(jr: value));
              },
            ),
            OptionSelector<double>(
              label: 'Ja · Alteración o relleno',
              value: input.ja,
              options: _optionsFrom(QCalculator.jaOptions),
              onChanged: (double value) {
                state.updateQInput(input.copyWith(ja: value));
              },
            ),
            OptionSelector<double>(
              label: 'Jw · Factor de agua',
              value: input.jw,
              options: _optionsFrom(QCalculator.jwOptions),
              onChanged: (double value) {
                state.updateQInput(input.copyWith(jw: value));
              },
            ),
            OptionSelector<double>(
              label: 'SRF · Reducción por esfuerzos',
              value: input.srf,
              options: _optionsFrom(QCalculator.srfOptions),
              onChanged: (double value) {
                state.updateQInput(input.copyWith(srf: value));
              },
            ),
          ],
        ),
        if (result != null) _QResultCard(result: result),
        if (result != null) _QFactorsCard(result: result),
        const DisclaimerBanner(
          message: AppInfo.qContextWarning,
          icon: Icons.report_gmailerrorred_outlined,
        ),
        const DisclaimerBanner(message: AppInfo.tablesNote),
      ],
    );
  }
}

class _QResultCard extends StatelessWidget {
  const _QResultCard({required this.result});

  final QResult result;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final QClassInfo info = result.classInfo;
    final Color color = AppTheme.riskColor(result.risk);

    return SectionCard(
      title: 'Resultado del índice Q',
      icon: Icons.analytics_outlined,
      accentColor: color,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              Fmt.smart(result.q),
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    info.label,
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
        const SizedBox(height: 12),
        Text(info.description, style: theme.textTheme.bodySmall),
        const SizedBox(height: 10),
        Text(
          'RMR equivalente estimado con la correlación RMR = 9 ln Q + 44: '
          '${QCalculator.equivalentRmr(result.q).toStringAsFixed(0)}.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _QFactorsCard extends StatelessWidget {
  const _QFactorsCard({required this.result});

  final QResult result;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SectionCard(
      title: 'Explicación de cada factor',
      subtitle: 'Los tres cocientes del sistema Q.',
      icon: Icons.help_outline,
      children: <Widget>[
        _FactorTile(
          title: 'RQD / Jn = ${Fmt.decimal(result.blockSize)}',
          text:
              'Representa el tamaño relativo del bloque. Un RQD alto con '
              'pocas familias produce bloques grandes y estables.',
          style: theme.textTheme.bodySmall,
        ),
        _FactorTile(
          title: 'Jr / Ja = ${Fmt.decimal(result.shearStrength)}',
          text:
              'Representa la resistencia al corte entre bloques. La '
              'rugosidad (Jr) ayuda a la estabilidad y la alteración o el '
              'relleno (Ja) la reduce.',
          style: theme.textTheme.bodySmall,
        ),
        _FactorTile(
          title: 'Jw / SRF = ${Fmt.decimal(result.activeStress)}',
          text:
              'Representa el esfuerzo activo. El agua (Jw) y las '
              'condiciones de esfuerzo o zonas de falla (SRF) castigan el '
              'resultado final.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _FactorTile extends StatelessWidget {
  const _FactorTile({
    required this.title,
    required this.text,
    required this.style,
  });

  final String title;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: style?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(text, style: style?.copyWith(height: 1.35)),
        ],
      ),
    );
  }
}
