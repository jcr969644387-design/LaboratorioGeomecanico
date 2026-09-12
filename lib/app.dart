import 'package:flutter/material.dart';

import 'screens/root_screen.dart';
import 'services/app_state.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';

/// Raíz de la aplicación: crea el estado compartido y el tema Material 3.
class LaboratorioGeomecanicoApp extends StatefulWidget {
  const LaboratorioGeomecanicoApp({super.key});

  @override
  State<LaboratorioGeomecanicoApp> createState() {
    return _LaboratorioGeomecanicoAppState();
  }
}

class _LaboratorioGeomecanicoAppState
    extends State<LaboratorioGeomecanicoApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      notifier: _state,
      child: MaterialApp(
        title: AppInfo.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const RootScreen(),
      ),
    );
  }
}
