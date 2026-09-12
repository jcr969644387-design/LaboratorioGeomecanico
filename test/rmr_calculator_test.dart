import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_geomecanico/calculators/rmr_calculator.dart';
import 'package:laboratorio_geomecanico/models/rmr_result.dart';
import 'package:laboratorio_geomecanico/models/rock_mass_input.dart';

void main() {
  group('Puntajes individuales del RMR', () {
    test('A1 asigna el puntaje según la resistencia uniaxial', () {
      expect(RmrCalculator.ucsScore(300), 15);
      expect(RmrCalculator.ucsScore(180), 12);
      expect(RmrCalculator.ucsScore(80), 7);
      expect(RmrCalculator.ucsScore(30), 4);
      expect(RmrCalculator.ucsScore(10), 2);
      expect(RmrCalculator.ucsScore(2), 1);
      expect(RmrCalculator.ucsScore(0.5), 0);
    });

    test('A2 asigna el puntaje según el RQD', () {
      expect(RmrCalculator.rqdScore(95), 20);
      expect(RmrCalculator.rqdScore(80), 17);
      expect(RmrCalculator.rqdScore(60), 13);
      expect(RmrCalculator.rqdScore(30), 8);
      expect(RmrCalculator.rqdScore(10), 3);
    });

    test('A3 asigna el puntaje según el espaciamiento', () {
      expect(RmrCalculator.spacingScore(2.5), 20);
      expect(RmrCalculator.spacingScore(1.0), 15);
      expect(RmrCalculator.spacingScore(0.4), 10);
      expect(RmrCalculator.spacingScore(0.1), 8);
      expect(RmrCalculator.spacingScore(0.03), 5);
    });
  });

  group('Evaluación completa del RMR', () {
    test('suma los cinco parámetros y aplica el ajuste', () {
      const RockMassInput input = RockMassInput(
        ucsMpa: 80,
        rqd: 65,
        spacingM: 0.4,
        jointCondition: JointCondition.fair,
        groundwater: GroundwaterCondition.damp,
        orientation: JointOrientation.fair,
      );

      final RmrResult result = RmrCalculator.evaluate(input);

      expect(result.scores.length, 5);
      expect(result.basicRmr, 60);
      expect(result.orientationAdjustment, -5);
      expect(result.finalRmr, 55);
      expect(result.classInfo.roman, 'III');
    });

    test('alcanza la clase I en un macizo competente y seco', () {
      const RockMassInput input = RockMassInput(
        ucsMpa: 300,
        rqd: 95,
        spacingM: 3,
        jointCondition: JointCondition.veryGood,
        groundwater: GroundwaterCondition.dry,
        orientation: JointOrientation.veryFavorable,
      );

      final RmrResult result = RmrCalculator.evaluate(input);

      expect(result.basicRmr, 100);
      expect(result.finalRmr, 100);
      expect(result.classInfo.roman, 'I');
    });

    test('acota el resultado a cero cuando el ajuste lo haría negativo', () {
      const RockMassInput input = RockMassInput(
        ucsMpa: 0.5,
        rqd: 5,
        spacingM: 0.02,
        jointCondition: JointCondition.veryPoor,
        groundwater: GroundwaterCondition.flowing,
        orientation: JointOrientation.veryUnfavorable,
      );

      final RmrResult result = RmrCalculator.evaluate(input);

      expect(result.basicRmr, 8);
      expect(result.finalRmr, 0);
      expect(result.classInfo.roman, 'V');
    });

    test('identifica el parámetro con mayor pérdida de puntaje', () {
      const RockMassInput input = RockMassInput(
        ucsMpa: 200,
        rqd: 95,
        spacingM: 3,
        jointCondition: JointCondition.veryPoor,
        groundwater: GroundwaterCondition.dry,
        orientation: JointOrientation.favorable,
      );

      final RmrResult result = RmrCalculator.evaluate(input);

      expect(result.weakestParameter.code, 'A4');
    });
  });
}
