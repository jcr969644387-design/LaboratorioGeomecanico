import 'package:flutter/material.dart';

import '../models/rmr_result.dart';

/// Tabla con el puntaje individual de cada parámetro del RMR.
class ScoreTable extends StatelessWidget {
  const ScoreTable({super.key, required this.scores});

  final List<RmrParameterScore> scores;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Text('Parámetro', style: theme.textTheme.labelMedium),
              ),
              Expanded(
                flex: 3,
                child: Text('Valor', style: theme.textTheme.labelMedium),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Puntaje',
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 8),
        ...scores.map((RmrParameterScore score) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Text(
                    '${score.code}. ${score.name}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    score.value,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${score.score} / ${score.maxScore}',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
