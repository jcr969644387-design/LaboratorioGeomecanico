import '../models/risk_level.dart';
import '../models/support_recommendation.dart';
import 'q_calculator.dart';

/// Selector educativo de sostenimiento preliminar.
///
/// Combina la clase RMR, el índice Q, el tipo y la dimensión de la
/// excavación, y el nivel de riesgo operativo, en un índice de exigencia
/// de 0 a 5 que se traduce en un sistema de sostenimiento.
class SupportSelector {
  const SupportSelector._();

  /// Exigencia base derivada de la clase RMR.
  static int baseDemandFromRmr(int rmr) {
    if (rmr < 0 || rmr > 100) {
      throw ArgumentError('El RMR debe estar entre 0 y 100.');
    }
    if (rmr >= 81) return 0;
    if (rmr >= 61) return 1;
    if (rmr >= 41) return 2;
    if (rmr >= 21) return 3;
    return 4;
  }

  /// Corrección por el índice Q.
  static int qModifier(double q) {
    if (q.isNaN || q.isInfinite || q <= 0) {
      throw ArgumentError('El índice Q debe ser un número positivo.');
    }
    if (q < 0.1) return 2;
    if (q < 1) return 1;
    if (q >= 40) return -1;
    return 0;
  }

  /// Corrección por la luz o ancho de la excavación, en metros.
  static int spanModifier(double spanM) {
    if (spanM <= 0) {
      throw ArgumentError('La luz de la excavación debe ser mayor que cero.');
    }
    if (spanM > 10) return 2;
    if (spanM > 5) return 1;
    return 0;
  }

  static SupportRecommendation select(SupportQuery query) {
    final int base = baseDemandFromRmr(query.rmr);
    final int qMod = qModifier(query.q);
    final int spanMod = spanModifier(query.spanM);
    final int typeMod = query.excavationType.demandBonus;
    final int riskMod = query.risk.demandBonus;

    final int rawLevel = base + qMod + spanMod + typeMod + riskMod;
    final int level = rawLevel.clamp(0, 5);

    final SupportConfidence confidence = _confidence(query);

    return SupportRecommendation(
      level: level,
      system: systemName(level),
      elements: elementsFor(level),
      justification: _justification(query, level, base, qMod, spanMod),
      confidence: confidence,
      confidenceReason: _confidenceReason(query, confidence),
      risk: _risk(level),
    );
  }

  static String systemName(int level) {
    switch (level) {
      case 0:
        return 'Sin sostenimiento inmediato, solo para fines educativos';
      case 1:
        return 'Pernos de roca puntuales';
      case 2:
        return 'Pernos de roca sistemáticos';
      case 3:
        return 'Pernos de roca más malla metálica';
      case 4:
        return 'Pernos de roca más shotcrete';
      default:
        return 'Pernos, shotcrete reforzado y cerchas metálicas';
    }
  }

  static List<String> elementsFor(int level) {
    switch (level) {
      case 0:
        return <String>[
          'Desatado de rocas y control visual del techo',
          'Mapeo geomecánico de verificación',
        ];
      case 1:
        return <String>[
          'Pernos puntuales en bloques identificados',
          'Desatado sistemático antes de cada ciclo',
        ];
      case 2:
        return <String>[
          'Pernos sistemáticos en malla de 1.5 a 2.0 m',
          'Longitud del perno del orden de un tercio de la luz',
        ];
      case 3:
        return <String>[
          'Pernos sistemáticos en malla de 1.2 a 1.5 m',
          'Malla metálica en techo y hastiales expuestos',
        ];
      case 4:
        return <String>[
          'Pernos sistemáticos en malla de 1.0 a 1.5 m',
          'Shotcrete de 50 a 100 mm aplicado tras la voladura',
        ];
      default:
        return <String>[
          'Shotcrete reforzado con fibra de 100 a 150 mm',
          'Cerchas metálicas o marcos espaciados según avance',
          'Sostenimiento inmediato y control de convergencia',
        ];
    }
  }

  static RiskLevel _risk(int level) {
    if (level <= 1) return RiskLevel.low;
    if (level <= 3) return RiskLevel.medium;
    return RiskLevel.high;
  }

  static SupportConfidence _confidence(SupportQuery query) {
    final double rmrFromQ = QCalculator.equivalentRmr(query.q);
    final double gap = (rmrFromQ - query.rmr).abs();

    if (query.spanM > 15) return SupportConfidence.low;
    if (query.q < 0.01 || query.q > 400) return SupportConfidence.low;
    if (gap <= 8) return SupportConfidence.high;
    if (gap <= 15) return SupportConfidence.medium;
    return SupportConfidence.low;
  }

  static String _confidenceReason(
    SupportQuery query,
    SupportConfidence confidence,
  ) {
    final double rmrFromQ = QCalculator.equivalentRmr(query.q);
    final String comparison =
        'El RMR ingresado es ${query.rmr} y el RMR equivalente estimado a '
        'partir de Q es ${rmrFromQ.toStringAsFixed(0)}.';

    switch (confidence) {
      case SupportConfidence.high:
        return '$comparison Ambas clasificaciones son consistentes, por lo '
            'que la recomendación preliminar es más confiable.';
      case SupportConfidence.medium:
        return '$comparison Existe una diferencia moderada entre ambas '
            'clasificaciones; conviene revisar los datos de campo.';
      case SupportConfidence.low:
        return '$comparison La diferencia es grande o el escenario está '
            'fuera del rango habitual de las tablas; la recomendación debe '
            'tomarse solo como ejercicio de análisis.';
    }
  }

  static String _justification(
    SupportQuery query,
    int level,
    int base,
    int qMod,
    int spanMod,
  ) {
    final StringBuffer buffer = StringBuffer();
    buffer.write(
      'La clase del macizo según el RMR de ${query.rmr} aporta una '
      'exigencia base de $base. ',
    );
    if (qMod > 0) {
      buffer.write(
        'El índice Q bajo indica bloques pequeños o discontinuidades '
        'alteradas y aumenta la exigencia en $qMod. ',
      );
    } else if (qMod < 0) {
      buffer.write(
        'El índice Q alto indica un macizo competente y reduce la '
        'exigencia en ${qMod.abs()}. ',
      );
    } else {
      buffer.write('El índice Q no modifica la exigencia base. ');
    }
    if (spanMod > 0) {
      buffer.write(
        'La luz de ${query.spanM.toStringAsFixed(1)} m aumenta el área '
        'expuesta del techo y suma $spanMod. ',
      );
    } else {
      buffer.write(
        'La luz de ${query.spanM.toStringAsFixed(1)} m se mantiene en un '
        'rango manejable. ',
      );
    }
    buffer.write(
      'El tipo de labor (${query.excavationType.label}) y el riesgo '
      'operativo ${query.risk.label.toLowerCase()} completan un nivel de '
      'exigencia $level.',
    );
    return buffer.toString();
  }
}
