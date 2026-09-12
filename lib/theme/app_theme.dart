import 'package:flutter/material.dart';

import '../models/risk_level.dart';
import 'app_colors.dart';

/// Construcción del tema Material 3 de la aplicación.
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return _build(Brightness.light);
  }

  static ThemeData dark() {
    return _build(Brightness.dark);
  }

  static ThemeData _build(Brightness brightness) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: scheme.primaryContainer,
        foregroundColor: scheme.onPrimaryContainer,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
      dividerTheme: const DividerThemeData(space: 24),
    );
  }

  /// Color asociado a un nivel de riesgo geomecánico.
  static Color riskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return AppColors.riskLow;
      case RiskLevel.medium:
        return AppColors.riskMedium;
      case RiskLevel.high:
        return AppColors.riskHigh;
    }
  }

  static IconData riskIcon(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return Icons.verified_outlined;
      case RiskLevel.medium:
        return Icons.warning_amber_outlined;
      case RiskLevel.high:
        return Icons.dangerous_outlined;
    }
  }
}
