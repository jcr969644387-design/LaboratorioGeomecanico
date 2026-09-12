import '../models/q_result.dart';
import '../models/rmr_result.dart';
import '../models/rock_mass_input.dart';
import '../models/support_recommendation.dart';

/// Tipo de mensaje del tutor, usado para el color del panel.
enum TutorTone { info, warning, positive }

/// Mensaje explicativo generado por el tutor geomecánico.
class TutorMessage {
  const TutorMessage({
    required this.title,
    required this.body,
    this.tone = TutorTone.info,
  });

  final String title;
  final String body;
  final TutorTone tone;
}

/// Contexto que recibe el tutor para construir su explicación.
class TutorContext {
  const TutorContext({
    required this.rockMass,
    required this.rmr,
    this.q,
    this.support,
  });

  final RockMassInput rockMass;
  final RmrResult rmr;
  final QResult? q;
  final SupportRecommendation? support;
}

/// Contrato del tutor. La implementación local no usa red; una futura
/// implementación remota podrá consumir una API de IA respetando la misma
/// interfaz sin modificar las pantallas.
abstract class TutorEngine {
  Future<List<TutorMessage>> explain(TutorContext context);
}

/// Tutor local basado en reglas. No realiza llamadas externas ni requiere
/// claves de acceso.
class LocalRuleTutor implements TutorEngine {
  const LocalRuleTutor();

  @override
  Future<List<TutorMessage>> explain(TutorContext context) async {
    return buildMessages(context);
  }

  /// Versión sincrónica usada por la interfaz y por las pruebas.
  List<TutorMessage> buildMessages(TutorContext context) {
    final List<TutorMessage> messages = <TutorMessage>[];
    messages.add(_rmrMessage(context.rmr));
    messages.add(_rqdMessage(context.rockMass));
    messages.add(_jointMessage(context.rockMass));
    final TutorMessage? water = _waterMessage(context.rockMass);
    if (water != null) messages.add(water);
    final QResult? q = context.q;
    if (q != null) messages.add(_qMessage(q));
    final SupportRecommendation? support = context.support;
    if (support != null) messages.add(_supportMessage(support));
    return messages;
  }

  TutorMessage _rmrMessage(RmrResult rmr) {
    final RmrParameterScore weakest = rmr.weakestParameter;
    final int lost = weakest.maxScore - weakest.score;
    final String direction = rmr.finalRmr >= 61 ? 'se mantiene alto' : 'baja';

    return TutorMessage(
      title: '¿Por qué el RMR $direction?',
      tone: rmr.finalRmr >= 61 ? TutorTone.positive : TutorTone.warning,
      body: 'La suma de los cinco parámetros da ${rmr.basicRmr} y el ajuste '
          'por orientación aporta ${rmr.orientationAdjustment}, con lo que '
          'el RMR final es ${rmr.finalRmr} (clase '
          '${rmr.classInfo.roman}). El parámetro que más puntaje pierde es '
          '${weakest.name} (${weakest.value}): deja de sumar $lost puntos '
          'de ${weakest.maxScore}. Si mejoras ese parámetro, el RMR sube y '
          'la exigencia de sostenimiento disminuye.',
    );
  }

  TutorMessage _rqdMessage(RockMassInput input) {
    final String interpretation;
    if (input.rqd > 90) {
      interpretation =
          'un macizo poco fracturado, donde los testigos salen en tramos '
          'largos y los bloques son grandes';
    } else if (input.rqd > 50) {
      interpretation =
          'un macizo fracturado en bloques de tamaño medio, con caída '
          'potencial de cuñas en el techo';
    } else {
      interpretation =
          'un macizo intensamente fracturado, con bloques pequeños y poco '
          'trabados entre sí';
    }

    return TutorMessage(
      title: 'Cómo influye el RQD',
      body: 'El RQD de ${input.rqd.toStringAsFixed(0)} % describe '
          '$interpretation. El RQD mide el porcentaje de testigos sanos '
          'mayores a 10 cm en una corrida de perforación, por lo que es un '
          'indicador directo del tamaño de bloque: a menor RQD, más '
          'superficies libres y mayor probabilidad de desprendimientos.',
    );
  }

  TutorMessage _jointMessage(RockMassInput input) {
    return TutorMessage(
      title: 'Cómo afectan las discontinuidades',
      body: 'Con un espaciamiento de ${input.spacingM.toStringAsFixed(2)} m y '
          'una condición ${input.jointCondition.label.toLowerCase()}, la '
          'resistencia del macizo la controlan las juntas y no la roca '
          'intacta. ${input.jointCondition.detail} Además, la orientación '
          '${input.orientation.label.toLowerCase()} '
          '(${input.orientation.adjustment} puntos) '
          'define si las familias forman cuñas liberadas hacia la labor.',
    );
  }

  TutorMessage? _waterMessage(RockMassInput input) {
    if (input.groundwater == GroundwaterCondition.dry) return null;
    return TutorMessage(
      title: 'Por qué el agua aumenta el riesgo',
      tone: TutorTone.warning,
      body: 'La condición ${input.groundwater.label.toLowerCase()} resta '
          'puntaje porque el agua reduce el esfuerzo efectivo en las '
          'discontinuidades, lava el relleno, ablanda los minerales '
          'arcillosos y agrega presión hidrostática sobre los bloques. El '
          'resultado es menor resistencia al corte y menor tiempo de '
          'autosostenimiento.',
    );
  }

  TutorMessage _qMessage(QResult q) {
    return TutorMessage(
      title: 'Lectura del índice Q',
      body: 'Q vale ${q.q.toStringAsFixed(2)} (${q.classInfo.label}). El '
          'cociente RQD/Jn = ${q.blockSize.toStringAsFixed(2)} representa '
          'el tamaño de bloque, Jr/Ja = '
          '${q.shearStrength.toStringAsFixed(2)} la resistencia al corte '
          'entre bloques y Jw/SRF = '
          '${q.activeStress.toStringAsFixed(2)} el esfuerzo activo. Observa '
          'cuál de los tres cocientes está penalizando el resultado.',
    );
  }

  TutorMessage _supportMessage(SupportRecommendation support) {
    return TutorMessage(
      title: 'Por qué se recomienda ese sostenimiento',
      tone: support.level >= 4 ? TutorTone.warning : TutorTone.info,
      body: '${support.justification} Por eso el sistema preliminar es: '
          '${support.system}. Recuerda que el nivel de confianza es '
          '${support.confidence.label.toLowerCase()} y que se trata de una '
          'referencia educativa, no de un diseño aprobado.',
    );
  }
}

/// Implementación reservada para una versión futura con IA remota.
///
/// El MVP no realiza llamadas a servicios externos ni almacena claves.
/// Cuando se habilite, bastará con inyectar esta clase en lugar de
/// [LocalRuleTutor] a través de [TutorEngineFactory].
class RemoteAiTutor implements TutorEngine {
  const RemoteAiTutor();

  @override
  Future<List<TutorMessage>> explain(TutorContext context) {
    throw UnimplementedError(
      'El tutor remoto con inteligencia artificial no forma parte del MVP.',
    );
  }
}

/// Punto único de creación del tutor.
class TutorEngineFactory {
  const TutorEngineFactory._();

  static TutorEngine create({bool useRemote = false}) {
    if (useRemote) return const RemoteAiTutor();
    return const LocalRuleTutor();
  }
}
