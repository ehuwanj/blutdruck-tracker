import 'package:flutter/material.dart';

class ReadingFormField extends StatelessWidget {
  const ReadingFormField({
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.suffixText,
    this.maxLines = 1,
    this.keyboardType,
    this.focusNode,
    this.textInputAction,
    super.key,
  });

  final String label;
  final String? initialValue;
  final String? suffixText;
  final int maxLines;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    // Key by label only — not by current value. Including `initialValue` in
    // the key meant every parent rebuild (which happens on every keystroke as
    // form state updates) destroyed the underlying TextFormField, killed
    // focus + cursor, and re-seeded the text from `initialValue`. That made
    // the weight field unusable past 1–2 digits (the user types "8", the
    // field reseeds to "8.0" and steals focus mid-keystroke).
    return TextFormField(
      key: ValueKey(label),
      initialValue: initialValue,
      keyboardType: keyboardType,
      maxLines: maxLines,
      focusNode: focusNode,
      textInputAction: textInputAction,
      decoration: InputDecoration(labelText: label, suffixText: suffixText),
      onChanged: onChanged,
    );
  }
}
