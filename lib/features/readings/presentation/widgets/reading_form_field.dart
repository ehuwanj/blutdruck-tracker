import 'package:flutter/material.dart';

class ReadingFormField extends StatelessWidget {
  const ReadingFormField({
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.suffixText,
    this.maxLines = 1,
    this.keyboardType,
    super.key,
  });

  final String label;
  final String? initialValue;
  final String? suffixText;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('$label-$initialValue'),
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, suffixText: suffixText),
      onChanged: onChanged,
    );
  }
}
