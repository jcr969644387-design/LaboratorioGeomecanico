/// Pregunta de selección múltiple de la evaluación práctica.
class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.topic,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String topic;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}

/// Respuesta registrada por el estudiante.
class QuizAnswer {
  const QuizAnswer({required this.question, required this.selectedIndex});

  final QuizQuestion question;
  final int selectedIndex;

  bool get isCorrect => selectedIndex == question.correctIndex;
}

/// Resultado final de la evaluación.
class QuizResult {
  const QuizResult({required this.answers});

  final List<QuizAnswer> answers;

  int get total => answers.length;

  int get correct {
    int count = 0;
    for (final QuizAnswer answer in answers) {
      if (answer.isCorrect) count++;
    }
    return count;
  }

  double get ratio {
    if (total == 0) return 0;
    return correct / total;
  }

  double get score20 => ratio * 20;

  String get verdict {
    if (ratio >= 0.85) return 'Dominio sólido de los criterios geomecánicos.';
    if (ratio >= 0.6) return 'Buen avance; revisa los temas fallados.';
    if (ratio >= 0.4) {
      return 'Comprensión parcial; conviene repetir los casos.';
    }
    return 'Necesitas repasar los fundamentos antes de continuar.';
  }
}
