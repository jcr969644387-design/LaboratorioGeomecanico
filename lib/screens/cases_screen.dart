import 'package:flutter/material.dart';

import '../models/case_study.dart';
import '../services/case_repository.dart';
import 'case_detail_screen.dart';

/// Listado de casos subterráneos educativos.
class CasesScreen extends StatelessWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<CaseStudy> cases = const CaseRepository().all();

    return Scaffold(
      appBar: AppBar(title: const Text('Casos subterráneos')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: cases.length,
        itemBuilder: (BuildContext context, int index) {
          final CaseStudy study = cases[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.colorScheme.secondaryContainer,
                child: Text('${index + 1}'),
              ),
              title: Text(
                study.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                study.summary,
                style: theme.textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return CaseDetailScreen(study: study);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
