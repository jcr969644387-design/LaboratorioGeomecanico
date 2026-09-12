/// Textos y valores constantes compartidos por toda la aplicación.
class AppInfo {
  const AppInfo._();

  static const String appName = 'Laboratorio Geomecánico';
  static const String version = '1.0.0';

  static const String tagline =
      'Laboratorio virtual de mecánica de rocas aplicada a la estabilidad '
      'de labores subterráneas.';

  static const String description =
      'Experimenta con las propiedades de la roca intacta y del macizo '
      'rocoso, calcula el RMR y el índice Q, y observa cómo esas condiciones '
      'cambian la selección preliminar del sostenimiento.';

  static const String disclaimer =
      'Simulador educativo. No reemplaza un estudio geomecánico profesional, '
      'una inspección en campo ni un diseño de sostenimiento aprobado por un '
      'ingeniero responsable.';

  static const String tablesNote =
      'Las tablas utilizadas son simplificadas para fines educativos y '
      'pueden variar según la metodología adoptada.';

  static const String qContextWarning =
      'El sistema Q fue calibrado para excavaciones subterráneas en roca. '
      'No debe aplicarse fuera de su contexto geomecánico ni extrapolarse a '
      'taludes, suelos o macizos sin datos de campo confiables.';

  static const String courses =
      'Mecánica de Rocas · Geomecánica · Diseño Minero · Seguridad Minera';
}

/// Rangos admitidos por los campos numéricos de la aplicación.
class Limits {
  const Limits._();

  static const double ucsMin = 0.1;
  static const double ucsMax = 400;
  static const double rqdMin = 0;
  static const double rqdMax = 100;
  static const double spacingMin = 0.01;
  static const double spacingMax = 10;
  static const double spanMin = 1;
  static const double spanMax = 30;
}
