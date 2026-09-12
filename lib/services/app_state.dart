import 'package:flutter/widgets.dart';

import '../calculators/q_calculator.dart';
import '../calculators/rmr_calculator.dart';
import '../calculators/support_selector.dart';
import '../models/q_result.dart';
import '../models/rmr_result.dart';
import '../models/rock_mass_input.dart';
import '../models/support_recommendation.dart';
import 'tutor_service.dart';

/// Estado compartido del laboratorio.
///
/// Mantiene las entradas del usuario y recalcula de inmediato el RMR, el
/// índice Q y la recomendación de sostenimiento, de modo que el estudiante
/// observe el efecto de cada parámetro sin pasos intermedios.
class AppState extends ChangeNotifier {
  AppState() {
    _recomputeAll();
  }

  final LocalRuleTutor _tutor = const LocalRuleTutor();

  int _tabIndex = 0;
  RockMassInput _rockMass = RockMassInput.initial();
  QInput _qInput = QInput.initial();
  SupportQuery _supportQuery = SupportQuery.initial();

  late RmrResult _rmrResult;
  QResult? _qResult;
  SupportRecommendation? _support;
  String? _lastError;

  int get tabIndex => _tabIndex;
  RockMassInput get rockMass => _rockMass;
  QInput get qInput => _qInput;
  SupportQuery get supportQuery => _supportQuery;
  RmrResult get rmrResult => _rmrResult;
  QResult? get qResult => _qResult;
  SupportRecommendation? get support => _support;
  String? get lastError => _lastError;

  List<TutorMessage> get tutorMessages {
    return _tutor.buildMessages(
      TutorContext(
        rockMass: _rockMass,
        rmr: _rmrResult,
        q: _qResult,
        support: _support,
      ),
    );
  }

  void setTab(int index) {
    if (index == _tabIndex) return;
    _tabIndex = index;
    notifyListeners();
  }

  void updateRockMass(RockMassInput input) {
    _rockMass = input;
    _qInput = _qInput.copyWith(rqd: input.rqd);
    _recomputeAll();
    notifyListeners();
  }

  void updateQInput(QInput input) {
    _qInput = input;
    _recomputeAll();
    notifyListeners();
  }

  void updateSupportQuery(SupportQuery query) {
    _supportQuery = query;
    _recomputeSupport();
    notifyListeners();
  }

  /// Carga un escenario completo, usado por los casos subterráneos.
  void loadScenario({
    required RockMassInput rockMass,
    required QInput qInput,
    required ExcavationType excavationType,
    required double spanM,
    required OperationalRisk risk,
  }) {
    _rockMass = rockMass;
    _qInput = qInput;
    _supportQuery = _supportQuery.copyWith(
      excavationType: excavationType,
      spanM: spanM,
      risk: risk,
    );
    _recomputeAll();
    notifyListeners();
  }

  void reset() {
    _rockMass = RockMassInput.initial();
    _qInput = QInput.initial();
    _supportQuery = SupportQuery.initial();
    _recomputeAll();
    notifyListeners();
  }

  void _recomputeAll() {
    _lastError = null;
    try {
      _rmrResult = RmrCalculator.evaluate(_rockMass);
    } on ArgumentError catch (error) {
      _lastError = error.message.toString();
      return;
    }
    try {
      _qResult = QCalculator.evaluate(_qInput);
    } on ArgumentError catch (error) {
      _qResult = null;
      _lastError = error.message.toString();
    }
    _recomputeSupport();
  }

  void _recomputeSupport() {
    final QResult? q = _qResult;
    if (q == null) {
      _support = null;
      return;
    }
    _supportQuery = _supportQuery.copyWith(rmr: _rmrResult.finalRmr, q: q.q);
    try {
      _support = SupportSelector.select(_supportQuery);
    } on ArgumentError catch (error) {
      _support = null;
      _lastError = error.message.toString();
    }
  }
}

/// Acceso al [AppState] desde cualquier punto del árbol de widgets.
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final AppStateScope? scope =
        context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No se encontró un AppStateScope en el árbol.');
    return scope!.notifier!;
  }
}
