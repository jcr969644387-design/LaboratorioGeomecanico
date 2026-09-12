import 'package:flutter/material.dart';

import '../models/quiz_question.dart';
import '../services/quiz_repository.dart';
import '../widgets/section_card.dart';
import '../widgets/value_meter.dart';

/// Evaluación práctica de selección múltiple.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<QuizQuestion> _questions = const QuizRepository().all();
  final Map<String, int> _selected = <String, int>{};

  bool _finished = false;
  int _index = 0;

  QuizQuestion get _current => _questions[_index];

  void _select(int value) {
    setState(() {
      _selected[_current.id] = value;
    });
  }

  void _next() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
      });
      return;
    }
    setState(() {
      _finished = true;
    });
  }

  void _restart() {
    setState(() {
      _selected.clear();
      _index = 0;
      _finished = false;
    });
  }

  QuizResult _buildResult() {
    final List<QuizAnswer> answers = <QuizAnswer>[];
    for (final QuizQuestion question in _questions) {
      answers.add(
        QuizAnswer(
          question: question,
          selectedIndex: _selected[question.id] ?? -1,
        ),
      );
    }
    return QuizResult(answers: answers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Evaluación práctica')),
      body: _finished ? _buildSummary(context) : _buildQuestion(context),
    );
  }

  Widget _buildQuestion(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int? selected = _selected[_current.id];
    final double progress = (_index + 1) / _questions.length;

    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ValueMeter(
            label: 'Pregunta ${_index + 1} de ${_questions.length}',
            value: progress * 100,
            maxValue: 100,
            color: theme.colorScheme.primary,
            trailing: _current.topic,
          ),
        ),
        SectionCard(
          title: _current.prompt,
          icon: Icons.help_outline,
          children: <Widget>[
            ...List<Widget>.generate(_current.options.length, (int i) {
              return RadioListTile<int>(
                value: i,
                groupValue: selected,
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _current.options[i],
                  style: theme.textTheme.bodySmall,
                ),
                onChanged: (int? value) {
                  if (value != null) _select(value);
                },
              );
            }),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: selected == null ? null : _next,
              child: Text(
                _index == _questions.length - 1
                    ? 'Finalizar evaluación'
                    : 'Siguiente pregunta',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummary(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final QuizResult result = _buildResult();

    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 28),
      children: <Widget>[
        SectionCard(
          title: 'Resultado final',
          icon: Icons.emoji_events_outlined,
          children: <Widget>[
            Text(
              '${result.correct} de ${result.total} respuestas correctas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ValueMeter(
              label: 'Puntaje',
              value: result.score20,
              maxValue: 20,
              color: theme.colorScheme.primary,
              trailing: '${result.score20.toStringAsFixed(1)} / 20',
            ),
            const SizedBox(height: 12),
            Text(result.verdict, style: theme.textTheme.bodySmall),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _restart,
              icon: const Icon(Icons.replay),
              label: const Text('Repetir evaluación'),
            ),
          ],
        ),
        ...result.answers.map((QuizAnswer answer) {
          final bool correct = answer.isCorrect;
          final QuizQuestion question = answer.question;
          final String chosen = answer.selectedIndex >= 0
              ? question.options[answer.selectedIndex]
              : 'Sin responder';

          return SectionCard(
            title: question.prompt,
            subtitle: question.topic,
            icon: correct ? Icons.check_circle_outline : Icons.cancel_outlined,
            accentColor: correct ? Colors.green : Colors.redAccent,
            children: <Widget>[
              Text(
                'Tu respuesta: $chosen',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Respuesta correcta: '
                '${question.options[question.correctIndex]}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                question.explanation,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.4),
              ),
            ],
          );
        }),
      ],
    );
  }
}
