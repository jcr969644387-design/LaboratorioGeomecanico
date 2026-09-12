import 'package:flutter/material.dart';

/// Opción genérica mostrada por [OptionSelector].
class SelectorOption<T> {
  const SelectorOption({
    required this.value,
    required this.label,
    this.description = '',
  });

  final T value;
  final String label;
  final String description;
}

/// Selector desplegable con descripción del valor elegido.
class OptionSelector<T> extends StatelessWidget {
  const OptionSelector({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<SelectorOption<T>> options;
  final ValueChanged<T> onChanged;

  String _descriptionFor(T current) {
    for (final SelectorOption<T> option in options) {
      if (option.value == current) return option.description;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String description = _descriptionFor(value);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InputDecorator(
            decoration: InputDecoration(labelText: label),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                items: options.map((SelectorOption<T> option) {
                  return DropdownMenuItem<T>(
                    value: option.value,
                    child: Text(
                      option.label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (T? selected) {
                  if (selected != null) onChanged(selected);
                },
              ),
            ),
          ),
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 4, 0),
              child: Text(description, style: theme.textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}
