import '../utils/constants.dart';
import '../utils/validators.dart';

/// Condición de las discontinuidades (parámetro A4 del RMR).
enum JointCondition { veryGood, good, fair, poor, veryPoor }

/// Presencia de agua subterránea (parámetro A5 del RMR).
enum GroundwaterCondition { dry, damp, wet, dripping, flowing }

/// Orientación de las discontinuidades respecto a la labor (ajuste B).
enum JointOrientation {
  veryFavorable,
  favorable,
  fair,
  unfavorable,
  veryUnfavorable,
}

extension JointConditionX on JointCondition {
  String get label {
    switch (this) {
      case JointCondition.veryGood:
        return 'Muy buena';
      case JointCondition.good:
        return 'Buena';
      case JointCondition.fair:
        return 'Regular';
      case JointCondition.poor:
        return 'Mala';
      case JointCondition.veryPoor:
        return 'Muy mala';
    }
  }

  String get detail {
    switch (this) {
      case JointCondition.veryGood:
        return 'Superficies muy rugosas, discontinuas, sin separación y '
            'sin alteración de las paredes.';
      case JointCondition.good:
        return 'Superficies rugosas, separación menor a 1 mm, paredes '
            'ligeramente alteradas.';
      case JointCondition.fair:
        return 'Superficies ligeramente rugosas, separación menor a 1 mm, '
            'paredes muy alteradas.';
      case JointCondition.poor:
        return 'Superficies pulidas o relleno blando menor a 5 mm, '
            'separación de 1 a 5 mm, continuas.';
      case JointCondition.veryPoor:
        return 'Relleno blando mayor a 5 mm o separación mayor a 5 mm, '
            'discontinuidades continuas.';
    }
  }

  /// Puntaje A4 de la tabla simplificada del RMR.
  int get rating {
    switch (this) {
      case JointCondition.veryGood:
        return 30;
      case JointCondition.good:
        return 25;
      case JointCondition.fair:
        return 20;
      case JointCondition.poor:
        return 10;
      case JointCondition.veryPoor:
        return 0;
    }
  }
}

extension GroundwaterConditionX on GroundwaterCondition {
  String get label {
    switch (this) {
      case GroundwaterCondition.dry:
        return 'Seco';
      case GroundwaterCondition.damp:
        return 'Húmedo';
      case GroundwaterCondition.wet:
        return 'Mojado';
      case GroundwaterCondition.dripping:
        return 'Goteo';
      case GroundwaterCondition.flowing:
        return 'Flujo continuo';
    }
  }

  String get detail {
    switch (this) {
      case GroundwaterCondition.dry:
        return 'Labor completamente seca; sin evidencia de infiltración.';
      case GroundwaterCondition.damp:
        return 'Humedad en las paredes, sin agua libre.';
      case GroundwaterCondition.wet:
        return 'Agua libre en las discontinuidades, sin goteo apreciable.';
      case GroundwaterCondition.dripping:
        return 'Goteo visible desde el techo o las cajas.';
      case GroundwaterCondition.flowing:
        return 'Flujo continuo de agua hacia la labor.';
    }
  }

  /// Puntaje A5 de la tabla simplificada del RMR.
  int get rating {
    switch (this) {
      case GroundwaterCondition.dry:
        return 15;
      case GroundwaterCondition.damp:
        return 10;
      case GroundwaterCondition.wet:
        return 7;
      case GroundwaterCondition.dripping:
        return 4;
      case GroundwaterCondition.flowing:
        return 0;
    }
  }
}

extension JointOrientationX on JointOrientation {
  String get label {
    switch (this) {
      case JointOrientation.veryFavorable:
        return 'Muy favorable';
      case JointOrientation.favorable:
        return 'Favorable';
      case JointOrientation.fair:
        return 'Regular';
      case JointOrientation.unfavorable:
        return 'Desfavorable';
      case JointOrientation.veryUnfavorable:
        return 'Muy desfavorable';
    }
  }

  String get detail {
    switch (this) {
      case JointOrientation.veryFavorable:
        return 'Las discontinuidades se cruzan con el eje de la labor y no '
            'forman bloques liberados.';
      case JointOrientation.favorable:
        return 'Orientación poco propicia a la formación de cuñas.';
      case JointOrientation.fair:
        return 'Algunas familias pueden formar bloques en el techo.';
      case JointOrientation.unfavorable:
        return 'Familias subparalelas al eje que favorecen cuñas y '
            'desprendimientos.';
      case JointOrientation.veryUnfavorable:
        return 'Familias paralelas al eje con buzamiento hacia la labor; '
            'alta probabilidad de caída de rocas.';
    }
  }

  /// Ajuste B por orientación, negativo o nulo, para túneles y galerías.
  int get adjustment {
    switch (this) {
      case JointOrientation.veryFavorable:
        return 0;
      case JointOrientation.favorable:
        return -2;
      case JointOrientation.fair:
        return -5;
      case JointOrientation.unfavorable:
        return -10;
      case JointOrientation.veryUnfavorable:
        return -12;
    }
  }
}

/// Conjunto de propiedades del macizo rocoso ingresadas por el estudiante.
class RockMassInput {
  const RockMassInput({
    required this.ucsMpa,
    required this.rqd,
    required this.spacingM,
    required this.jointCondition,
    required this.groundwater,
    required this.orientation,
    this.generalState = '',
  });

  factory RockMassInput.initial() {
    return const RockMassInput(
      ucsMpa: 80,
      rqd: 65,
      spacingM: 0.4,
      jointCondition: JointCondition.fair,
      groundwater: GroundwaterCondition.damp,
      orientation: JointOrientation.fair,
      generalState: 'Macizo fracturado en bloques, sin alteración severa.',
    );
  }

  /// Resistencia a la compresión uniaxial de la roca intacta, en MPa.
  final double ucsMpa;

  /// Rock Quality Designation, en porcentaje.
  final double rqd;

  /// Espaciamiento medio entre discontinuidades, en metros.
  final double spacingM;

  final JointCondition jointCondition;
  final GroundwaterCondition groundwater;
  final JointOrientation orientation;

  /// Observación cualitativa del estado general del macizo.
  final String generalState;

  RockMassInput copyWith({
    double? ucsMpa,
    double? rqd,
    double? spacingM,
    JointCondition? jointCondition,
    GroundwaterCondition? groundwater,
    JointOrientation? orientation,
    String? generalState,
  }) {
    return RockMassInput(
      ucsMpa: ucsMpa ?? this.ucsMpa,
      rqd: rqd ?? this.rqd,
      spacingM: spacingM ?? this.spacingM,
      jointCondition: jointCondition ?? this.jointCondition,
      groundwater: groundwater ?? this.groundwater,
      orientation: orientation ?? this.orientation,
      generalState: generalState ?? this.generalState,
    );
  }

  /// Lanza [ArgumentError] cuando algún valor está fuera de rango físico.
  void validate() {
    Validators.ensureRange(
      ucsMpa,
      Limits.ucsMin,
      Limits.ucsMax,
      'La resistencia a compresión uniaxial',
    );
    Validators.ensureRange(rqd, Limits.rqdMin, Limits.rqdMax, 'El RQD');
    Validators.ensureRange(
      spacingM,
      Limits.spacingMin,
      Limits.spacingMax,
      'El espaciamiento',
    );
  }
}
