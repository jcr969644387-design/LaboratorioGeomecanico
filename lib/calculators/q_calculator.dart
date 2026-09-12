import 'dart:math' as math;

import '../models/q_result.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

/// Calculadora educativa del índice Q de Barton.
class QCalculator {
  const QCalculator._();

  /// Familias de discontinuidades (Jn).
  static const List<QFactorOption> jnOptions = <QFactorOption>[
    QFactorOption(
      label: 'Macizo masivo (0.5 - 1.0)',
      value: 1,
      description: 'Sin discontinuidades o muy escasas.',
    ),
    QFactorOption(
      label: 'Una familia (2)',
      value: 2,
      description: 'Una sola familia de discontinuidades.',
    ),
    QFactorOption(
      label: 'Una familia más aleatorias (3)',
      value: 3,
      description: 'Una familia dominante y juntas aleatorias.',
    ),
    QFactorOption(
      label: 'Dos familias (4)',
      value: 4,
      description: 'Dos familias bien definidas.',
    ),
    QFactorOption(
      label: 'Dos familias más aleatorias (6)',
      value: 6,
      description: 'Dos familias y juntas aleatorias.',
    ),
    QFactorOption(
      label: 'Tres familias (9)',
      value: 9,
      description: 'Tres familias; formación frecuente de bloques.',
    ),
    QFactorOption(
      label: 'Tres familias más aleatorias (12)',
      value: 12,
      description: 'Tres familias y juntas aleatorias.',
    ),
    QFactorOption(
      label: 'Cuatro o más familias (15)',
      value: 15,
      description: 'Macizo muy fracturado, en bloques pequeños.',
    ),
    QFactorOption(
      label: 'Roca triturada (20)',
      value: 20,
      description: 'Macizo desintegrado tipo suelo.',
    ),
  ];

  /// Rugosidad de las discontinuidades (Jr).
  static const List<QFactorOption> jrOptions = <QFactorOption>[
    QFactorOption(
      label: 'Discontinua (4)',
      value: 4,
      description: 'Junta no continua; traba mecánica alta.',
    ),
    QFactorOption(
      label: 'Rugosa u ondulada (3)',
      value: 3,
      description: 'Superficie rugosa e irregular, ondulada.',
    ),
    QFactorOption(
      label: 'Lisa ondulada (2)',
      value: 2,
      description: 'Superficie lisa con ondulación apreciable.',
    ),
    QFactorOption(
      label: 'Rugosa plana (1.5)',
      value: 1.5,
      description: 'Superficie rugosa pero plana.',
    ),
    QFactorOption(
      label: 'Lisa plana (1.0)',
      value: 1,
      description: 'Superficie lisa y plana.',
    ),
    QFactorOption(
      label: 'Espejo de falla plano (0.5)',
      value: 0.5,
      description: 'Superficie pulida; resistencia al corte muy baja.',
    ),
  ];

  /// Alteración o relleno de las discontinuidades (Ja).
  static const List<QFactorOption> jaOptions = <QFactorOption>[
    QFactorOption(
      label: 'Paredes sanas y selladas (0.75)',
      value: 0.75,
      description: 'Relleno duro que impide el movimiento.',
    ),
    QFactorOption(
      label: 'Paredes sanas, sin alteración (1.0)',
      value: 1,
      description: 'Solo pátina superficial.',
    ),
    QFactorOption(
      label: 'Alteración ligera (2.0)',
      value: 2,
      description: 'Paredes ligeramente alteradas, sin arcilla.',
    ),
    QFactorOption(
      label: 'Relleno limoso o arenoso (3.0)',
      value: 3,
      description: 'Relleno friable sin cohesión.',
    ),
    QFactorOption(
      label: 'Relleno arcilloso blando (4.0)',
      value: 4,
      description: 'Arcilla blanda que reduce mucho el corte.',
    ),
    QFactorOption(
      label: 'Relleno arcilloso grueso (8.0)',
      value: 8,
      description: 'Espesor importante de arcilla o milonita.',
    ),
    QFactorOption(
      label: 'Relleno arcilloso expansivo (12.0)',
      value: 12,
      description: 'Arcilla expansiva; condición crítica.',
    ),
  ];

