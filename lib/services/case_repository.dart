import '../models/case_study.dart';
import '../models/q_result.dart';
import '../models/rock_mass_input.dart';
import '../models/support_recommendation.dart';

/// Catálogo local de casos subterráneos educativos.
class CaseRepository {
  const CaseRepository();

  List<CaseStudy> all() {
    return <CaseStudy>[
      _veryGoodRock(),
      _fairRock(),
      _poorRock(),
      _waterCase(),
      _unfavorableJoints(),
    ];
  }

  CaseStudy _veryGoodRock() {
    return CaseStudy(
      id: 'caso-01',
      title: 'Labor en roca muy buena',
      summary: 'Galería de avance en un cuerpo intrusivo fresco, sin evidencia '
          'de agua.',
      geology: 'Granodiorita masiva, poco alterada, con dos familias de '
          'discontinuidades cerradas y rugosas. Las paredes se mantienen '
          'estables varios días después de la voladura.',
      rockMass: const RockMassInput(
        ucsMpa: 180,
        rqd: 92,
        spacingM: 2.5,
        jointCondition: JointCondition.veryGood,
        groundwater: GroundwaterCondition.dry,
        orientation: JointOrientation.favorable,
        generalState: 'Macizo competente, autosoportante en luces cortas.',
      ),
      qInput: const QInput(rqd: 92, jn: 4, jr: 3, ja: 1, jw: 1, srf: 1),
      excavationType: ExcavationType.developmentDrift,
      spanM: 4,
      risk: OperationalRisk.low,
      questions: <CaseQuestion>[
        CaseQuestion(
          prompt: '¿Qué clase de macizo esperas obtener con el RMR?',
          options: <String>['Clase I', 'Clase III', 'Clase V'],
          correctIndex: 0,
          feedback:
              'Resistencia alta, RQD mayor a 90 %, espaciamiento amplio y '
              'ausencia de agua suman casi el puntaje máximo.',
        ),
        CaseQuestion(
          prompt: '¿Cuál es la decisión preliminar razonable?',
          options: <String>[
            'Cerchas metálicas inmediatas',
            'Desatado y control visual, con pernos puntuales si aparecen '
                'bloques',
            'Shotcrete en toda la sección',
          ],
          correctIndex: 1,
          feedback: 'En clase I el macizo es autosoportante para esta luz; el '
              'control de bloques sueltos sigue siendo obligatorio.',
        ),
      ],
      technicalFeedback:
          'Aun con un RMR alto, el desatado es obligatorio: los accidentes '
          'por caída de rocas también ocurren en macizos competentes cuando '
          'la voladura deja bloques liberados en el techo.',
      wrongChoiceConsequence:
          'Sobredimensionar el sostenimiento en clase I encarece el metro '
          'de avance, retrasa el ciclo minero y no reduce de forma '
          'significativa el riesgo real.',
    );
  }

  CaseStudy _fairRock() {
    return CaseStudy(
      id: 'caso-02',
      title: 'Labor en roca regular',
      summary: 'Labor de producción en roca volcánica fracturada en bloques '
          'medianos.',
      geology: 'Andesita con tres familias de discontinuidades, superficies '
          'ligeramente rugosas y paredes alteradas. Se observa humedad en '
          'las cajas.',
      rockMass: const RockMassInput(
        ucsMpa: 70,
        rqd: 62,
        spacingM: 0.4,
        jointCondition: JointCondition.fair,
        groundwater: GroundwaterCondition.damp,
        orientation: JointOrientation.fair,
        generalState: 'Macizo en bloques con caída potencial de cuñas.',
      ),
      qInput: const QInput(rqd: 62, jn: 9, jr: 1.5, ja: 2, jw: 1, srf: 1),
      excavationType: ExcavationType.productionGallery,
      spanM: 5,
      risk: OperationalRisk.medium,
      questions: <CaseQuestion>[
        CaseQuestion(
          prompt: '¿Qué parámetro está restando más puntaje al RMR?',
          options: <String>[
            'La resistencia de la roca intacta',
            'El espaciamiento y la condición de las discontinuidades',
            'El agua subterránea',
          ],
          correctIndex: 1,
          feedback:
              'Con 0.40 m de espaciamiento y condición regular, el macizo '
              'pierde buena parte de los 50 puntos disponibles en A3 y A4.',
        ),
        CaseQuestion(
          prompt: '¿Qué sostenimiento preliminar es más coherente?',
          options: <String>[
            'Ningún sostenimiento',
            'Pernos sistemáticos, con malla si hay tránsito de personal',
            'Cerchas metálicas en todo el tramo',
          ],
          correctIndex: 1,
          feedback: 'En clase III se controla la formación de cuñas con pernos '
              'sistemáticos; la malla retiene los fragmentos pequeños.',
        ),
      ],
      technicalFeedback:
          'La clase III es la más frecuente en minería y también la más '
          'engañosa: la labor parece estable el primer turno y falla cuando '
          'la voladura siguiente relaja el techo.',
      wrongChoiceConsequence:
          'Omitir el sostenimiento sistemático en clase III suele terminar '
          'en caída de cuñas sobre el equipo de perforación durante el '
          'segundo o tercer ciclo.',
    );
  }

