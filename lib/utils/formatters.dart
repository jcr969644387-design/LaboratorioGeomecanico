/// Utilidades de formato numérico para la interfaz.
class Fmt {
  const Fmt._();

  static String decimal(double value, {int digits = 2}) {
    if (value.isNaN || value.isInfinite) return '—';
    return value.toStringAsFixed(digits);
  }

  /// Ajusta la cantidad de decimales al orden de magnitud del valor.
  static String smart(double value) {
    if (value.isNaN || value.isInfinite) return '—';
    final double absolute = value.abs();
    if (absolute >= 100) return value.toStringAsFixed(0);
    if (absolute >= 10) return value.toStringAsFixed(1);
    if (absolute >= 1) return value.toStringAsFixed(2);
    if (absolute >= 0.01) return value.toStringAsFixed(3);
    return value.toStringAsExponential(2);
  }

  static String signed(int value) {
    if (value > 0) return '+$value';
    return '$value';
  }

  static String percent(double value) {
    return '${value.toStringAsFixed(0)} %';
  }
}
