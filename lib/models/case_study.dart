import 'q_result.dart';
import 'rock_mass_input.dart';
import 'support_recommendation.dart';

/// Pregunta guiada dentro de un caso subterráneo.
class CaseQuestion {
  const CaseQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.feedback,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String feedback;
}

/// Caso educativo de una labor subterránea.
class CaseStudy {
  const CaseStudy({
    required this.id,
    required this.title,
    required this.summary,
    required this.geology,
    required this.rockMass,
    required this.qInput,
    required this.excavationType,
    required this.spanM,
    required this.risk,
    required this.questions,
    required this.technicalFeedback,
    required this.wrongChoiceConsequence,
  });

  final String id;
  final String title;
  final String summary;
  final String geology;
  final RockMassInput rockMass;
  final QInput qInput;
  final ExcavationType excavationType;
  final double spanM;
  final OperationalRisk risk;
  final List<CaseQuestion> questions;
  final String technicalFeedback;
  final String wrongChoiceConsequence;

  /// Datos numéricos mostrados en la ficha del caso.
  Map<String, String> get numericData {
    return <String, String>{
      'Resistencia (UCS)': '${rockMass.ucsMpa.toStringAsFixed(0)} MPa',
      'RQD': '${rockMass.rqd.toStringAsFixed(0)} %',
      'Espaciamiento': '${rockMass.spacingM.toStringAsFixed(2)} m',
      'Condición de juntas': rockMass.jointCondition.label,
      'Agua subterránea': rockMass.groundwater.label,
      'Orientación': rockMass.orientation.label,
      'Jn / Jr / Ja': '${qInput.jn} / ${qInput.jr} / ${qInput.ja}',
      'Jw / SRF': '${qInput.jw} / ${qInput.srf}',
      'Tipo de labor': excavationType.label,
      'Luz de excavación': '${spanM.toStringAsFixed(1)} m',
      'Riesgo operativo': risk.label,
    };
  }
}