  CaseStudy _poorRock() {
    return CaseStudy(
      id: 'caso-03',
      title: 'Labor en roca mala',
      summary: 'Acceso en zona de falla con macizo muy fracturado.',
      geology: 'Roca intensamente fracturada y alterada, con relleno arcilloso '
          'blando en las discontinuidades y bloques centimétricos.',
      rockMass: const RockMassInput(
        ucsMpa: 30,
        rqd: 30,
        spacingM: 0.08,
        jointCondition: JointCondition.poor,
        groundwater: GroundwaterCondition.wet,
        orientation: JointOrientation.unfavorable,
        generalState: 'Macizo muy fracturado, tiempo de autosoporte corto.',
      ),
      qInput: const QInput(rqd: 30, jn: 12, jr: 1, ja: 4, jw: 0.66, srf: 5),
      excavationType: ExcavationType.ramp,
      spanM: 5.5,
      risk: OperationalRisk.high,
      questions: <CaseQuestion>[
        CaseQuestion(
          prompt: '¿Qué ocurre con el tiempo de autosostenimiento?',
          options: <String>[
            'Aumenta porque los bloques son pequeños',
            'Se reduce drásticamente, del orden de horas',
            'No cambia respecto a la clase III',
          ],
          correctIndex: 1,
          feedback: 'En clase IV el techo puede empezar a descostrarse en las '
              'primeras horas posteriores al disparo.',
        ),
        CaseQuestion(
          prompt: '¿Cuál es la secuencia correcta?',
          options: <String>[
            'Avanzar y sostener al final del tramo',
            'Sostener inmediatamente después de cada disparo',
            'Esperar a que el macizo se acomode',
          ],
          correctIndex: 1,
          feedback:
              'El sostenimiento debe seguir al avance; postergarlo expone '
              'al personal durante el período más crítico.',
        ),
      ],
      technicalFeedback:
          'La combinación de relleno arcilloso, agua y esfuerzos en zona de '
          'falla exige shotcrete o pernos con malla instalados de inmediato, '
          'y control de convergencia.',
      wrongChoiceConsequence:
          'Avanzar sin sostenimiento inmediato en clase IV puede provocar '
          'un colapso del techo con atrapamiento de personal y pérdida de '
          'la labor.',
    );
  }

