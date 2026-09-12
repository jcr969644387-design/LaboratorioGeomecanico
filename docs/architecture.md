# Arquitectura de Laboratorio Geomecánico

## 1. Principios

1. **Separación por capas.** El cálculo geomecánico no conoce Flutter; las
   pantallas no contienen fórmulas.
2. **Cálculo puro y determinista.** Las calculadoras son funciones
   estáticas sin estado, lo que las hace directamente testeables.
3. **Cero dependencias externas de runtime.** No hay paquetes de estado,
   red ni base de datos: la app funciona sin conexión.
4. **Preparado para IA, sin IA en el MVP.** El tutor se define como una
   interfaz; la implementación actual es local y basada en reglas.

---

## 2. Diagrama de capas

```
            ┌───────────────────────────────┐
            │           screens/            │  Interfaz y navegación
            │  home, rock_mass, rmr, q,     │
            │  support, cases, quiz         │
            └───────────────┬───────────────┘
                            │ usa
            ┌───────────────▼───────────────┐
            │           widgets/            │  Componentes reutilizables
            └───────────────┬───────────────┘
                            │
            ┌───────────────▼───────────────┐
            │          services/            │  Estado, tutor, repositorios
            │  app_state, tutor_service,    │
            │  case_repository, quiz_repo   │
            └───────────────┬───────────────┘
                            │ orquesta
            ┌───────────────▼───────────────┐
            │        calculators/           │  Lógica geomecánica pura
            │  rmr, q, support_selector     │
            └───────────────┬───────────────┘
                            │ opera sobre
            ┌───────────────▼───────────────┐
            │           models/             │  Entidades y clasificaciones
            └───────────────┬───────────────┘
                            │
            ┌───────────────▼───────────────┐
            │        utils/  theme/         │  Validación, formato, estilo
            └───────────────────────────────┘
```

La dependencia siempre apunta hacia abajo. `models/` y `calculators/` no
importan `package:flutter/material.dart`.

---

## 3. Carpetas

| Carpeta | Contenido | Regla |
| --- | --- | --- |
| `models/` | `RockMassInput`, `RmrResult`, `QInput`, `QResult`, `SupportQuery`, `SupportRecommendation`, `CaseStudy`, `QuizQuestion`, `RiskLevel` | Sin lógica de UI |
| `calculators/` | `RmrCalculator`, `QCalculator`, `SupportSelector` | Funciones estáticas puras |
| `services/` | `AppState`, `LocalRuleTutor`, `CaseRepository`, `QuizRepository` | Orquestación y datos locales |
| `screens/` | Una pantalla por módulo del MVP | Solo composición |
| `widgets/` | `SectionCard`, `NumericField`, `OptionSelector`, `ScoreTable`, `RiskChip`, `ValueMeter`, `TutorPanel`, `DisclaimerBanner` | Reutilizables y sin lógica de dominio |
| `theme/` | `AppColors`, `AppTheme` | Material 3 y colores de riesgo |
| `utils/` | `AppInfo`, `Limits`, `Validators`, `Fmt` | Constantes y utilidades |

---

## 4. Modelos principales

- **`RockMassInput`** — entrada del macizo (UCS, RQD, espaciamiento,
  condición, agua, orientación). Expone `validate()`, que lanza
  `ArgumentError` ante valores fuera de rango físico.
- **`RmrResult`** — puntajes A1–A5, RMR básico, ajuste, RMR final,
  `classInfo` y `weakestParameter` (parámetro más penalizado, usado por el
  tutor).
- **`QInput` / `QResult`** — parámetros de Barton y los tres cocientes
  intermedios (`blockSize`, `shearStrength`, `activeStress`).
- **`SupportQuery` / `SupportRecommendation`** — escenario de excavación y
  recomendación con nivel, elementos, justificación, confianza y riesgo.
- **`CaseStudy`** — caso subterráneo con geología, datos, preguntas,
  retroalimentación y consecuencia.

Los `enum` (`JointCondition`, `GroundwaterCondition`, `JointOrientation`,
`ExcavationType`, `OperationalRisk`) llevan sus etiquetas, descripciones y
puntajes en extensiones, de modo que la tabla vive junto al dominio y no en
la interfaz.

---

## 5. Calculadoras

