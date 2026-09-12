import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_geomecanico/calculators/q_calculator.dart';
import 'package:laboratorio_geomecanico/models/q_result.dart';

void main() {
  group('Cálculo del índice Q', () {
    test('aplica la fórmula (RQD/Jn) x (Jr/Ja) x (Jw/SRF)', () {
      const QInput input = QInput(
        rqd: 100,
        jn: 10,
        jr: 2,
        ja: 1,
        jw: 1,
        srf: 1,
      );

      expect(QCalculator.compute(input), closeTo(20, 0.0001));
    });

    test('devuelve los tres cocientes intermedios', () {
      const QInput input = QInput(
        rqd: 90,
        jn: 9,
        jr: 1.5,
        ja: 3,
        jw: 0.5,
        srf: 2.5,
      );

      final QResult result = QCalculator.evaluate(input);

      expect(result.blockSize, closeTo(10, 0.0001));
      expect(result.shearStrength, closeTo(0.5, 0.0001));
      expect(result.activeStress, closeTo(0.2, 0.0001));
      expect(result.q, closeTo(1.0, 0.0001));
    });

    test('usa RQD igual a 10 cuando el valor ingresado es menor', () {
      const QInput input = QInput(
        rqd: 4,
        jn: 10,
        jr: 1,
        ja: 1,
        jw: 1,
        srf: 1,
      );

      expect(QCalculator.compute(input), closeTo(1.0, 0.0001));
    });

    test('estima el RMR equivalente con la correlación de Bieniawski', () {
      expect(QCalculator.equivalentRmr(1), closeTo(44, 0.0001));
      expect(QCalculator.equivalentRmr(20), closeTo(70.96, 0.05));
    });
  });
}
