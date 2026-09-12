import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_geomecanico/app.dart';

void main() {
  testWidgets('la pantalla principal se carga correctamente', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LaboratorioGeomecanicoApp());
    await tester.pump();

    expect(find.text('Laboratorio Geomecánico'), findsWidgets);
    expect(find.text('Módulos'), findsOneWidget);
    expect(find.text('Propiedades del macizo rocoso'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('la navegación inferior cambia de módulo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LaboratorioGeomecanicoApp());
    await tester.pump();

    await tester.tap(find.text('RMR').last);
    await tester.pumpAndSettle();

    expect(find.text('Puntaje por parámetro'), findsOneWidget);
  });
}
