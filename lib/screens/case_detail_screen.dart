import 'package:flutter/material.dart';

import '../calculators/q_calculator.dart';
import '../calculators/rmr_calculator.dart';
import '../calculators/support_selector.dart';
import '../models/case_study.dart';
import '../models/q_result.dart';
import '../models/rmr_result.dart';
import '../models/support_recommendation.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/risk_chip.dart';
import '../widgets/section_card.dart';

/// Ficha completa de un caso subterráneo.
class CaseDetailScreen extends StatefulWidget {
  const CaseDetailScreen({super.key, required this.study});

  final CaseStudy study;

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  final Map<int, int> _answers = <int, int>{};
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    final CaseStudy study = widget.study;
    final ThemeData theme = Theme.of(context);

    final RmrResult rmr = RmrCalculator.evaluate(study.rockMass);
    final QResult q = QCalculator.evaluate(study.qInput);
    final SupportRecommendation support = SupportSelector.select(
      SupportQuery(
        rmr: rmr.finalRmr,
        q: q.q,
        excavationType: study.excavationType,
        spanM: study.spanM,
        risk: study.risk,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(study.title)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 28),
        children: <Widget>[
          SectionCard(
            title: 'Información geológica',
            icon: Icons.terrain_outlined,
            children: <Widget>[
              Text(
                study.geology,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
              ),
            ],
          ),
          SectionCard(
            title: 'Datos numéricos',
            icon: Icons.table_rows_outlined,
            children: study.numericData.entries.map((
              MapEntry<String, String> entry,
            ) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        entry.key,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SectionCard(
            title: 'Preguntas para el estudiante',
            subtitle: 'Responde antes de revisar el cálculo esperado.',
            icon: Icons.quiz_outlined,
            children: _buildQuestions(study, theme),
          ),
          if (_revealed) _expectedCard(rmr, q, theme),
          if (_revealed) _supportCard(support, theme),
          if (_revealed)
            SectionCard(
              title: 'Retroalimentación técnica',
              icon: Icons.psychology_outlined,
              children: <Widget>[
                Text(
                  study.technicalFeedback,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 12),
                Text(
                  'Consecuencia de una elección inadecuada',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  study.wrongChoiceConsequence,
                  style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _revealed = true;
                    });
                  },
                  icon: const Icon(Icons.fact_check_outlined),
                  label: const Text('Ver cálculo y retroalimentación'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    AppStateScope.of(context).loadScenario(
                      rockMass: study.rockMass,
                      qInput: study.qInput,
                      excavationType: study.excavationType,
                      spanM: study.spanM,
                      risk: study.risk,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Escenario cargado en el laboratorio.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.upload_outlined),
                  label: const Text('Cargar este caso en el laboratorio'),
                ),
              ],
            ),
          ),
          const DisclaimerBanner(message: SupportRecommendation.warning),
        ],
      ),
    );
  }

  List<Widget> _buildQuestions(CaseStudy study, ThemeData theme) {
    final List<Widget> widgets = <Widget>[];

    for (int i = 0; i < study.questions.length; i++) {
      final CaseQuestion question = study.questions[i];
      final int? selected = _answers[i];

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            '${i + 1}. ${question.prompt}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      for (int j = 0; j < question.options.length; j++) {
        widgets.add(
          RadioListTile<int>(
            value: j,
            groupValue: selected,
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              question.options[j],
              style: theme.textTheme.bodySmall,
            ),
            onChanged: (int? value) {
              if (value == null) return;
              setState(() {
                _answers[i] = value;
              });
            },
          ),
        );
      }

      if (selected != null) {
        final bool correct = selected == question.correctIndex;
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  correct ? Icons.check_circle : Icons.cancel,
                  size: 18,
                  color: correct ? Colors.green : Colors.redAccent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question.feedback,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        widgets.add(const SizedBox(height: 10));
      }
    }

    return widgets;
  }

  Widget _expectedCard(RmrResult rmr, QResult q, ThemeData theme) {
    return SectionCard(
      title: 'Cálculo esperado',
      subtitle: 'Resultado obtenido con las calculadoras de la aplicación.',
      icon: Icons.calculate_outlined,
      accentColor: AppTheme.riskColor(rmr.risk),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'RMR final: ${rmr.finalRmr} · Clase '
                '${rmr.classInfo.roman} (${rmr.classInfo.quality})',
                style: theme.textTheme.bodySmall,
              ),
            ),
            RiskChip(level: rmr.risk),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Índice Q: ${Fmt.smart(q.q)} · ${q.classInfo.label}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Text(
          'RMR básico ${rmr.basicRmr} con ajuste por orientación '
          '${Fmt.signed(rmr.orientationAdjustment)}.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _supportCard(SupportRecommendation support, ThemeData theme) {
    return SectionCard(
      title: 'Selección de sostenimiento esperada',
      icon: Icons.construction_outlined,
      accentColor: AppTheme.riskColor(support.risk),
      children: <Widget>[
        Text(
          support.system,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          support.justification,
          style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
        ),
        const SizedBox(height: 8),
        Text(
          'Confianza: ${support.confidence.label}. '
          '${support.confidenceReason}',
          style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
        ),
      ],
    );
  }
}