```dart
RmrResult  RmrCalculator.evaluate(RockMassInput input)
QResult    QCalculator.evaluate(QInput input)
double     QCalculator.equivalentRmr(double q)
SupportRecommendation SupportSelector.select(SupportQuery query)
```

Cada una valida sus entradas y lanza `ArgumentError` con un mensaje en
español cuando el dato es imposible (RQD fuera de 0–100, factores de Q
iguales o menores a cero, luz negativa, RMR fuera de 0–100).

---

## 6. Estado de la aplicación

`AppState` extiende `ChangeNotifier` y se expone mediante
`AppStateScope`, un `InheritedNotifier`. Cada cambio de entrada dispara el
recálculo encadenado:

```
updateRockMass  →  RMR  →  (RQD sincronizado)  →  Q  →  sostenimiento
updateQInput    →  Q    →  sostenimiento
updateSupportQuery      →  sostenimiento
```

Esto produce el efecto pedagógico buscado: **una modificación, una
consecuencia visible**, sin botón de "calcular".

`loadScenario()` permite que un caso subterráneo cargue por completo su
escenario en el laboratorio para que el estudiante siga experimentando.

---

## 7. Servicio de tutor

```dart
abstract class TutorEngine {
  Future<List<TutorMessage>> explain(TutorContext context);
}

class LocalRuleTutor implements TutorEngine { ... }   // MVP
class RemoteAiTutor  implements TutorEngine { ... }   // versión futura
```

`TutorEngineFactory.create()` decide la implementación. El MVP siempre
devuelve `LocalRuleTutor`: **no hay llamadas de red ni claves en el
repositorio**. Para habilitar IA en el futuro basta implementar
`RemoteAiTutor` y cambiar la fábrica; las pantallas no se modifican.

Reglas actuales del tutor: variación del RMR y parámetro más penalizado,
lectura del RQD, efecto de las discontinuidades y su orientación, impacto
del agua y justificación del sostenimiento.

---

## 8. Pantallas

| Pantalla | Archivo | Función |
| --- | --- | --- |
| Contenedor | `root_screen.dart` | `NavigationBar` con `IndexedStack` |
| Inicio | `home_screen.dart` | Identidad, accesos y advertencia |
| Macizo | `rock_mass_screen.dart` | Entradas con explicación por parámetro |
| RMR | `rmr_screen.dart` | Puntajes, clase, fórmula y tutor |
| Sistema Q | `q_system_screen.dart` | Factores, resultado y cocientes |
| Sostenimiento | `support_screen.dart` | Recomendación, confianza y tabla |
| Casos | `cases_screen.dart`, `case_detail_screen.dart` | Cinco escenarios |
| Evaluación | `quiz_screen.dart` | Preguntas, puntaje y explicaciones |

---

## 9. Pruebas

- **Unitarias:** puntajes y clasificación del RMR, fórmula y categorías del
  sistema Q, selección de sostenimiento, nivel de confianza y rechazo de
  valores inválidos.
- **Widget:** carga de la pantalla principal y cambio de módulo mediante la
  navegación inferior.

La lógica geomecánica no depende de Flutter, por lo que sus pruebas se
ejecutan sin construir árboles de widgets.

---

## 10. Integración continua

| Workflow | Disparador | Salida |
| --- | --- | --- |
| `flutter_ci.yml` | push a `main`/`develop`, PR a `main` | Formato, análisis y pruebas |
| `build_apk.yml` | `workflow_dispatch` o tag `v*` | APK universal como artifact |

El APK se genera con `flutter build apk --release` (sin
`--split-per-abi`), se verifica en
`build/app/outputs/flutter-apk/app-release.apk` y se sube con
`actions/upload-artifact@v4` bajo el nombre `laboratorio-geomecanico-apk`.

---

## 11. Evolución prevista

1. **Configuración de tablas** por el docente (escala, rangos y pesos)
   mediante un archivo JSON en `assets/`.
2. **Persistencia local** del progreso con almacenamiento clave-valor.
3. **Tutor con IA** detrás de `TutorEngine`, con la clave gestionada fuera
   del repositorio y modo sin conexión como respaldo.
4. **Visualización 2D** de la sección y las cuñas, como nuevo widget que
   consuma los mismos modelos.
