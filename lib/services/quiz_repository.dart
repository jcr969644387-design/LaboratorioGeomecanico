import '../models/quiz_question.dart';

/// Banco local de preguntas de la evaluación práctica.
class QuizRepository {
  const QuizRepository();

  List<QuizQuestion> all() {
    return <QuizQuestion>[
      const QuizQuestion(
        id: 'q01',
        topic: 'RMR',
        prompt:
            'Un macizo obtiene RMR 45. ¿Qué clase y calidad le corresponde?',
        options: <String>[
          'Clase II, roca buena',
          'Clase III, roca regular',
          'Clase IV, roca mala',
          'Clase V, roca muy mala',
        ],
        correctIndex: 1,
        explanation:
            'El rango 41-60 corresponde a la clase III, roca regular, con '
            'riesgo medio y necesidad de control sistemático de cuñas.',
      ),
      const QuizQuestion(
        id: 'q02',
        topic: 'RMR',
        prompt: '¿Cuál es el parámetro con mayor peso dentro del RMR?',
        options: <String>[
          'Resistencia a compresión uniaxial (15)',
          'RQD (20)',
          'Condición de las discontinuidades (30)',
          'Agua subterránea (15)',
        ],
        correctIndex: 2,
        explanation:
            'La condición de las discontinuidades aporta hasta 30 puntos, '
            'porque la resistencia del macizo la controlan las juntas.',
      ),
      const QuizQuestion(
        id: 'q03',
        topic: 'RQD',
        prompt: '¿Qué mide exactamente el RQD?',
        options: <String>[
          'La resistencia de la roca intacta',
          'El porcentaje de testigos sanos mayores a 10 cm en una corrida',
          'El número de familias de discontinuidades',
          'La presión del agua en las juntas',
        ],
        correctIndex: 1,
        explanation:
            'El RQD es un índice de recuperación: suma los tramos de '
            'testigo mayores a 10 cm y los divide entre la longitud '
            'perforada. Es un indicador del tamaño de bloque.',
      ),
      const QuizQuestion(
        id: 'q04',
        topic: 'Sistema Q',
        prompt: 'En Q = (RQD/Jn) x (Jr/Ja) x (Jw/SRF), ¿qué representa '
            'Jr/Ja?',
        options: <String>[
          'El tamaño del bloque',
          'La resistencia al corte entre bloques',
          'El esfuerzo activo sobre la excavación',
          'La luz de la excavación',
        ],
        correctIndex: 1,
        explanation:
            'RQD/Jn es el tamaño de bloque, Jr/Ja la resistencia al corte '
            'entre bloques y Jw/SRF el esfuerzo activo.',
      ),
      const QuizQuestion(
        id: 'q05',
        topic: 'Sistema Q',
        prompt:
            'Si Ja aumenta por relleno arcilloso, ¿qué ocurre con el Q?',
        options: <String>[
          'Aumenta, porque el relleno rellena las juntas',
          'Disminuye, porque baja la resistencia al corte',
          'No cambia, Ja no interviene en el cálculo',
          'Se vuelve negativo',
        ],
        correctIndex: 1,
        explanation:
            'Ja está en el denominador del cociente Jr/Ja: más alteración '
            'o relleno significa menor resistencia al corte y menor Q.',
      ),
      const QuizQuestion(
        id: 'q06',
        topic: 'Discontinuidades',
        prompt:
            'Dos labores tienen el mismo RMR básico, pero una tiene '
            'familias paralelas al eje con buzamiento hacia la labor. '
            '¿Qué sucede?',
        options: <String>[
          'Ambas se comportan igual',
          'La segunda recibe un ajuste negativo mayor y resulta más '
              'inestable',
          'La segunda mejora su clasificación',
          'El ajuste por orientación solo aplica a taludes',
        ],
        correctIndex: 1,
        explanation:
            'El ajuste B por orientación puede restar hasta 12 puntos en '
            'labores subterráneas y refleja la formación de cuñas '
            'liberadas hacia la excavación.',
      ),
      const QuizQuestion(
        id: 'q07',
        topic: 'Agua subterránea',
        prompt: '¿Por qué la presencia de agua reduce la estabilidad?',
        options: <String>[
          'Porque aumenta la resistencia de la roca intacta',
          'Porque reduce el esfuerzo efectivo y lava el relleno de las '
              'juntas',
          'Porque incrementa el RQD',
          'Porque disminuye el número de familias',
        ],
        correctIndex: 1,
        explanation:
            'La presión de poros reduce el esfuerzo normal efectivo sobre '
            'las discontinuidades y el flujo arrastra el relleno, bajando '
            'la resistencia al corte.',
      ),
      const QuizQuestion(
        id: 'q08',
        topic: 'Sostenimiento',
        prompt:
            'En una labor clase IV con tránsito permanente de personal, '
            '¿qué sostenimiento preliminar es más razonable?',
        options: <String>[
          'Sin sostenimiento, solo desatado',
          'Pernos puntuales',
          'Pernos sistemáticos con malla o shotcrete, instalados de '
              'inmediato',
          'Sostenimiento diferido al final del tramo',
        ],
        correctIndex: 2,
        explanation:
            'En clase IV el tiempo de autosostenimiento es corto: el '
            'sostenimiento debe seguir al avance y retener los fragmentos '
            'sobre el área de trabajo.',
      ),
      const QuizQuestion(
        id: 'q09',
        topic: 'Sostenimiento',
        prompt:
            '¿Qué efecto tiene aumentar la luz de la excavación de 4 m a '
            '12 m manteniendo la misma calidad de macizo?',
        options: <String>[
          'Ninguno, el sostenimiento depende solo del RMR',
          'Aumenta el volumen potencial de bloques y la exigencia de '
              'sostenimiento',
          'Reduce la exigencia porque distribuye los esfuerzos',
          'Obliga a reducir la longitud de los pernos',
        ],
        correctIndex: 1,
        explanation:
            'La luz controla el área expuesta del techo y el tamaño de las '
            'cuñas; a mayor luz se requieren pernos más largos y sistemas '
            'más robustos.',
      ),
      const QuizQuestion(
        id: 'q10',
        topic: 'Riesgos geomecánicos',
        prompt:
            '¿Cuál es el uso correcto de una clasificación geomecánica '
            'como el RMR o el Q?',
        options: <String>[
          'Reemplazar el criterio del ingeniero responsable',
          'Servir como herramienta preliminar que orienta el diseño y se '
              'valida con mapeo y monitoreo',
          'Definir el diseño final de sostenimiento sin más análisis',
          'Aplicarse por igual a cualquier material, incluido el suelo',
        ],
        correctIndex: 1,
        explanation:
            'Las clasificaciones son herramientas empíricas de apoyo: '
            'orientan el diseño preliminar, pero requieren verificación '
            'con mapeo geomecánico, análisis específico y monitoreo.',
      ),
    ];
  }
}
