import 'package:flutter/material.dart';

import '../services/app_state.dart';
import 'home_screen.dart';
import 'q_system_screen.dart';
import 'rmr_screen.dart';
import 'rock_mass_screen.dart';
import 'support_screen.dart';

/// Contenedor principal con navegación inferior entre los módulos.
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: state.tabIndex,
          children: const <Widget>[
            HomeScreen(),
            RockMassScreen(),
            RmrScreen(),
            QSystemScreen(),
            SupportScreen(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.tabIndex,
        onDestinationSelected: state.setTab,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.terrain_outlined),
            selectedIcon: Icon(Icons.terrain),
            label: 'Macizo',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment),
            label: 'RMR',
          ),
          NavigationDestination(
            icon: Icon(Icons.functions_outlined),
            selectedIcon: Icon(Icons.functions),
            label: 'Sistema Q',
          ),
          NavigationDestination(
            icon: Icon(Icons.construction_outlined),
            selectedIcon: Icon(Icons.construction),
            label: 'Soporte',
          ),
        ],
      ),
    );
  }
}
