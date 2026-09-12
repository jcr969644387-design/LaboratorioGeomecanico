import 'risk_level.dart';

/// Tipo de excavación subterránea considerada en el análisis.
enum ExcavationType { developmentDrift, productionGallery, chamber, ramp }

/// Nivel de riesgo operativo declarado por el usuario.
enum OperationalRisk { low, medium, high }

/// Confianza de la recomendación preliminar.
enum SupportConfidence { high, medium, low }

extension ExcavationTypeX on ExcavationType {
  String get label {
    switch (this) {
      case ExcavationType.developmentDrift:
        return 'Galería de avance';
      case ExcavationType.productionGallery:
        return 'Labor de producción';
      case ExcavationType.chamber:
        return 'Cámara o sala';
      case ExcavationType.ramp:
        return 'Rampa';
    }
  }

  String get detail {
    switch (this) {
      case ExcavationType.developmentDrift:
        return 'Labor temporal de sección reducida y avance continuo.';
      case ExcavationType.productionGallery:
        return 'Labor expuesta a voladuras repetidas y tránsito de equipo.';
      case ExcavationType.chamber:
        return 'Excavación de gran luz y servicio prolongado.';
      case ExcavationType.ramp:
        return 'Labor permanente de acceso para equipo pesado.';
    }
  }

  /// Exigencia adicional por servicio y exposición de la labor.
  int get demandBonus {
    switch (this) {
      case ExcavationType.developmentDrift:
        return 0;
      case ExcavationType.productionGallery:
        return 1;
      case ExcavationType.chamber:
        return 1;
      case ExcavationType.ramp:
        return 1;
    }
  }
}

extension OperationalRiskX on OperationalRisk {
  String get label {
    switch (this) {
      case OperationalRisk.low:
        return 'Bajo';
      case OperationalRisk.medium:
        return 'Medio';
      case OperationalRisk.high:
        return 'Alto';
    }
  }

  String get detail {
    switch (this) {
      case OperationalRisk.low:
        return 'Labor sin permanencia de personal ni equipo crítico.';
      case OperationalRisk.medium:
        return 'Tránsito habitual de personal durante el turno.';
      case OperationalRisk.high:
        return 'Personal permanente, servicios críticos o labor principal.';
    }
  }

  int get demandBonus {
    switch (this) {
      case OperationalRisk.low:
        return 0;
      case OperationalRisk.medium:
        return 0;
      case OperationalRisk.high:
        return 1;
    }
  }

  RiskLevel get asRiskLevel {
    switch (this) {
      case OperationalRisk.low:
        return RiskLevel.low;
      case OperationalRisk.medium:
        return RiskLevel.medium;
      case OperationalRisk.high:
        return RiskLevel.high;
    }
  }
}

extension SupportConfidenceX on SupportConfidence {
  String get label {
    switch (this) {
      case SupportConfidence.high:
        return 'Alta';
      case SupportConfidence.medium:
        return 'Media';
      case SupportConfidence.low:
        return 'Baja';
    }
  }

  double get ratio {
    switch (this) {
      case SupportConfidence.high:
        return 0.85;
      case SupportConfidence.medium:
        return 0.6;
      case SupportConfidence.low:
        return 0.35;
    }
  }
}

/// Escenario de excavación evaluado por el selector de sostenimiento.
class SupportQuery {
  const SupportQuery({
    required this.rmr,
    required this.q,
    required this.excavationType,
    required this.spanM,
    required this.risk,
  });

  factory SupportQuery.initial() {
    return const SupportQuery(
      rmr: 55,
      q: 2.5,
      excavationType: ExcavationType.developmentDrift,
      spanM: 4,
      risk: OperationalRisk.medium,
    );
  }

  final int rmr;
  final double q;
  final ExcavationType excavationType;
  final double spanM;
  final OperationalRisk risk;

  SupportQuery copyWith({
    int? rmr,
    double? q,
    ExcavationType? excavationType,
    double? spanM,
    OperationalRisk? risk,
  }) {
    return SupportQuery(
      rmr: rmr ?? this.rmr,
      q: q ?? this.q,
      excavationType: excavationType ?? this.excavationType,
      spanM: spanM ?? this.spanM,
      risk: risk ?? this.risk,
    );
  }
}

/// Recomendación preliminar de sostenimiento con fines educativos.
class SupportRecommendation {
  const SupportRecommendation({
    required this.level,
    required this.system,
    required this.elements,
    required this.justification,
    required this.confidence,
    required this.confidenceReason,
    required this.risk,
  });

  /// Nivel de exigencia de 0 (sin sostenimiento) a 5 (cerchas).
  final int level;

  final String system;
  final List<String> elements;
  final String justification;
  final SupportConfidence confidence;
  final String confidenceReason;
  final RiskLevel risk;

  static const String warning =
      'Recomendación preliminar con fines educativos. No constituye un '
      'diseño definitivo de sostenimiento; toda instalación debe ser '
      'evaluada y aprobada por un ingeniero responsable.';
}
