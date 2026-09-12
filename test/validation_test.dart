import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_geomecanico/calculators/q_calculator.dart';
import 'package:laboratorio_geomecanico/calculators/rmr_calculator.dart';
import 'package:laboratorio_geomecanico/models/q_result.dart';
import 'package:laboratorio_geomecanico/models/rock_mass_input.dart';
import 'package:laboratorio_geomecanico/utils/validators.dart';

void main() {
  group('Validación de valores inválidos', () {
    test('el RMR rechaza un RQD fuera de 0 a 100', () {
      const RockMassInput input = RockMassInput(
        ucsMpa: 80,
        rqd: 140,
        spacingM: 0.4,
        jointCondition: JointCondition.fair,
        groundwater: GroundwaterCondition.damp,
        orientation: JointOrientation.fair,
      );

      expect(() => RmrCalculator.evaluate(input), throwsArgumentError);
    });

    test('el RMR rechaza un espaciamiento nulo o negativo', () {
      const RockMassInput input = RockMassInput(
        ucsMpa: 80,
        rqd: 60,
        spacingM: 0,
        jointCondition: JointCondition.fair,
        groundwater: GroundwaterCondition.damp,
        orientation: JointOrientation.fair,
      );

      expect(() => RmrCalculator.evaluate(input), throwsArgumentError);
    });

    test('el sistema Q rechaza factores iguales a cero', () {
      const QInput input = QInput(
        rqd: 60,
        jn: 0,
        jr: 1,
        ja: 1,
        jw: 1,
        srf: 1,
      );

      expect(() => QCalculator.compute(input), throwsArgumentError);
    });

    test('el sistema Q rechaza factores negativos', () {
      const QInput input = QInput(
        rqd: 60,
        jn: 9,
        jr: 1,
        ja: -2,
        jw: 1,
        srf: 1,
      );

      expect(() => QCalculator.evaluate(input), throwsArgumentError);
    });

    test('los validadores de interfaz devuelven mensajes legibles', () {
      expect(Validators.parse('12,5'), 12.5);
      expect(Validators.parse('abc'), isNull);
      expect(Validators.range(50, min: 0, max: 100), isNull);
      expect(Validators.range(150, min: 0, max: 100), isNotNull);
      expect(Validators.range(null, min: 0, max: 100), isNotNull);
    });
  });
}
