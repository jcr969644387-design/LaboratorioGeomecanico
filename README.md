# Laboratorio Geomecánico

Laboratorio virtual educativo para experimentar con la resistencia de la
roca, la calidad del macizo rocoso, la estabilidad de labores subterráneas
y la selección preliminar de sistemas de sostenimiento.

> **Advertencia académica.** La aplicación es un **simulador educativo**.
> No reemplaza un estudio geomecánico profesional, una inspección en campo
> ni un diseño de sostenimiento aprobado por un ingeniero responsable.

---

## 1. Descripción del proyecto

`Laboratorio Geomecánico` es una aplicación móvil Flutter, en español, que
funciona **100 % sin conexión a Internet**. El estudiante modifica las
propiedades del macizo rocoso y observa de inmediato el efecto sobre:

- el **RMR** (Rock Mass Rating, versión educativa simplificada),
- el **índice Q** de Barton,
- la **recomendación preliminar de sostenimiento** y su nivel de confianza.

Un **tutor geomecánico local basado en reglas** explica, en cada cambio,
por qué sube o baja la clasificación y qué parámetro la está controlando.

---

## 2. Objetivo educativo

Ayudar a estudiantes de Ingeniería de Minas a comprender cómo las
propiedades de la roca y del macizo rocoso influyen en la estabilidad de
labores subterráneas y en la selección preliminar del sostenimiento,
pasando de la memorización de tablas al **razonamiento causal**:

> *"Si el RQD baja de 70 % a 30 % y aparece agua, ¿qué le ocurre a la clase
> del macizo, al tiempo de autosostenimiento y al sostenimiento requerido?"*

---

## 3. Público objetivo

Estudiantes de Ingeniería de Minas que cursan:

| Curso | Uso principal |
| --- | --- |
| Mecánica de Rocas | Parámetros del macizo, RQD, discontinuidades |
| Geomecánica | Clasificaciones RMR y Q |
| Diseño Minero | Luz de excavación y selección de sostenimiento |
| Seguridad Minera | Riesgo geomecánico y consecuencias de una mala decisión |

---

## 4. Tecnologías utilizadas

- **Flutter** (canal *stable*) y **Dart**.
- **Material 3** con `ColorScheme.fromSeed` y tema claro/oscuro.
- Arquitectura **organizada por capas** (modelos, calculadoras, servicios,
  pantallas, widgets, tema, utilidades).
- Estado compartido con `ChangeNotifier` + `InheritedNotifier`, **sin
  dependencias externas** de gestión de estado.
- **Sin red, sin claves secretas, sin base de datos**: todo el cálculo se
  ejecuta en el dispositivo.
- `flutter_lints` para análisis estático y `flutter_test` para pruebas.
- **GitHub Actions** para integración continua y generación del APK.

---

## 5. Estructura de carpetas

```
lib/
  main.dart            Punto de entrada
  app.dart             MaterialApp, tema y estado raíz
  models/              Entidades y clasificaciones (sin lógica de UI)
  calculators/         RMR, sistema Q y selector de sostenimiento
  services/            Estado de la app, tutor, casos y banco de preguntas
  screens/             Pantallas de los módulos del MVP
  widgets/             Componentes reutilizables de interfaz
  theme/               Paleta y construcción del tema Material 3
  utils/               Constantes, validadores y formateadores
test/                  Pruebas unitarias y de widget
docs/                  Guía académica, fórmulas y arquitectura
assets/images/         Logotipo y recursos gráficos
.github/workflows/     flutter_ci.yml y build_apk.yml
```

---

## 6. Módulos del MVP

1. **Inicio** — identidad, descripción, accesos y advertencia educativa.
2. **Propiedades del macizo rocoso** — UCS, RQD, espaciamiento, condición
   de discontinuidades, agua y orientación, con explicación de cada
   parámetro.
3. **Evaluador RMR** — puntaje por parámetro, suma, ajuste, RMR final,
   clase, calidad, interpretación y fórmula.
4. **Sistema Q** — `Q = (RQD/Jn) x (Jr/Ja) x (Jw/SRF)`, categoría
   cualitativa y explicación de cada factor.
5. **Selección básica de sostenimiento** — sistema recomendado,
   justificación técnica, nivel de confianza y advertencia profesional.
