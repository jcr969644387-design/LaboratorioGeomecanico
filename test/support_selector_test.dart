import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_geomecanico/calculators/support_selector.dart';
import 'package:laboratorio_geomecanico/models/risk_level.dart';
import 'package:laboratorio_geomecanico/models/support_recommendation.dart';

void main() {
  group('Exigencia base y modificadores', () {
    test('la exigencia base depende de la clase RMR', () {
      expect(SupportSelector.baseDemandFromRmr(90), 0);
      expect(SupportSelector.baseDemandFromRmr(70), 1);
      expect(SupportSelector.baseDemandFromRmr(50), 2);
      expect(SupportSelector.baseDemandFromRmr(30), 3);
      expect(SupportSelector.baseDemandFromRmr(10), 4);
    });

    test('el índice Q corrige la exigencia', () {
      expect(SupportSelector.qModifier(0.05), 2);
      expect(SupportSelector.qModifier(0.5), 1);
      expect(SupportSelector.qModifier(5), 0);
      expect(SupportSelector.qModifier(60), -1);
    });

    test('la luz de la excavación incrementa la exigencia', () {
      expect(SupportSelector.spanModifier(3), 0);
      expect(SupportSelector.spanModifier(7), 1);
      expect(SupportSelector.spanModifier(12), 2);
    });
  });

  group('Selección básica de sostenimiento', () {
    test('no exige sostenimiento sistemático en roca muy buena', () {
      const SupportQuery query = SupportQuery(
        rmr: 90,
        q: 50,
        excavationType: ExcavationType.developmentDrift,
        spanM: 3,
        risk: OperationalRisk.low,
      );

      final SupportRecommendation result = SupportSelector.select(query);

      expect(result.level, 0);
      expect(result.risk, RiskLevel.low);
      expect(result.system.contains('Sin sostenimiento'), isTrue);
    });

    test('recomienda pernos sistemáticos en roca regular', () {
      const SupportQuery query = SupportQuery(
        rmr: 50,
        q: 5,
        excavationType: ExcavationType.developmentDrift,
        spanM: 4,
        risk: OperationalRisk.medium,
      );

      final SupportRecommendation result = SupportSelector.select(query);

      expect(result.level, 2);
      expect(result.system, 'Pernos de roca sistemáticos');
    });

    test('escala hasta cerchas metálicas en el peor escenario', () {
      const SupportQuery query = SupportQuery(
        rmr: 25,
        q: 0.4,
        excavationType: ExcavationType.ramp,
        spanM: 6,
        risk: OperationalRisk.high,
      );

      final SupportRecommendation result = SupportSelector.select(query);

      expect(result.level, 5);
      expect(result.risk, RiskLevel.high);
      expect(result.elements.isNotEmpty, isTrue);
    });

    test('baja la confianza cuando el RMR y el Q son inconsistentes', () {
      const SupportQuery consistent = SupportQuery(
        rmr: 44,
        q: 1,
        excavationType: ExcavationType.developmentDrift,
        spanM: 4,
        risk: OperationalRisk.medium,
      );
      const SupportQuery inconsistent = SupportQuery(
        rmr: 90,
        q: 0.5,
        excavationType: ExcavationType.developmentDrift,
        spanM: 4,
        risk: OperationalRisk.medium,
      );

      expect(
        SupportSelector.select(consistent).confidence,
        SupportConfidence.high,
      );
      expect(
        SupportSelector.select(inconsistent).confidence,
        SupportConfidence.low,
      );
    });

    test('rechaza entradas fuera de rango', () {
      expect(() => SupportSelector.baseDemandFromRmr(120), throwsArgumentError);
      expect(() => SupportSelector.qModifier(0), throwsArgumentError);
      expect(() => SupportSelector.spanModifier(-2), throwsArgumentError);
    });
  });
}
