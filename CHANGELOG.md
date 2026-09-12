# Changelog

Todas las modificaciones relevantes de **Laboratorio Geomecánico** se
documentan en este archivo. El formato sigue *Keep a Changelog* y el
versionado semántico.

## [1.0.0] - 2026-09-11

### Agregado (MVP)

- Pantalla de **Inicio** con identidad textual, descripción, accesos a los
  siete módulos y advertencia de uso educativo.
- Módulo **Propiedades del macizo rocoso**: resistencia de la roca intacta,
  RQD, espaciamiento, condición de discontinuidades, agua subterránea y
  orientación, con explicación breve de cada parámetro.
- Módulo **Evaluador RMR** (Bieniawski simplificado) con puntaje por
  parámetro, RMR básico, ajuste por orientación, RMR final, clase del
  macizo, descripción de calidad, interpretación educativa y fórmula.
- Módulo **Sistema Q** con Q = (RQD/Jn) x (Jr/Ja) x (Jw/SRF), categoría
  cualitativa, explicación de cada factor y advertencia de contexto.
- Módulo **Selección básica de sostenimiento** con sistema recomendado,
  justificación técnica, nivel de confianza y advertencia profesional.
- Módulo **Casos subterráneos** con cinco casos educativos, preguntas,
  cálculo esperado, retroalimentación y consecuencia de una elección
  inadecuada.
- Módulo **Evaluación práctica** con preguntas de selección múltiple,
  puntaje, respuestas correctas y explicación de errores.
- **Tutor geomecánico local** basado en reglas, sin API externa ni claves.
- Interfaz en español con Material 3, indicadores de riesgo, tarjetas,
  barras de progreso y validación de campos numéricos.
- Pruebas unitarias de calculadoras, clasificaciones, selector de
  sostenimiento y validaciones, más una prueba de widget de la pantalla
  principal.
- Flujos de GitHub Actions: `flutter_ci.yml` (formato, análisis y pruebas)
  y `build_apk.yml` (APK universal como artifact).

### Pendiente para versiones futuras

- Tutor con API de inteligencia artificial (arquitectura ya preparada).
- Tablas RMR/Q configurables por el docente.
- Persistencia de resultados y progreso del estudiante.
- Visualización 2D de la sección de la labor y del sostenimiento.
