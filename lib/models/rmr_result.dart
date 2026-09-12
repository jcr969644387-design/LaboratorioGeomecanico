import 'risk_level.dart';

/// Puntaje individual de un parámetro del RMR.
class RmrParameterScore {
  const RmrParameterScore({
    required this.code,
    required this.name,
    required this.value,
    required this.score,
    required this.maxScore,
  });

  final String code;
  final String name;
  final String value;
  final int score;
  final int maxScore;
}

/// Clase del macizo rocoso según el puntaje RMR.
class RmrClassInfo {
  const RmrClassInfo({
    required this.roman,
    required this.quality,
    required this.description,
    required this.risk,
    required this.rangeLabel,
  });

  final String roman;
  final String quality;
  final String description;
  final RiskLevel risk;
  final String rangeLabel;

  /// Clasificación a partir del RMR final, en la escala configurable 0-100.
  static RmrClassInfo fromScore(int rmr) {
    if (rmr < 0 || rmr > 100) {
      throw ArgumentError('El RMR debe estar entre 0 y 100.');
    }
    if (rmr >= 81) {
      return const RmrClassInfo(
        roman: 'I',
        quality: 'Roca muy buena',
        rangeLabel: 'RMR 81-100',
        risk: RiskLevel.low,
        description:
            'Macizo competente, poco fracturado y sin agua relevante. '
            'La excavación es normalmente autosoportante en luces pequeñas.',
      );
    }
    if (rmr >= 61) {
      return const RmrClassInfo(
        roman: 'II',
        quality: 'Roca buena',
        rangeLabel: 'RMR 61-80',
        risk: RiskLevel.low,
        description:
            'Macizo estable con fracturamiento moderado. Se esperan caídas '
            'puntuales de bloques controlables con sostenimiento ligero.',
      );
    }
    if (rmr >= 41) {
      return const RmrClassInfo(
        roman: 'III',
        quality: 'Roca regular',
        rangeLabel: 'RMR 41-60',
        risk: RiskLevel.medium,
        description:
            'Macizo fracturado en bloques. La estabilidad depende del '
            'tiempo de autosostenimiento y del control de las cuñas.',
      );
    }
    if (rmr >= 21) {
      return const RmrClassInfo(
        roman: 'IV',
        quality: 'Roca mala',
        rangeLabel: 'RMR 21-40',
        risk: RiskLevel.high,
        description:
            'Macizo muy fracturado o alterado. Requiere sostenimiento '
            'sistemático e inmediato después de la voladura.',
      );
    }
    return const RmrClassInfo(
      roman: 'V',
      quality: 'Roca muy mala',
      rangeLabel: 'RMR 0-20',
      risk: RiskLevel.high,
      description:
          'Macizo triturado, alterado o con flujo de agua. El tiempo de '
          'autosostenimiento es muy corto y el riesgo de colapso es alto.',
    );
  }
}

/// Resultado completo de la evaluación RMR.
class RmrResult {
  const RmrResult({
    required this.scores,
    required this.basicRmr,
    required this.orientationAdjustment,
    required this.finalRmr,
  });

  /// Puntajes A1 a A5.
  final List<RmrParameterScore> scores;

  /// Suma de A1 a A5, sin ajuste por orientación.
  final int basicRmr;

  /// Ajuste B por orientación de discontinuidades (valor negativo o cero).
  final int orientationAdjustment;

  /// RMR final acotado a la escala 0-100.
  final int finalRmr;

  RmrClassInfo get classInfo => RmrClassInfo.fromScore(finalRmr);

  RiskLevel get risk => classInfo.risk;

  static const String formula =
      'RMR = A1 + A2 + A3 + A4 + A5 + B, donde A1 es la resistencia de la '
      'roca intacta, A2 el RQD, A3 el espaciamiento, A4 la condición de '
      'discontinuidades, A5 el agua subterránea y B el ajuste por '
      'orientación.';

  /// Parámetro con mayor pérdida de puntaje respecto a su máximo.
  RmrParameterScore get weakestParameter {
    RmrParameterScore worst = scores.first;
    int worstGap = worst.maxScore - worst.score;
    for (final RmrParameterScore score in scores) {
      final int gap = score.maxScore - score.score;
      if (gap > worstGap) {
        worst = score;
        worstGap = gap;
      }
    }
    return worst;
  }
}
