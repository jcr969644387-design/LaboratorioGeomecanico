import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_geomecanico/calculators/q_calculator.dart';
import 'package:laboratorio_geomecanico/models/q_result.dart';
import 'package:laboratorio_geomecanico/models/risk_level.dart';

void main() {
  group('Clasificación cualitativa del macizo con el sistema Q', () {
    test('asigna la categoría correspondiente a cada rango', () {
      expect(QClassInfo.fromValue(500).label, 'Excepcionalmente buena');
      expect(QClassInfo.fromValue(200).label, 'Extremadamente buena');
      expect(QClassInfo.fromValue(60).label, 'Muy buena');
      expect(QClassInfo.fromValue(20).label, 'Buena');
      expect(QClassInfo.fromValue(6).label, 'Regular');
      expect(QClassInfo.fromValue(2).label, 'Mala');
      expect(QClassInfo.fromValue(0.5).label, 'Muy mala');
      expect(QClassInfo.fromValue(0.05).label, 'Extremadamente mala');
      expect(QClassInfo.fromValue(0.005).label, 'Excepcionalmente mala');
    });

    test('asocia el nivel de riesgo esperado', () {
      expect(QCalculator.classify(50).risk, RiskLevel.low);
      expect(QCalculator.classify(5).risk, RiskLevel.medium);
      expect(QCalculator.classify(0.2).risk, RiskLevel.high);
    });

    test('rechaza valores no positivos', () {
      expect(() => QClassInfo.fromValue(0), throwsArgumentError);
      expect(() => QClassInfo.fromValue(-3), throwsArgumentError);
    });
  });
}
