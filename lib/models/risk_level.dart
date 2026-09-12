/// Nivel de riesgo geomecánico usado por los indicadores visuales.
enum RiskLevel { low, medium, high }

extension RiskLevelX on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.low:
        return 'Riesgo bajo';
      case RiskLevel.medium:
        return 'Riesgo medio';
      case RiskLevel.high:
        return 'Riesgo alto';
    }
  }

  String get shortLabel {
    switch (this) {
      case RiskLevel.low:
        return 'Bajo';
      case RiskLevel.medium:
        return 'Medio';
      case RiskLevel.high:
        return 'Alto';
    }
  }
}