  CaseStudy _waterCase() {
    return CaseStudy(
      id: 'caso-04',
      title: 'Excavación con presencia de agua',
      summary: 'Galería que intercepta una estructura permeable con flujo '
          'continuo.',
      geology: 'Macizo de calidad media atravesado por una estructura abierta '
          'que conduce agua. Se observa lavado del relleno y goteo '
          'permanente en el techo.',
      rockMass: const RockMassInput(
        ucsMpa: 65,
        rqd: 58,
        spacingM: 0.3,
        jointCondition: JointCondition.poor,
        groundwater: GroundwaterCondition.flowing,
        orientation: JointOrientation.fair,
        generalState: 'Macizo medio degradado por la presencia de agua.',
      ),
      qInput: const QInput(rqd: 58, jn: 9, jr: 1.5, ja: 4, jw: 0.33, srf: 2.5),
      excavationType: ExcavationType.developmentDrift,
      spanM: 4.5,
      risk: OperationalRisk.high,
      questions: <CaseQuestion>[
        CaseQuestion(
          prompt: '¿Por qué el agua reduce tanto el RMR y el Q?',
          options: <String>[
            'Porque disminuye la resistencia de la roca intacta',
            'Porque reduce el esfuerzo efectivo y lava el relleno de las '
                'juntas',
            'Porque aumenta el RQD',
          ],
          correctIndex: 1,
          feedback: 'El agua actúa sobre las discontinuidades: baja la '
              'resistencia al corte y arrastra el material de relleno.',
        ),
        CaseQuestion(
          prompt: '¿Qué medida complementaria es indispensable?',
          options: <String>[
            'Aumentar la longitud del disparo',
            'Drenaje y control del agua antes de sostener',
            'Reducir la ventilación',
          ],
          correctIndex: 1,
          feedback: 'Sin drenaje, el shotcrete no adhiere correctamente y la '
              'presión de agua sigue actuando detrás del sostenimiento.',
        ),
      ],
      technicalFeedback:
          'El agua se trata como un problema geomecánico, no solo '
          'operativo: define el tipo de sostenimiento, el método de '
          'aplicación y la necesidad de drenaje o barrenos de alivio.',
      wrongChoiceConsequence:
          'Aplicar shotcrete sobre una superficie con flujo activo produce '
          'desprendimiento del revestimiento y una falsa sensación de '
          'seguridad.',
    );
  }

  CaseStudy _unfavorableJoints() {
    return CaseStudy(
      id: 'caso-05',
      title: 'Excavación con discontinuidades desfavorables',
      summary: 'Cámara de gran luz con familias paralelas al eje de la labor.',
      geology: 'Roca de resistencia media con dos familias principales de '
          'buzamiento pronunciado, subparalelas al eje de la excavación, '
          'que definen cuñas de gran volumen en el techo.',
      rockMass: const RockMassInput(
        ucsMpa: 90,
        rqd: 70,
        spacingM: 0.7,
        jointCondition: JointCondition.fair,
        groundwater: GroundwaterCondition.damp,
        orientation: JointOrientation.veryUnfavorable,
        generalState: 'Macizo medio con geometría de bloques desfavorable.',
      ),
      qInput: const QInput(rqd: 70, jn: 6, jr: 1, ja: 2, jw: 1, srf: 2.5),
      excavationType: ExcavationType.chamber,
      spanM: 12,
      risk: OperationalRisk.high,
      questions: <CaseQuestion>[
        CaseQuestion(
          prompt: '¿Por qué el RMR baja pese a un RQD aceptable?',
          options: <String>[
            'Por el ajuste negativo de orientación',
            'Porque la resistencia es baja',
            'Porque el espaciamiento es mínimo',
          ],
          correctIndex: 0,
          feedback: 'La orientación muy desfavorable aplica el ajuste máximo '
              'negativo y refleja el riesgo real de cuñas.',
        ),
        CaseQuestion(
          prompt: '¿Qué efecto tiene la luz de 12 m?',
          options: <String>[
            'Ninguno, el sostenimiento depende solo del RMR',
            'Aumenta el área expuesta y el volumen de las cuñas',
            'Reduce la exigencia de sostenimiento',
          ],
          correctIndex: 1,
          feedback:
              'A mayor luz, mayor volumen potencial de bloque inestable y '
              'mayor longitud requerida de los pernos.',
        ),
      ],
      technicalFeedback:
          'En cámaras de gran luz el análisis de cuñas es tan importante '
          'como la clasificación: dos macizos con el mismo RMR pueden '
          'comportarse de forma opuesta según la orientación de sus '
          'familias.',
      wrongChoiceConsequence:
          'Aplicar el criterio de una galería pequeña a una cámara de 12 m '
          'deja pernos demasiado cortos, que no anclan más allá de la cuña '
          'y fallan por arrancamiento.',
    );
  }
}
