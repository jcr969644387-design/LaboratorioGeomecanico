import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/validators.dart';

/// Campo numérico con validación de rango y mensaje de error legible.
class NumericField extends StatefulWidget {
  const NumericField({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.helperText = '',
    this.suffix = '',
    this.decimals = 2,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String helperText;
  final String suffix;
  final int decimals;
  final ValueChanged<double> onChanged;

  @override
  State<NumericField> createState() => _NumericFieldState();
}

class _NumericFieldState extends State<NumericField> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.value));
  }

  @override
  void didUpdateWidget(covariant NumericField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final double? current = Validators.parse(_controller.text);
    if (current == null || (current - widget.value).abs() > 0.0001) {
      _controller.text = _format(widget.value);
      _error = null;
    }
  }

  String _format(double value) {
    if (widget.decimals == 0) return value.toStringAsFixed(0);
    final String text = value.toStringAsFixed(widget.decimals);
    if (text.endsWith('.00')) {
      return text.substring(0, text.length - 3);
    }
    return text;
  }

  void _handleChange(String text) {
    final double? parsed = Validators.parse(text);
    final String? message = Validators.range(
      parsed,
      min: widget.min,
      max: widget.max,
      unit: widget.suffix,
    );
    setState(() {
      _error = message;
    });
    if (message == null && parsed != null) {
      widget.onChanged(parsed);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        ],
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: _error == null ? widget.helperText : null,
          helperMaxLines: 3,
          errorText: _error,
          errorMaxLines: 2,
          suffixText: widget.suffix.isEmpty ? null : widget.suffix,
        ),
        onChanged: _handleChange,
      ),
    );
  }
}
