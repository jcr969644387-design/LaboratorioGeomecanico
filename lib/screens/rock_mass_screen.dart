import 'package:flutter/material.dart';

import '../models/rock_mass_input.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import '../utils/constants.dart';
import '../widgets/numeric_field.dart';
import '../widgets/option_selector.dart';
import '../widgets/risk_chip.dart';
import '../widgets/section_card.dart';
import '../widgets/value_meter.dart';

/// Módulo de propiedades del macizo rocoso.
class RockMassScreen extends StatelessWidget {
  const RockMassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AppState state = AppStateScope.of(context);
    final RockMassInput input = state.rockMass;
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Text(
            'Propiedades del macizo rocoso',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        SectionCard(
          title: 'Roca intacta y fracturamiento',
          subtitle: 'Datos obtenidos de ensayos y de logueo de testigos.',
          icon: Icons.science_outlined,
          children: <Widget>[
            NumericField(
              label: 'Resistencia a compresión uniaxial',
              suffix: 'MPa',
              value: input.ucsMpa,
              min: Limits.ucsMin,
              max: Limits.ucsMax,
              decimals: 1,
              helperText:
                  'Resistencia de la roca sin fracturas, medida en ensayo '
                  'uniaxial o estimada con martillo Schmidt.',
              onChanged: (double value) {
                state.updateRockMass(input.copyWith(ucsMpa: value));
              },
            ),
            NumericField(
              label: 'RQD',
              suffix: '%',
              value: input.rqd,
              min: Limits.rqdMin,
              max: Limits.rqdMax,
              decimals: 0,
              helperText:
                  'Porcentaje de tramos de testigo sanos mayores a 10 cm '
                  'respecto a la longitud perforada.',
              onChanged: (double value) {
                state.updateRockMass(input.copyWith(rqd: value));
              },
            ),
            NumericField(
              label: 'Espaciamiento de discontinuidades',
              suffix: 'm',
              value: input.spacingM,
              min: Limits.spacingMin,
              max: Limits.spacingMax,
              helperText: 'Distancia media entre juntas de una misma familia. '
                  'Define el tamaño del bloque.',
              onChanged: (double value) {
                state.updateRockMass(input.copyWith(spacingM: value));
              },
            ),
          ],
        ),
        SectionCard(
          title: 'Condición de las discontinuidades',
          subtitle: 'Rugosidad, abertura, relleno y alteración.',
          icon: Icons.layers_outlined,
          children: <Widget>[
            OptionSelector<JointCondition>(
              label: 'Condición de discontinuidades',
              value: input.jointCondition,
              options: JointCondition.values.map((JointCondition item) {
                return SelectorOption<JointCondition>(
                  value: item,
                  label: '${item.label} (${item.rating} pts)',
                  description: item.detail,
                );
              }).toList(),
              onChanged: (JointCondition value) {
                state.updateRockMass(input.copyWith(jointCondition: value));
              },
            ),
            OptionSelector<JointOrientation>(
              label: 'Orientación respecto a la labor',
              value: input.orientation,
              options: JointOrientation.values.map((JointOrientation item) {
                return SelectorOption<JointOrientation>(
                  value: item,
                  label: '${item.label} (${item.adjustment} pts)',
                  description: item.detail,
                );
              }).toList(),
              onChanged: (JointOrientation value) {
                state.updateRockMass(input.copyWith(orientation: value));
              },
            ),
          ],
        ),
        SectionCard(
          title: 'Agua subterránea',
          subtitle: 'Condición observada en el frente y en las cajas.',
          icon: Icons.water_drop_outlined,
          children: <Widget>[
            OptionSelector<GroundwaterCondition>(
              label: 'Presencia de agua',
              value: input.groundwater,
              options:
                  GroundwaterCondition.values.map((GroundwaterCondition e) {
                return SelectorOption<GroundwaterCondition>(
                  value: e,
                  label: '${e.label} (${e.rating} pts)',
                  description: e.detail,
                );
              }).toList(),
              onChanged: (GroundwaterCondition value) {
                state.updateRockMass(input.copyWith(groundwater: value));
              },
            ),
          ],
        ),
        SectionCard(
          title: 'Estado general del macizo',
          subtitle: 'Resumen cualitativo del escenario evaluado.',
          icon: Icons.notes_outlined,
          children: <Widget>[
            Text(
              input.generalState.isEmpty
                  ? 'Sin observaciones registradas.'
                  : input.generalState,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 14),
            ValueMeter(
              label: 'RMR estimado con estos datos',
              value: state.rmrResult.finalRmr.toDouble(),
              maxValue: 100,
              color: AppTheme.riskColor(state.rmrResult.risk),
              trailing: '${state.rmrResult.finalRmr} / 100',
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                RiskChip(level: state.rmrResult.risk),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Clase ${state.rmrResult.classInfo.roman} · '
                    '${state.rmrResult.classInfo.quality}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: state.reset,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Restablecer valores'),
            ),
          ],
        ),
      ],
    );
  }
}
