import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/disclaimer_banner.dart';
import 'cases_screen.dart';
import 'quiz_screen.dart';

/// Pantalla de inicio con la identidad del laboratorio y los accesos.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppState state = AppStateScope.of(context);

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: <Widget>[
        const _Header(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Text(
            AppInfo.description,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            'Cursos relacionados: ${AppInfo.courses}',
            style: theme.textTheme.bodySmall,
          ),
        ),
        const DisclaimerBanner(message: AppInfo.disclaimer),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Text(
            'Módulos',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _ModuleTile(
          icon: Icons.terrain,
          title: 'Propiedades del macizo rocoso',
          subtitle: 'Ingresa resistencia, RQD, juntas, agua y orientación.',
          onTap: () => state.setTab(1),
        ),
        _ModuleTile(
          icon: Icons.assessment,
          title: 'Evaluador RMR',
          subtitle: 'Puntajes, clase del macizo e interpretación educativa.',
          onTap: () => state.setTab(2),
        ),
        _ModuleTile(
          icon: Icons.functions,
          title: 'Sistema Q',
          subtitle: 'Calculadora de Q y lectura de sus tres cocientes.',
          onTap: () => state.setTab(3),
        ),
        _ModuleTile(
          icon: Icons.construction,
          title: 'Selección básica de sostenimiento',
          subtitle: 'Recomendación preliminar con nivel de confianza.',
          onTap: () => state.setTab(4),
        ),
        _ModuleTile(
          icon: Icons.cases_outlined,
          title: 'Casos subterráneos',
          subtitle: 'Cinco escenarios con datos, preguntas y consecuencias.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const CasesScreen(),
              ),
            );
          },
        ),
        _ModuleTile(
          icon: Icons.quiz_outlined,
          title: 'Evaluación práctica',
          subtitle: 'Preguntas de RMR, Q, agua, juntas y sostenimiento.',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const QuizScreen(),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            'Versión ${AppInfo.version} · ${AppInfo.tablesNote}',
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primary, AppColors.accent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.landscape, color: Colors.white, size: 34),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppInfo.appName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppInfo.tagline,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
