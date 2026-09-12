import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_geomecanico/calculators/rmr_calculator.dart';
import 'package:laboratorio_geomecanico/models/risk_level.dart';
import 'package:laboratorio_geomecanico/models/rmr_result.dart';

void main() {
  group('Clasificación del macizo según el RMR', () {
    test('respeta los cinco rangos de la escala 0 a 100', () {
      expect(RmrClassInfo.fromScore(100).roman, 'I');
      expect(RmrClassInfo.fromScore(81).roman, 'I');
      expect(RmrClassInfo.fromScore(80).roman, 'II');
      expect(RmrClassInfo.fromScore(61).roman, 'II');
      expect(RmrClassInfo.fromScore(60).roman, 'III');
      expect(RmrClassInfo.fromScore(41).roman, 'III');
      expect(RmrClassInfo.fromScore(40).roman, 'IV');
      expect(RmrClassInfo.fromScore(21).roman, 'IV');
      expect(RmrClassInfo.fromScore(20).roman, 'V');
      expect(RmrClassInfo.fromScore(0).roman, 'V');
    });

    test('asigna la calidad y el riesgo esperados', () {
      expect(RmrClassInfo.fromScore(85).quality, 'Roca muy buena');
      expect(RmrClassInfo.fromScore(50).quality, 'Roca regular');
      expect(RmrClassInfo.fromScore(50).risk, RiskLevel.medium);
      expect(RmrClassInfo.fromScore(15).risk, RiskLevel.high);
    });

    test('rechaza puntajes fuera de la escala', () {
      expect(() => RmrClassInfo.fromScore(-1), throwsArgumentError);
      expect(() => RmrClassInfo.fromScore(101), throwsArgumentError);
      expect(() => RmrCalculator.classify(150), throwsArgumentError);
    });
  });
}