6. **Casos subterráneos** — cinco casos con datos, preguntas, cálculo
   esperado, retroalimentación y consecuencia de una elección inadecuada.
7. **Evaluación práctica** — preguntas de selección múltiple con puntaje,
   respuestas correctas y explicación de los errores.

---

## 7. Ejecutar localmente

Requisitos: Flutter *stable* (3.19 o superior), JDK 17 y un dispositivo o
emulador Android.

```bash
flutter --version
flutter pub get
flutter run
```

Antes del primer `commit` conviene normalizar el formato:

```bash
dart format .
flutter analyze
```

> El flujo de CI ejecuta `dart format --set-exit-if-changed`, por lo que
> cualquier archivo sin formatear detiene la integración continua.

---

## 8. Ejecutar las pruebas

```bash
flutter test
```

Cobertura del MVP:

| Prueba | Verifica |
| --- | --- |
| `rmr_calculator_test.dart` | Puntajes A1–A5, suma, ajuste y RMR final |
| `rmr_classification_test.dart` | Los cinco rangos de clase y sus límites |
| `q_calculator_test.dart` | Fórmula de Q, cocientes y RMR equivalente |
| `q_classification_test.dart` | Categoría cualitativa del macizo |
| `support_selector_test.dart` | Selección de sostenimiento y confianza |
| `validation_test.dart` | Rechazo de valores inválidos |
| `widget_test.dart` | Carga de la pantalla principal y navegación |

---

## 9. Generar el APK

```bash
flutter build apk --release
```

El archivo resultante es un **APK universal** ubicado en:

```
build/app/outputs/flutter-apk/app-release.apk
```

No se utiliza `--split-per-abi`: el proyecto genera **un solo APK**.

La compilación *release* usa la firma de depuración para permitir el build
automático en CI. Para publicar en producción debe configurarse un
*keystore* propio en `android/key.properties`.

---

## 10. Flujo de GitHub Actions

### `.github/workflows/flutter_ci.yml`

Se ejecuta en `push` a `main` y `develop`, y en `pull_request` hacia
`main`:

1. Checkout del repositorio.
2. Configuración de Java 17.
3. Configuración de Flutter *stable*.
4. `flutter pub get`.
5. `dart format --output=none --set-exit-if-changed .`
6. `flutter analyze`
7. `flutter test`

### `.github/workflows/build_apk.yml`

Se ejecuta manualmente (`workflow_dispatch`) o al publicar un tag `v*`:

1. Checkout, Java, Flutter y `flutter pub get`.
2. `flutter test`.
3. `flutter build apk --release`.
4. Verificación del archivo
   `build/app/outputs/flutter-apk/app-release.apk`.
5. Subida con `actions/upload-artifact@v4` del **único archivo APK**, en el
   artifact `laboratorio-geomecanico-apk`.

Para publicar una versión:

```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## 11. Alcance y advertencias

- Las tablas de RMR y Q son **simplificadas con fines educativos** y pueden
  variar según la metodología adoptada.
- El sistema Q **no debe aplicarse fuera de su contexto geomecánico**.
- Las recomendaciones de sostenimiento son **preliminares** y no
  constituyen un diseño definitivo.
- El tutor es **local y basado en reglas**: no realiza llamadas a servicios
  externos ni almacena claves.

---

## 12. Futuras mejoras

- Tutor con **API de inteligencia artificial** (la interfaz `TutorEngine`
  ya está preparada mediante `RemoteAiTutor` y `TutorEngineFactory`).
- Tablas RMR y Q **configurables por el docente** (escala, rangos y pesos).
- **Persistencia** del progreso, historial de escenarios y exportación de
  reportes en PDF.
- **Visualización 2D/3D** de la sección de la labor, las cuñas formadas y
  el sostenimiento propuesto.
- Módulos complementarios: GSI, tiempo de autosostenimiento (Bieniawski),
  análisis de cuñas y curvas de convergencia.
- Modo docente con generación de casos y seguimiento del grupo.

---

## 13. Licencia y uso

Proyecto educativo desarrollado dentro de *Educational Mobile Apps
Factory*. Uso académico; verifique toda aplicación práctica con un
ingeniero responsable.
