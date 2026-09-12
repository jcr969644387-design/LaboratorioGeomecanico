/// Validaciones de entrada y de dominio.
///
/// Las calculadoras usan [ensureRange] para rechazar valores imposibles y
/// la interfaz usa [range] para mostrar mensajes comprensibles.
class Validators {
  const Validators._();

  static double? parse(String text) {
    final String clean = text.trim().replaceAll(',', '.');
    if (clean.isEmpty) return null;
    return double.tryParse(clean);
  }

  static String? range(
    double? value, {
    required double min,
    required double max,
    String unit = '',
  }) {
    if (value == null || value.isNaN) {
      return 'Ingresa un número válido.';
    }
    if (value < min || value > max) {
      final String suffix = unit.isEmpty ? '' : ' $unit';
      return 'Debe estar entre $min y $max$suffix.';
    }
    return null;
  }

  static void ensureRange(
    double value,
    double min,
    double max,
    String name,
  ) {
    if (value.isNaN || value.isInfinite) {
      throw ArgumentError('$name no es un número válido.');
    }
    if (value < min || value > max) {
      throw ArgumentError('$name debe estar entre $min y $max.');
    }
  }

  static void ensurePositive(double value, String name) {
    if (value.isNaN || value.isInfinite || value <= 0) {
      throw ArgumentError('$name debe ser mayor que cero.');
    }
  }
}
