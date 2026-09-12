import '../models/rmr_result.dart';
import '../models/rock_mass_input.dart';

/// Calculadora educativa del Rock Mass Rating (Bieniawski, versión
/// simplificada para enseñanza).
class RmrCalculator {
  const RmrCalculator._();

  /// A1: resistencia a la compresión uniaxial de la roca intacta, en MPa.
  static int ucsScore(double ucsMpa) {
    if (ucsMpa > 250) return 15;
    if (ucsMpa > 100) return 12;
    if (ucsMpa > 50) return 7;
    if (ucsMpa > 25) return 4;
    if (ucsMpa > 5) return 2;
    if (ucsMpa > 1) return 1;
    return 0;
  }

  /// A2: Rock Quality Designation, en porcentaje.
  static int rqdScore(double rqd) {
    if (rqd > 90) return 20;
    if (rqd > 75) return 17;
    if (rqd > 50) return 13;
    if (rqd > 25) return 8;
    return 3;
  }

  /// A3: espaciamiento medio entre discontinuidades, en metros.
  static int spacingScore(double spacingM) {
    if (spacingM > 2) return 20;
    if (spacingM > 0.6) return 15;
    if (spacingM > 0.2) return 10;
    if (spacingM > 0.06) return 8;
    return 5;
  }

  /// Evalúa el macizo y devuelve el detalle completo del cálculo.
  static RmrResult evaluate(RockMassInput input) {
    input.validate();

    final int a1 = ucsScore(input.ucsMpa);
    final int a2 = rqdScore(input.rqd);
    final int a3 = spacingScore(input.spacingM);
    final int a4 = input.jointCondition.rating;
    final int a5 = input.groundwater.rating;
    final int adjustment = input.orientation.adjustment;

    final List<RmrParameterScore> scores = <RmrParameterScore>[
      RmrParameterScore(
        code: 'A1',
        name: 'Resistencia a compresión uniaxial',
        value: '${input.ucsMpa.toStringAsFixed(1)} MPa',
        score: a1,
        maxScore: 15,
      ),
      RmrParameterScore(
        code: 'A2',
        name: 'RQD',
        value: '${input.rqd.toStringAsFixed(0)} %',
        score: a2,
        maxScore: 20,
      ),
      RmrParameterScore(
        code: 'A3',
        name: 'Espaciamiento de discontinuidades',
        value: '${input.spacingM.toStringAsFixed(2)} m',
        score: a3,
        maxScore: 20,
      ),
      RmrParameterScore(
        code: 'A4',
        name: 'Condición de discontinuidades',
        value: input.jointCondition.label,
        score: a4,
        maxScore: 30,
      ),
      RmrParameterScore(
        code: 'A5',
        name: 'Agua subterránea',
        value: input.groundwater.label,
        score: a5,
        maxScore: 15,
      ),
    ];

    final int basic = a1 + a2 + a3 + a4 + a5;
    final int raw = basic + adjustment;
    final int finalRmr = raw.clamp(0, 100);

    return RmrResult(
      scores: scores,
      basicRmr: basic,
      orientationAdjustment: adjustment,
      finalRmr: finalRmr,
    );
  }

  /// Clasificación directa a partir de un puntaje RMR.
  static RmrClassInfo classify(int rmr) {
    return RmrClassInfo.fromScore(rmr);
  }
}
