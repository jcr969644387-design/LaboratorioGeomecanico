import 'risk_level.dart';

/// Opción tabulada de un factor del sistema Q.
class QFactorOption {
  const QFactorOption({
    required this.label,
    required this.value,
    required this.description,
  });

  final String label;
  final double value;
  final String description;
}

/// Parámetros de entrada del sistema Q de Barton.
class QInput {
  const QInput({
    required this.rqd,
    required this.jn,
    required this.jr,
    required this.ja,
    required this.jw,
    required this.srf,
  });

  factory QInput.initial() {
    return const QInput(rqd: 65, jn: 9, jr: 1.5, ja: 2, jw: 1, srf: 1);
  }

  final double rqd;
  final double jn;
  final double jr;
  final double ja;
  final double jw;
  final double srf;

  QInput copyWith({
    double? rqd,
    double? jn,
    double? jr,
    double? ja,
    double? jw,
    double? srf,
  }) {
    return QInput(
      rqd: rqd ?? this.rqd,
      jn: jn ?? this.jn,
      jr: jr ?? this.jr,
      ja: ja ?? this.ja,
      jw: jw ?? this.jw,
      srf: srf ?? this.srf,
    );
  }
}

/// Categoría cualitativa del macizo según el valor de Q.
class QClassInfo {
  const QClassInfo({
    required this.label,
    required this.rangeLabel,
    required this.description,
    required this.risk,
  });

  final String label;
  final String rangeLabel;
  final String description;
  final RiskLevel risk;

  static QClassInfo fromValue(double q) {
    if (q.isNaN || q.isInfinite || q <= 0) {
      throw ArgumentError('El índice Q debe ser un número positivo.');
    }
    if (q >= 400) {
      return const QClassInfo(
        label: 'Excepcionalmente buena',
        rangeLabel: 'Q 400-1000',
        risk: RiskLevel.low,
        description: 'Macizo masivo, prácticamente sin fracturamiento.',
      );
    }
    if (q >= 100) {
      return const QClassInfo(
        label: 'Extremadamente buena',
        rangeLabel: 'Q 100-400',
        risk: RiskLevel.low,
        description: 'Macizo muy competente con discontinuidades cerradas.',
      );
    }
    if (q >= 40) {
      return const QClassInfo(
        label: 'Muy buena',
        rangeLabel: 'Q 40-100',
        risk: RiskLevel.low,
        description: 'Macizo competente; sostenimiento mínimo o puntual.',
      );
    }
    if (q >= 10) {
      return const QClassInfo(
        label: 'Buena',
        rangeLabel: 'Q 10-40',
        risk: RiskLevel.low,
        description: 'Fracturamiento moderado; bloques bien trabados.',
      );
    }
    if (q >= 4) {
      return const QClassInfo(
        label: 'Regular',
        rangeLabel: 'Q 4-10',
        risk: RiskLevel.medium,
        description: 'Macizo en bloques; requiere control sistemático.',
      );
    }
    if (q >= 1) {
      return const QClassInfo(
        label: 'Mala',
        rangeLabel: 'Q 1-4',
        risk: RiskLevel.medium,
        description: 'Varias familias de discontinuidades con alteración.',
      );
    }
    if (q >= 0.1) {
      return const QClassInfo(
        label: 'Muy mala',
        rangeLabel: 'Q 0.1-1',
        risk: RiskLevel.high,
        description: 'Macizo muy fracturado, alterado o con agua.',
      );
    }
    if (q >= 0.01) {
      return const QClassInfo(
        label: 'Extremadamente mala',
        rangeLabel: 'Q 0.01-0.1',
        risk: RiskLevel.high,
        description: 'Macizo triturado con relleno arcilloso.',
      );
    }
    return const QClassInfo(
      label: 'Excepcionalmente mala',
      rangeLabel: 'Q 0.001-0.01',
      risk: RiskLevel.high,
      description: 'Condición de roca fluyente o expansiva.',
    );
  }
}

/// Resultado del cálculo del índice Q con sus cocientes intermedios.
class QResult {
  const QResult({
    required this.input,
    required this.q,
    required this.blockSize,
    required this.shearStrength,
    required this.activeStress,
  });

  final QInput input;

  /// Valor final del índice Q.
  final double q;

  /// Cociente RQD/Jn, asociado al tamaño de bloque.
  final double blockSize;

  /// Cociente Jr/Ja, asociado a la resistencia al corte entre bloques.
  final double shearStrength;

  /// Cociente Jw/SRF, asociado al esfuerzo activo.
  final double activeStress;

  QClassInfo get classInfo => QClassInfo.fromValue(q);

  RiskLevel get risk => classInfo.risk;

  static const String formula = 'Q = (RQD / Jn) x (Jr / Ja) x (Jw / SRF)';
}