  /// Factor de reducción por agua (Jw).
  static const List<QFactorOption> jwOptions = <QFactorOption>[
    QFactorOption(
      label: 'Seco o goteo mínimo (1.0)',
      value: 1,
      description: 'Sin presión de agua relevante.',
    ),
    QFactorOption(
      label: 'Flujo medio (0.66)',
      value: 0.66,
      description: 'Lavado ocasional del relleno de juntas.',
    ),
    QFactorOption(
      label: 'Flujo importante en roca competente (0.5)',
      value: 0.5,
      description: 'Presión de agua apreciable.',
    ),
    QFactorOption(
      label: 'Flujo importante con lavado (0.33)',
      value: 0.33,
      description: 'Arrastre de relleno de discontinuidades.',
    ),
    QFactorOption(
      label: 'Flujo excepcional decreciente (0.2)',
      value: 0.2,
      description: 'Ingreso fuerte que disminuye con el tiempo.',
    ),
    QFactorOption(
      label: 'Flujo excepcional permanente (0.1)',
      value: 0.1,
      description: 'Ingreso severo y sostenido de agua.',
    ),
  ];

  /// Factor de reducción por esfuerzos (SRF).
  static const List<QFactorOption> srfOptions = <QFactorOption>[
    QFactorOption(
      label: 'Esfuerzos favorables (1.0)',
      value: 1,
      description: 'Relación esfuerzo/resistencia media.',
    ),
    QFactorOption(
      label: 'Esfuerzos bajos, cerca de superficie (2.5)',
      value: 2.5,
      description: 'Macizo poco confinado, juntas abiertas.',
    ),
    QFactorOption(
      label: 'Zona de corte aislada (5.0)',
      value: 5,
      description: 'Zona débil o falla que cruza la labor.',
    ),
    QFactorOption(
      label: 'Varias zonas de corte (7.5)',
      value: 7.5,
      description: 'Macizo alterado con fallas múltiples.',
    ),
    QFactorOption(
      label: 'Esfuerzos altos, estallido leve (10.0)',
      value: 10,
      description: 'Alta relación esfuerzo/resistencia.',
    ),
    QFactorOption(
      label: 'Roca fluyente o expansiva (15.0)',
      value: 15,
      description: 'Comportamiento plástico o expansivo.',
    ),
  ];

  static void _validate(QInput input) {
    Validators.ensureRange(
      input.rqd,
      Limits.rqdMin,
      Limits.rqdMax,
      'El RQD',
    );
    Validators.ensurePositive(input.jn, 'Jn');
    Validators.ensurePositive(input.jr, 'Jr');
    Validators.ensurePositive(input.ja, 'Ja');
    Validators.ensurePositive(input.jw, 'Jw');
    Validators.ensurePositive(input.srf, 'SRF');
  }

  /// Valor numérico de Q. El RQD menor a 10 se lleva a 10 por convención.
  static double compute(QInput input) {
    _validate(input);
    final double rqd = input.rqd < 10 ? 10 : input.rqd;
    final double blockSize = rqd / input.jn;
    final double shearStrength = input.jr / input.ja;
    final double activeStress = input.jw / input.srf;
    return blockSize * shearStrength * activeStress;
  }

  /// Cálculo completo con los tres cocientes intermedios.
  static QResult evaluate(QInput input) {
    _validate(input);
    final double rqd = input.rqd < 10 ? 10 : input.rqd;
    final double blockSize = rqd / input.jn;
    final double shearStrength = input.jr / input.ja;
    final double activeStress = input.jw / input.srf;
    final double q = blockSize * shearStrength * activeStress;

    return QResult(
      input: input,
      q: q,
      blockSize: blockSize,
      shearStrength: shearStrength,
      activeStress: activeStress,
    );
  }

  static QClassInfo classify(double q) {
    return QClassInfo.fromValue(q);
  }

  /// Correlación educativa de Bieniawski: RMR aproximado a partir de Q.
  static double equivalentRmr(double q) {
    if (q.isNaN || q.isInfinite || q <= 0) {
      throw ArgumentError('El índice Q debe ser un número positivo.');
    }
    final double value = 9 * math.log(q) + 44;
    if (value < 0) return 0;
    if (value > 100) return 100;
    return value;
  }
}
